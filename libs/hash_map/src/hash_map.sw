library;

use std::{
    alloc::alloc,
    hash::*,
    iterator::Iterator,
};

pub enum HashMapError<V> {
    OccupiedError: V,
}

impl<V> PartialEq for HashMapError<V>
where 
    V: PartialEq,
{
    fn eq(self, other: Self) -> bool {
        match (self, other) {
            (Self::OccupiedError(val_1), Self::OccupiedError(val_2)) => {
                val_1 == val_2
            }
        }
    }
}

impl<V> Eq for HashMapError<V> 
where
    V: Eq,
{}

pub struct HashMap<K, V> {
    cap: u16,
    len: u16,
    values: raw_ptr,
    keys: raw_ptr,
    indexes: raw_ptr,
}

impl<K, V> HashMap<K, V>
where
    K: Eq,
    K: Hash,
{
    // Internal use: Reads the key K at a given index
    fn read_key(self, computed_index: u64) -> K {
        if __is_reference_type::<K>() {
            asm(ptr: self.keys, offset: __size_of::<K>() * computed_index, new) {
                add new ptr offset;
                new: K
            }
        } else if __size_of::<K>() == 1 {
            asm(ptr: self.keys, offset: computed_index, new, val) {
                add new ptr offset;
                lb val new i0;
                val: K
            }
        } else {
            asm(ptr: self.keys, offset: __size_of::<K>() * computed_index, new, val) {
                add new ptr offset;
                lw val new i0;
                val: K
            }
        }
    }

    // Internal use: Writes a key K at a given index
    fn write_key(ref mut self, computed_index: u64, key: K) {
        if __is_reference_type::<K>() {
            asm(
                ptr: self.keys,
                val: key,
                offset: __size_of::<K>() * computed_index,
                size: __size_of::<K>(),
                new,
            ) {
                add new ptr offset;
                mcp new val size;
            };
        } else if __size_of::<K>() == 1 {
            asm(
                ptr: self.keys,
                val: key,
                offset: computed_index,
                new,
            ) {
                add new ptr offset;
                sb new val i0;
            };
        } else {
            asm(
                ptr: self.keys,
                val: key,
                offset: __size_of::<K>() * computed_index,
                new,
            ) {
                add new ptr offset;
                sw new val i0;
            };
        }
    }

    // Internal use: Reads the value V at a given index
    fn read_value(self, computed_index: u64) -> V {
        if __is_reference_type::<V>() {
            asm(ptr: self.values, offset: __size_of::<V>() * computed_index, new) {
                add new ptr offset;
                new: V
            }
        } else if __size_of::<V>() == 1 {
            asm(ptr: self.values, offset: computed_index, new, val) {
                add new ptr offset;
                lb val new i0;
                val: V
            }
        } else {
            asm(ptr: self.values, offset: __size_of::<V>() * computed_index, new, val) {
                add new ptr offset;
                lw val new i0;
                val: V
            }
        }
    }

    // Internal use: Writes a value V at a given index
    fn write_value(ref mut self, computed_index: u64, val: V) {
        if __is_reference_type::<V>() {
            asm(
                ptr: self.values,
                val: val,
                offset: __size_of::<V>() * computed_index,
                size: __size_of::<V>(),
                new,
            ) {
                add new ptr offset;
                mcp new val size;
            };
        } else if __size_of::<V>() == 1 {
            asm(
                ptr: self.values,
                val: val,
                offset: computed_index,
                new,
            ) {
                add new ptr offset;
                sb new val i0;
            };
        } else {
            asm(
                ptr: self.values,
                val: val,
                offset: __size_of::<V>() * computed_index,
                new,
            ) {
                add new ptr offset;
                sw new val i0;
            };
        }
    }

    // Internal use: Computes a hash for a given key.
    fn get_hash(self, key: K) -> u64 {
        let hash = sha256(key);
        let (r0, r1, r2, r3) = asm(ptr: __addr_of(hash)) {
            ptr: (u64, u64, u64, u64)
        };
        let result = r0 ^ r1 ^ r2 ^ r3;
        result
    }

    // Internal use: Returns the key found at a given index and whether the index had been used before
    fn key_at_index(self, computed_index: u64) -> (Option<K>, bool) {
        let value_set = asm(ptr: self.indexes, offset: computed_index, new, val) {
            add new ptr offset;
            lb val new i0;
            val: u8
        };

        match value_set {
            0u8 => (None, true),
            1u8 => (Some(self.read_key(computed_index)), false),
            _ => (None, false),
        }
    }

    // Internal use: Returns a computed index and a bool as to whether the key is present. Will skip over free indexes if a value has been removed.
    fn compute_index(self, key: K, skip_removed_indexes: bool) -> Option<(u64, bool)> {        
        let mut salt = 0;
        let capacity = asm(val: self.cap) {
            val: u64
        };
        if capacity == 0 {
            return None;
        }

        let mut computed_index = self.get_hash(key) % capacity;
        let (mut key_at_index, mut index_free) = self.key_at_index(computed_index);
        // Collision handling
        while key_at_index != Some(key) {
            salt += 1;

            if salt > capacity {
                return None
            } else if skip_removed_indexes && key_at_index == None && index_free {
                return Some((computed_index, false));
            } else if !skip_removed_indexes && key_at_index == None {
                return Some((computed_index, false));
            }
            computed_index = (self.get_hash(key) + salt) % capacity;
            let result = self.key_at_index(computed_index);
            key_at_index = result.0;
            index_free = result.1;
        }

        Some((computed_index, true))
    }

    // Internal use: Grows the HashMap in size
    fn grow(ref mut self) {
        let old_capacity = asm(val: self.cap) {
            val: u64
        };
        let old_values = self.values;
        let old_keys = self.keys;
        let old_indexes = self.indexes;

        let new_capacity = if old_capacity == 0 {
            1
        } else {
            old_capacity * 2
        };

        self.cap = asm(val: new_capacity) {
            val: u16
        };
        self.keys = asm(size: __size_of::<K>() * new_capacity, ptr) {
            aloc size;
            move ptr hp;
            ptr: raw_ptr
        };
        self.values = asm(size: __size_of::<V>() * new_capacity, ptr) {
            aloc size;
            move ptr hp;
            ptr: raw_ptr
        };
        self.indexes = asm(size: new_capacity, ptr) {
            aloc size;
            move ptr hp;
            ptr: raw_ptr
        };

        // Re-insert to fit new size
        let mut iter = 0;
        while iter < old_capacity {
            if 0u8 == asm(ptr: old_indexes, offset: iter, new, val) {
                add new ptr offset;
                lb val new i0;
                val: u8
            } {
                iter += 1;
                continue;
            }

            let key = if __is_reference_type::<K>() {
                asm(ptr: old_keys, offset: __size_of::<K>() * iter, new) {
                    add new ptr offset;
                    new: K
                }
            } else if __size_of::<K>() == 1 {
                asm(ptr: old_keys, offset: iter, new, val) {
                    add new ptr offset;
                    lb val new i0;
                    val: K
                }
            } else {
                asm(ptr: old_keys, offset: __size_of::<K>() * iter, new, val) {
                    add new ptr offset;
                    lw val new i0;
                    val: K
                }
            };

            let value = if __is_reference_type::<V>() {
                asm(ptr: old_values, offset: __size_of::<V>() * iter, new) {
                    add new ptr offset;
                    new: V
                }
            } else if __size_of::<V>() == 1 {
                asm(ptr: old_values, offset: iter, new, val) {
                    add new ptr offset;
                    lb val new i0;
                    val: V
                }
            } else {
                asm(ptr: old_values, offset: __size_of::<V>() * iter, new, val) {
                    add new ptr offset;
                    lw val new i0;
                    val: V
                }
            };

            let (computed_index, result) = self.compute_index(key, false).unwrap();
            match result {
                true => {
                    self.write_value(computed_index, value);
                },
                false => {
                    self.write_key(computed_index, key);
                    self.write_value(computed_index, value);
                    asm(ptr: self.indexes, val: 1u8, offset: computed_index, new) {
                        add new ptr offset;
                        sb new val i0;
                    };
                },
            }

            iter += 1;
        }
    }

    // Internal use: Returns whether and index is set
    fn is_index_set(self, index: u64) -> bool {
        0u8 != asm(ptr: self.indexes, offset: index, new, val) {
            add new ptr offset;
            lb val new i0;
            val: u8
        }
    }

    /// Returns a new instance of a `HashMap`.
    ///
    /// # Additional Information
    ///
    /// It is recommended to use the `with_capacity()` function to reduce execution costs while filling the map.
    ///
    /// # Returns
    ///
    /// * [HashMap] - A newly instantiated `HashMap`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use hash_map::*;
    ///
    /// fn foo() {
    ///     let my_map: HashMap<u64, u64> = HashMap::new();
    ///     assert(my_map.is_empty());
    ///     assert(my_map.capacity() == 100);
    /// }
    /// ```
    pub fn new() -> Self {
        Self {
            cap: 0,
            len: 0,
            keys: alloc::<raw_ptr>(0),
            values: alloc::<raw_ptr>(0),
            indexes: alloc::<raw_ptr>(0),
        }
    }

    /// Returns a new instance of a `HashMap` with a pre-allocated capacity to hold elements.
    ///
    /// # Additional Information
    ///
    /// This is the recommended function to use when creating a new `HashMap`.
    ///
    /// # Arguments
    ///
    /// * `capacity`: [u16] - The number of elements the `HashMap` should hold.
    ///
    /// # Returns
    ///
    /// * [HashMap] - A newly instantiated `HashMap`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use hash_map::*;
    ///
    /// fn foo() {
    ///     let my_map: HashMap<u64, u64> = HashMap::with_capacity(100);
    ///     assert(my_map.is_empty());
    ///     assert(my_map.capacity() == 100);
    /// }
    /// ```
    pub fn with_capacity(capacity: u16) -> Self {
        let cap = asm(val: capacity) {
            val: u64
        };
        Self {
            cap: capacity,
            len: 0,
            keys: asm(size: __size_of::<K>() * cap, ptr) {
                aloc size;
                move ptr hp;
                ptr: raw_ptr
            },
            values: asm(size: __size_of::<V>() * cap, ptr) {
                aloc size;
                move ptr hp;
                ptr: raw_ptr
            },
            indexes: asm(size: cap, ptr) {
                aloc size;
                move ptr hp;
                ptr: raw_ptr
            },
        }
    }

    /// Inserts a key-value pair into the `HashMap`.
    ///
    /// # Arguments
    ///
    /// * `key`: [K] - The key of the key-value pair.
    /// * `val`: [V] - The value of the key-value pair.
    ///
    /// # Returns
    ///
    /// * [Option<V>] - If the map did not have this key present, `None` is returned. Otherwise `Some(V)`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use hash_map::*;
    ///
    /// fn foo() {
    ///     let mut my_map: HashMap<u64, u64> = HashMap::new();
    ///     assert(my_map.insert(1, 2).is_none());
    ///     assert(my_map.insert(1, 3) == Some(2));
    /// }
    /// ```
    pub fn insert(ref mut self, key: K, val: V) -> Option<V> {
        let (computed_index, result) = match self.compute_index(key, false) {
            Some(computed) => (computed.0, computed.1),
            None => {
                self.grow();
                self.compute_index(key, false).unwrap()
            }
        };

        match result {
            true => {
                let old_val = self.read_value(computed_index);
                self.write_value(computed_index, val);

                return Some(old_val);
            },
            false => {
                self.write_key(computed_index, key);
                self.write_value(computed_index, val);
                asm(ptr: self.indexes, val: 1u8, offset: computed_index, new) {
                    add new ptr offset;
                    sb new val i0;
                };
                self.len += 1;

                return None;
            },
        }
    }

    /// Tries to insert a key-value pair into the map, and returns the value in the entry.
    ///
    /// # Arguments
    ///
    /// * `key`: [K] - The key of the key-value pair.
    /// * `val`: [V] - The value of the key-value pair.
    ///
    /// # Returns
    ///
    /// * [Result<V, HashMapError<V>>] - If the map already had this key present, nothing is updated, and an error containing the occupied entry and the value is returned.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use hash_map::*;
    ///
    /// fn foo() {
    ///     let mut my_map: HashMap<u64, u64> = HashMap::new();
    ///     assert(my_map.try_insert(1, 2).is_ok());
    ///     assert(my_map.insert(1, 3) == Err(HashMapError::OccupiedError(2)));
    /// }
    /// ```
    pub fn try_insert(ref mut self, key: K, val: V) -> Result<V, HashMapError<V>> {
        let (computed_index, result) = match self.compute_index(key, false) {
            Some(computed) => (computed.0, computed.1),
            None => {
                self.grow();
                self.compute_index(key, false).unwrap()
            }
        };

        match result {
            true => {
                let existing_val = self.read_value(computed_index);
                return Err(HashMapError::OccupiedError(existing_val));
            },
            false => {
                self.write_key(computed_index, key);
                self.write_value(computed_index, val);
                asm(ptr: self.indexes, val: 1u8, offset: computed_index, new) {
                    add new ptr offset;
                    sb new val i0;
                };
                self.len += 1;

                return Ok(val);
            },
        }
    }

    /// Removes an key-value pair from the `HashMap`.
    ///
    /// # Arguments
    ///
    /// * `key`: [K] - The key of the key-value pair.
    ///
    /// # Returns
    ///
    /// * [Option<V>] - The value at the key if the key was previously in the map.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use hash_map::*;
    ///
    /// fn foo() {
    ///     let mut my_map: HashMap<u64, u64> = HashMap::new();
    ///     let _ = my_map.insert(1, 2);
    ///     assert(my_map.remove(1) == Some(2));
    ///     assert(my_map.remove(1) == None);
    /// }
    /// ```
    pub fn remove(ref mut self, key: K) -> Option<V> {
        match self.compute_index(key, true) {
            Some(computed) => {
                match computed.1 {
                    true => {
                        asm(ptr: self.indexes, val: 2u8, offset: computed.0, new) {
                            add new ptr offset;
                            sb new val i0;
                        };
                        self.len -= 1;

                        Some(self.values.add::<V>(computed.0).read::<V>())
                    },
                    false => None,
                }
            },
            None => None,
        }
    }

    /// Returns a value from the map given a key.
    ///
    /// # Arguments
    ///
    /// * `key`: [K] - The key of the key-value pair.
    ///
    /// # Returns
    ///
    /// * [Option<V>] - The value associated with the key or `None`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use hash_map::*;
    ///
    /// fn foo () {
    ///     let mut my_map: HashMap<u64, u64> = HashMap::new();
    ///     let _ = my_map.insert(1, 2);
    ///     assert(my_map.get(1) == Some(2));
    ///     assert(my_map.get(3) == None);
    /// }
    /// ```
    pub fn get(self, key: K) -> Option<V> {
        match self.compute_index(key, true) {
            Some(computed) => {
                match computed.1 {
                    true => Some(self.read_value(computed.0)),
                    false => None,
                }
            },
            None => None,
        }
    }

    /// Returns whether a key is present in the `HashMap`.
    ///
    /// # Arguments
    ///
    /// * `key`: [K] - The key of the key-value pair.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` if the key is present, otherwise `false`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use hash_map::*;
    ///
    /// fn foo() {
    ///     let mut my_map = HashMap::new();
    ///     let _ = my_map.insert(1, 2);
    ///     assert(my_map.contains_key(1));
    ///     assert(!my_map.contains_key(3));
    /// }
    /// ```
    pub fn contains_key(self, key: K) -> bool {
        match self.compute_index(key, true) {
            Some(computed) => computed.1,
            None => false,
        }
    }

    /// Returns the list of keys present in the `HashMap`.
    ///
    /// # Additional Information
    ///
    /// The list return is unordered and is not guaranteed to be in the order inserted into the `HashMap`.
    ///
    /// # Returns
    ///
    /// * [Vec<K>] - The list of keys present in the `HashMap`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use hash_map::*;
    ///
    /// fn foo() {
    ///     let mut my_map: HashMap<u64, u64> = HashMap::new();
    ///     assert(my_map.keys().len() == 0);
    ///     let _ = my_map.insert(1, 2);
    ///     let _ = my_map.insert(2, 3);
    ///     let keys = my_map.keys();
    ///     assert(keys.len() == 2);
    /// }
    /// ```
    pub fn keys(self) -> Vec<K> {
        let mut result_vec = Vec::with_capacity(asm(val: self.len) { val: u64 });
        let mut iter = 0;
        while iter < asm(val: self.cap) { val: u64 } {
            if 1u8 != asm(ptr: self.indexes, offset: iter, new, val) {
                add new ptr offset;
                lb val new i0;
                val: u8
            } {
                iter += 1;
                continue;
            }

            result_vec.push(self.read_key(iter));
            iter += 1;
        }

        result_vec
    }

    /// Returns the list of values present in the `HashMap`.
    ///
    /// # Additional Information
    ///
    /// The list return is unordered and is not guaranteed to be in the order inserted into the `HashMap`.
    ///
    /// # Returns
    ///
    /// * [Vec<V>] - The list of values present in the `HashMap`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use hash_map::*;
    ///
    /// fn foo() {
    ///     let mut my_map: HashMap<u64, u64> = HashMap::new();
    ///     assert(my_map.values().len() == 0);
    ///     let _ = my_map.insert(1, 2);
    ///     let _ = my_map.insert(2, 3);
    ///     let values = my_map.values();
    ///     assert(values.len() == 2);
    /// }
    /// ```
    pub fn values(self) -> Vec<V> {
        let mut result_vec = Vec::with_capacity(asm(val: self.len) { val: u64 });
        let mut iter = 0;
        while iter < asm(val: self.cap) { val: u64 } {
            if 1u8 != asm(ptr: self.indexes, offset: iter, new, val) {
                add new ptr offset;
                lb val new i0;
                val: u8
            } {
                iter += 1;
                continue;
            }

            result_vec.push(self.read_value(iter));
            iter += 1;
        }

        result_vec
    }

    /// Returns the number of elements in the `HashMap`.
    ///
    /// # Returns
    ///
    /// * [u16] - The number of elements.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use hash_map::*;
    ///
    /// fn foo() {
    ///     let mut map_map: HashMap<u64, u64> = HashMap::new();
    ///     assert(my_map.len() == 0);
    ///     let _ = my_map.insert(1, 2);
    ///     let _ = my_map.insert(2, 3);
    ///     assert(my_map.len() == 2);
    /// }
    /// ```
    pub fn len(self) -> u16 {
        self.len
    }

    /// Returns the number of elements the `HashMap` can hold.
    ///
    /// # Additional Information
    ///
    /// The capacity is always doubled when space runs out.
    ///
    /// # Returns
    ///
    /// * [u16] - The number of elements the `HashMap` can hold.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use hash_map::*;
    ///
    /// fn foo() {
    ///     let mut map_map: HashMap<u64, u64> = HashMap::new();
    ///     assert(my_map.capacity() == 0);
    ///     let _ = my_map.insert(1, 2);
    ///     let _ = my_map.insert(2, 3);
    ///     let _ = my_map.insert(3, 4);
    ///     assert(my_map.capacity() == 4);
    /// }
    /// ```
    pub fn capacity(self) -> u16 {
        self.cap
    }

    /// Returns whether the `HashMap` contains elements.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` is there are no elements present in the `HashMap`, otherwise `false`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use hash_map::*;
    ///
    /// fn foo() {
    ///     let mut my_map: HashMap<u64, u64> = HashMap::new();
    ///     assert(my_map.is_empty());
    ///     let _ = my_map.insert(1, 2);
    ///     assert(!my_map.is_empty());
    /// }
    /// ```
    pub fn is_empty(self) -> bool {
        self.len == 0
    }

    /// Returns a `HashMapIter` that can be iterated over.
    ///
    /// # Returns
    ///
    /// * [HashMapIter<K, V>] - The `HashMapIter`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use hash_map::*;
    ///
    /// fn foo() {
    ///     let mut my_map: HashMap<u64, u64> = HashMap::new();
    ///     let _ = my_map.insert(1, 2);
    ///     let iterator = my_map.iter();
    ///     assert(iterator.next() == Some((1, 2)));
    ///     assert(iterator.next() == None);
    /// }
    /// ```
    pub fn iter(self) -> HashMapIter<K, V> {
        HashMapIter {
            values: self.values,
            keys: self.keys,
            indexes: self.indexes,
            cap: asm(val: self.cap) { val: u64 },
            index: 0,
        }
    }
}

