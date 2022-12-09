library storagemapvec;

use std::{hash::sha256, storage::{get, store}};

/// A persistant mapping of K -> Vec<V>
pub struct StorageMapVec<K, V> {}

impl<K, V> StorageMapVec<K, V> {
    /// Appends the value to the end of the vector
    ///
    /// ### Arguments
    ///
    /// * `key` - The key to the vector
    /// * `value` - The item being added to the end of the vector
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use sway_libs::storagemapvec::StorageMapVec;
    ///
    /// storage {
    ///     map_vec: StorageMapVec<u64, bool> = StorageMapVec {}
    /// }
    ///
    /// fn foo() {
    ///     let five = 5_u64;
    ///     storage.map_vec.push(five, true);
    ///     let retrieved_value = storage.map_vec.get(five).unwrap();
    ///     assert(true == retrieved_value);
    /// }
    /// ```
    #[storage(read, write)]
    pub fn push(self, key: K, value: V) {
        // The length of the vec is stored in the sha256((key, __get_storage_key())) slot
        let k = sha256((key, __get_storage_key()));
        let len = get::<u64>(k);

        // Storing the value at the current length index (if this is the first item, starts off at 0)
        let key = sha256((key, len, __get_storage_key()));
        store::<V>(key, value);

        // Incrementing the length
        store(k, len + 1);
    }

    /// Removes the last element of the vector and returns it, None if empty
    ///
    /// ### Arguments
    ///
    /// * `key` - The key to the vector
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use sway_libs::storagemapvec::StorageMapVec;
    ///
    /// storage {
    ///     map_vec: StorageMapVec<u64, bool> = StorageMapVec {}
    /// }
    ///
    /// fn foo() {
    ///     let five = 5_u64;
    ///     storage.map_vec.push(five, true);
    ///     let popped_value = storage.map_vec.pop(five).unwrap();
    ///     assert(true == popped_value);
    ///     let none_value = storage.map_vec.pop(five);
    ///     assert(none_value.is_none())
    /// }
    /// ```
    #[storage(read, write)]
    pub fn pop(self, key: K) -> Option<V> {
        // The length of the vec is stored in the sha256((key, __get_storage_key())) slot
        let k = sha256((key, __get_storage_key()));
        let len = get::<u64>(k);
        // if the length is 0, there is no item to pop from the vec
        if len == 0 {
            return Option::None;
        }

        // reduces len by 1, effectively removing the last item in the vec
        store(k, len - 1);

        let key = sha256((key, len - 1, __get_storage_key()));
        Option::Some::<V>(get::<V>(key))
    }

    /// Gets the value in the given index, None if index is out of bounds
    ///
    /// ### Arguments
    ///
    /// * `key` - The key to the vector
    /// * `index` - The index of the vec to retrieve the item from
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use sway_libs::storagemapvec::StorageMapVec;
    ///
    /// storage {
    ///     map_vec: StorageMapVec<u64, bool> = StorageMapVec {}
    /// }
    ///
    /// fn foo() {
    ///     let five = 5_u64;
    ///     storage.map_vec.push(five, true);
    ///     let retrieved_value = storage.map_vec.get(five, 0).unwrap();
    ///     assert(true == retrieved_value);
    ///     let none_value = storage.map_vec.get(five, 1);
    ///     assert(none_value.is_none())
    /// }
    /// ```
    #[storage(read)]
    pub fn get(self, key: K, index: u64) -> Option<V> {
        // The length of the vec is stored in the sha256((key, __get_storage_key())) slot
        let k = sha256((key, __get_storage_key()));
        let len = get::<u64>(k);
        // if the index is larger or equal to len, there is no item to return
        if len <= index {
            return Option::None;
        }

        let key = sha256((key, index, __get_storage_key()));
        Option::Some::<V>(get::<V>(key))
    }

    /// Returns the length of the vector
    ///
    /// ### Arguments
    ///
    /// * `key` - The key to the vector
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use sway_libs::storagemapvec::StorageMapVec;
    ///
    /// storage {
    ///     map_vec: StorageMapVec<u64, bool> = StorageMapVec {}
    /// }
    ///
    /// fn foo() {
    ///     assert(0 == storage.map_vec.len(5));
    ///     storage.map_vec.push(5, true);
    ///     assert(1 == storage.map_vec.len(5));
    ///     storage.map_vec.push(5, false);
    ///     assert(2 == storage.map_vec.len(5));
    /// }
    /// ```
    #[storage(read)]
    pub fn len(self, key: K) -> u64 {
        // The length of the vec is stored in the sha256((key, __get_storage_key())) slot
        let k = sha256((key, __get_storage_key()));
        get::<u64>(k)
    }

    /// Checks whether the len is 0 or not
    ///
    /// ### Arguments
    ///
    /// * `key` - The key to the vector
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use sway_libs::storagemapvec::StorageMapVec;
    ///
    /// storage {
    ///     map_vec: StorageMapVec<u64, bool> = StorageMapVec {}
    /// }
    ///
    /// fn foo() {
    ///     assert(true == storage.map_vec.is_empty(5));
    ///
    ///     storage.map_vec.push(5, true);
    ///
    ///     assert(false == storage.map_vec.is_empty(5));
    ///
    ///     storage.map_vec.clear(5);
    ///
    ///     assert(true == storage.map_vec.is_empty(5));
    /// }
    /// ```
    #[storage(read)]
    pub fn is_empty(self, key: K) -> bool {
        // The length of the vec is stored in the sha256((key, __get_storage_key())) slot
        let k = sha256((key, __get_storage_key()));
        let len = get::<u64>(k);
        len == 0
    }

    /// Sets the len to 0
    ///
    /// ### Arguments
    ///
    /// * `key` - The key to the vector
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use sway_libs::storagemapvec::StorageMapVec;
    ///
    /// storage {
    ///     map_vec: StorageMapVec<u64, bool> = StorageMapVec {}
    /// }
    ///
    /// fn foo() {
    ///     assert(0 == storage.map_vec.len(5));
    ///     storage.map_vec.push(5, true);
    ///     assert(1 == storage.map_vec.len(5));
    ///     storage.map_vec.clear(5);
    ///     assert(0 == storage.map_vec.len(5));
    /// }
    /// ```
    #[storage(write)]
    pub fn clear(self, key: K) {
        // The length of the vec is stored in the sha256((key, __get_storage_key())) slot
        let k = sha256((key, __get_storage_key()));
        store(k, 0);
    }

    /// Returns a Vec of all the items in the StorageVec
    ///
    /// ### Arguments
    ///
    /// * `key` - The key to the vector
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use sway_libs::storagemapvec::StorageMapVec;
    ///
    /// storage {
    ///     map_vec: StorageMapVec<u64, bool> = StorageMapVec {}
    /// }
    ///
    /// fn foo() {
    ///     let five = 5_u64;
    ///     storage.map_vec.push(five, true);
    ///     storage.map_vec.push(five, false);
    ///     let converted_vec = storage.map_vec.to_vec(five);
    ///     assert(2 == converted_vec.len);
    ///     assert(true == converted_vec.get(0));
    ///     assert(false == converted_vec.get(1));
    /// }
    /// ```
    #[storage(read)]
    pub fn to_vec(self, key: K) -> Vec<V> {
        // The length of the vec is stored in the sha256((key, __get_storage_key())) slot
        let k = sha256((key, __get_storage_key()));
        let len = get::<u64>(k);
        let mut i = 0;
        let mut vec = Vec::new();
        while len > i {
            let k = sha256((key, i, __get_storage_key()));
            let item = get::<V>(k);
            vec.push(item);
            i += 1;
        }
        vec
    }
}
