library;

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
    /// ### Number of Storage Accesses
    ///
    /// * Reads: `1`
    /// * Writes: `2`
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use storagemapvec::StorageMapVec;
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
        let len_key = sha256((key, __get_storage_key()));
        let len = get::<u64>(len_key).unwrap_or(0);

        // Storing the value at the current length index (if this is the first item, starts off at 0)
        let key = sha256((key, len, __get_storage_key()));
        store::<V>(key, value);

        // Incrementing the length
        store(len_key, len + 1);
    }

    /// Removes the last element of the vector and returns it, None if empty
    ///
    /// ### Arguments
    ///
    /// * `key` - The key to the vector
    ///
    /// ### Number of Storage Accesses
    ///
    /// * Reads: `2`
    /// * Writes: `1`
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use storagemapvec::StorageMapVec;
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
        let len_key = sha256((key, __get_storage_key()));
        let len = get::<u64>(len_key).unwrap_or(0);
        // if the length is 0, there is no item to pop from the vec
        if len == 0 {
            return Option::None;
        }

        // reduces len by 1, effectively removing the last item in the vec
        store(len_key, len - 1);

        let key = sha256((key, len - 1, __get_storage_key()));
        get::<V>(key)
    }

    /// Gets the value in the given index, None if index is out of bounds
    ///
    /// ### Arguments
    ///
    /// * `key` - The key to the vector
    /// * `index` - The index of the vec to retrieve the item from
    ///
    /// ### Number of Storage Accesses
    ///
    /// * Reads: `2`
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use storagemapvec::StorageMapVec;
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
        let len_key = sha256((key, __get_storage_key()));
        let len = get::<u64>(len_key).unwrap_or(0);
        // if the index is larger or equal to len, there is no item to return
        if len <= index {
            return Option::None;
        }

        let key = sha256((key, index, __get_storage_key()));
        get::<V>(key)
    }

    /// Returns the length of the vector
    ///
    /// ### Arguments
    ///
    /// * `key` - The key to the vector
    ///
    /// ### Number of Storage Accesses
    ///
    /// * Reads: `1`
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use storagemapvec::StorageMapVec;
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
        let len_key = sha256((key, __get_storage_key()));
        get::<u64>(len_key).unwrap_or(0)
    }

    /// Checks whether the len is 0 or not
    ///
    /// ### Arguments
    ///
    /// * `key` - The key to the vector
    ///
    /// ### Number of Storage Accesses
    ///
    /// * Reads: `1`
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use storagemapvec::StorageMapVec;
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
        let len_key = sha256((key, __get_storage_key()));
        let len = get::<u64>(len_key).unwrap_or(0);
        len == 0
    }

    /// Sets the len to 0
    ///
    /// ### Arguments
    ///
    /// * `key` - The key to the vector
    ///
    /// ### Number of Storage Accesses
    ///
    /// * Writes: `1`
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use storagemapvec::StorageMapVec;
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
        let len_key = sha256((key, __get_storage_key()));
        store(len_key, 0);
    }

    /// Returns a Vec of all the items in the StorageVec
    ///
    /// ### Arguments
    ///
    /// * `key` - The key to the vector
    ///
    /// ### Number of Storage Accesses
    ///
    /// * Reads: `n + 1`
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use storagemapvec::StorageMapVec;
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
        let len_key = sha256((key, __get_storage_key()));
        let len = get::<u64>(len_key).unwrap_or(0);
        let mut i = 0;
        let mut vec = Vec::new();
        while len > i {
            let len_key = sha256((key, i, __get_storage_key()));
            let item = get::<V>(len_key).unwrap();
            vec.push(item);
            i += 1;
        }
        vec
    }

    /// Swaps the position of two items in the vector
    ///
    /// ### Arguments
    ///
    /// * `key` - The key to the vector
    /// * `index_a` - The index of the first item
    /// * `index_b` - The index of the second item
    ///
    /// ### Number of Storage Accesses
    ///
    /// * Reads: `3`
    /// * Writes: `2`
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use storagemapvec::StorageMapVec;
    ///
    /// storage {
    ///     map_vec: StorageMapVec<u64, bool> = StorageMapVec {}
    /// }
    ///
    /// fn foo() {
    ///     let five = 5_u64;
    ///     storage.map_vec.push(five, true);
    ///     storage.map_vec.push(five, false);
    ///     storage.map_vec.swap(five, 0, 1);
    ///     assert(2 == storage.map_vec.len(five));
    ///     assert(false == storage.map_vec.get(five, 0));
    ///     assert(true == storage.map_vec.get(five, 1));
    /// }
    /// ```
    #[storage(read, write)]
    pub fn swap(self, key: K, index_a: u64, index_b: u64) {
        let len_key = sha256((key, __get_storage_key()));
        let len = get::<u64>(len_key).unwrap_or(0);
        assert(len > index_a);
        assert(len > index_b);
        let item_a_key = sha256((key, index_a, __get_storage_key()));
        let item_b_key = sha256((key, index_b, __get_storage_key()));
        let item_a = get::<V>(item_a_key).unwrap();
        let item_b = get::<V>(item_b_key).unwrap();
        store(item_a_key, item_b);
        store(item_b_key, item_a);
    }

    /// Swaps the position of the given item with the last item in the vector and then pops the last item
    ///
    /// ### Arguments
    ///
    /// * `key` - The key to the vector
    /// * `index` - The index of the item to remove
    ///
    /// ### Number of Storage Accesses
    ///
    /// * Reads: `3`
    /// * Writes: `2`
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use storagemapvec::StorageMapVec;
    ///
    /// storage {
    ///     map_vec: StorageMapVec<u64, bool> = StorageMapVec {}
    /// }
    ///
    /// fn foo() {
    ///     let five = 5_u64;
    ///     storage.map_vec.push(five, true);
    ///     storage.map_vec.push(five, false);
    ///     storage.map_vec.swap_remove(five, 0);
    ///     assert(1 == storage.map_vec.len(five));
    ///     assert(false == storage.map_vec.get(five, 0));
    /// }
    /// ```
    #[storage(read, write)]
    pub fn swap_remove(self, key: K, index: u64) -> V {
        let len_key = sha256((key, __get_storage_key()));
        let len = get::<u64>(len_key).unwrap_or(0);
        assert(len > index);
        let item_key = sha256((key, index, __get_storage_key()));
        let item = get::<V>(item_key).unwrap();
        let last_item_key = sha256((key, len - 1, __get_storage_key()));
        let last_item = get::<V>(last_item_key).unwrap();
        store(item_key, last_item);
        store(len_key, len - 1);
        item
    }

    /// Removes the item at a specified index and returns it
    ///
    /// ### Arguments
    ///
    /// * `key` - The key to the vector
    /// * `index` - The index of the item to remove
    ///
    /// ### Number of Storage Accesses
    ///
    /// * Reads: `n + 2`
    /// * Writes: `n + 1`
    ///
    /// ### Examples
    ///
    /// ```sway
    /// use storagemapvec::StorageMapVec;
    ///
    /// storage {
    ///     map_vec: StorageMapVec<u64, bool> = StorageMapVec {}
    /// }
    ///
    /// fn foo() {
    ///     let five = 5_u64;
    ///     storage.map_vec.push(five, true);
    ///     storage.map_vec.push(five, false);
    ///     storage.map_vec.push(five, true);
    ///     storage.map_vec.remove(five, 1);
    ///     assert(2 == storage.map_vec.len(five));
    ///     assert(true == storage.map_vec.get(five, 0));
    ///     assert(true == storage.map_vec.get(five, 1));
    /// }
    /// ```
    #[storage(read, write)]
    pub fn remove(self, key: K, index: u64) -> V {
        // get the key to the length of the vector
        let len_key = sha256((key, __get_storage_key())); 
        // get the length of the vector
        let len = get::<u64>(len_key).unwrap_or(0);

        // assert that the index is less than the length of the vector to prevent out of bounds errors
        assert(len > index);

        // get the key to the item at the given index
        let removed_item_key = sha256((key, index, __get_storage_key()));
        // get the item at the given index
        let removed_item = get::<V>(removed_item_key).unwrap();

        // create a counter to iterate through the vector, starting from the next item from the given index
        let mut count = index + 1;

        // while the counter is less than the length of the vector
        // this will move all items after the given index to the left by one
        while count < len {
            // get the key to the item at the current counter
            let item_key = sha256((key, count - 1, __get_storage_key()));
            // store the item at the current counter in the key to the item at the current counter - 1
            store::<V>(item_key, get::<V>(sha256((key, count, __get_storage_key()))).unwrap());
            // increment the counter
            count += 1;
        }

        // store the length of the vector - 1 in the key to the length of the vector
        store(len_key, len - 1);

        // return the removed item
        removed_item
    }
}