pub struct HashMapIter<K, V> {
    values: raw_ptr,
    keys: raw_ptr,
    indexes: raw_ptr,
    cap: u64,
    index: u64,
}

impl<K, V> Iterator for HashMapIter<K, V> {
    type Item = (K, V);
    fn next(ref mut self) -> Option<Self::Item> {
        // BEWARE: If the original hashmap gets modified during the iteration
        //         (e.g., elements are removed or added), this modification will not
        //         be reflected in `self.len`.
        //
        //         But since modifying the hashmap during iteration is
        //         considered undefined behavior, this implementation,
        //         that always checks against the length at the time
        //         the iterator got created is perfectly valid.
        if self.index >= self.cap {
            return None
        }

        while self.index < self.cap {
            if 1u8 != asm(ptr: self.indexes, offset: self.index, new, val) {
                add new ptr offset;
                lb val new i0;
                val: u8
            } {
                self.index += 1;
                continue;
            }

            let key = if __is_reference_type::<K>() {
                asm(ptr: self.keys, offset: __size_of::<K>() * self.index, new) {
                    add new ptr offset;
                    new: K
                }
            } else if __size_of::<K>() == 1 {
                asm(ptr: self.keys, offset: self.index, new, val) {
                    add new ptr offset;
                    lb val new i0;
                    val: K
                }
            } else {
                asm(ptr: self.keys, offset: __size_of::<K>() * self.index, new, val) {
                    add new ptr offset;
                    lw val new i0;
                    val: K
                }
            };

            let value = if __is_reference_type::<V>() {
                asm(ptr: self.values, offset: __size_of::<V>() * self.index, new) {
                    add new ptr offset;
                    new: V
                }
            } else if __size_of::<V>() == 1 {
                asm(ptr: self.values, offset: self.index, new, val) {
                    add new ptr offset;
                    lb val new i0;
                    val: V
                }
            } else {
                asm(ptr: self.values, offset: __size_of::<V>() * self.index, new, val) {
                    add new ptr offset;
                    lw val new i0;
                    val: V
                }
            };

            self.index += 1;

            return Some((key, value));
        }

        return None;
    }
}
