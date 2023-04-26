library;
/// ** This library has been deprecated. Use of nested storage types is now legal in Sway. **
use std::{hash::sha256, storage::storage_api::{read, write}};

/// A persistant mapping of K -> Vec<V>
pub struct StorageMapVec<K, V> {}

impl<K, V> StorageKey<StorageMapVec<K, V>> {
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
        // The length of the vec is stored in the sha256((key, self.slot)) slot
        let len_key = sha256((key, self.slot));
        let len = read::<u64>(len_key, 0).unwrap_or(0);

        // Storing the value at the current length index (if this is the first item, starts off at 0)
        let key = sha256((key, len, self.slot));
        write::<V>(key, 0, value);

        // Incrementing the length
        write(len_key, 0, len + 1);
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
        // The length of the vec is stored in the sha256((key, self.slot)) slot
        let len_key = sha256((key, self.slot));
        let len = read::<u64>(len_key, 0).unwrap_or(0);
        // if the length is 0, there is no item to pop from the vec
        if len == 0 {
            return Option::None;
        }

        // reduces len by 1, effectively removing the last item in the vec
        write(len_key, 0, len - 1);

        let key = sha256((key, len - 1, self.slot));
        read::<V>(key, 0)
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
        // The length of the vec is stored in the sha256((key, self.slot)) slot
        let len_key = sha256((key, self.slot));
        let len = read::<u64>(len_key, 0).unwrap_or(0);
        // if the index is larger or equal to len, there is no item to return
        if len <= index {
            return Option::None;
        }

        let key = sha256((key, index, self.slot));
        read::<V>(key, 0)
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
        // The length of the vec is stored in the sha256((key, self.slot)) slot
        let len_key = sha256((key, self.slot));
        read::<u64>(len_key, 0).unwrap_or(0)
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
        // The length of the vec is stored in the sha256((key, self.slot)) slot
        let len_key = sha256((key, self.slot));
        let len = read::<u64>(len_key, 0).unwrap_or(0);
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
        // The length of the vec is stored in the sha256((key, self.slot)) slot
        let len_key = sha256((key, self.slot));
        write(len_key, 0, 0);
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
        // The length of the vec is stored in the sha256((key, self.slot)) slot
        let len_key = sha256((key, self.slot));
        let len = read::<u64>(len_key, 0).unwrap_or(0);
        let mut i = 0;
        let mut vec = Vec::new();
        while len > i {
            let len_key = sha256((key, i, self.slot));
            let item = read::<V>(len_key, 0).unwrap();
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
        let len_key = sha256((key, self.slot));
        let len = read::<u64>(len_key, 0).unwrap_or(0);
        assert(len > index_a);
        assert(len > index_b);
        let item_a_key = sha256((key, index_a, self.slot));
        let item_b_key = sha256((key, index_b, self.slot));
        let item_a = read::<V>(item_a_key, 0).unwrap();
        let item_b = read::<V>(item_b_key, 0).unwrap();
        write(item_a_key, 0, item_b);
        write(item_b_key, 0, item_a);
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
        let len_key = sha256((key, self.slot));
        let len = read::<u64>(len_key, 0).unwrap_or(0);
        assert(len > index);
        let item_key = sha256((key, index, self.slot));
        let item = read::<V>(item_key, 0).unwrap();
        let last_item_key = sha256((key, len - 1, self.slot));
        let last_item = read::<V>(last_item_key, 0).unwrap();
        write(item_key, 0, last_item);
        write(len_key, 0, len - 1);
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
        let len_key = sha256((key, self.slot));
        // get the length of the vector
        let len = read::<u64>(len_key, 0).unwrap_or(0);

        // assert that the index is less than the length of the vector to prevent out of bounds errors
        assert(len > index);

        // get the key to the item at the given index
        let removed_item_key = sha256((key, index, self.slot));
        // get the item at the given index
        let removed_item = read::<V>(removed_item_key, 0).unwrap();

        // create a counter to iterate through the vector, starting from the next item from the given index
        let mut count = index + 1;

        // while the counter is less than the length of the vector
        // this will move all items after the given index to the left by one
        while count < len {
            // get the key to the item at the current counter
            let item_key = sha256((key, count - 1, self.slot));
            // store the item at the current counter in the key to the item at the current counter - 1
            write::<V>(item_key, 0, read::<V>(sha256((key, count, self.slot)), 0).unwrap());
            // increment the counter
            count += 1;
        }

        // store the length of the vector - 1 in the key to the length of the vector
        write(len_key, 0, len - 1);

        // return the removed item
        removed_item
    }
}
