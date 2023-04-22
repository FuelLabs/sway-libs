library;

use std::{bytes::Bytes, storage::{clear_slice, get, get_slice, StorableSlice, store_slice}};
use string::String;

pub struct StorageString {}

impl StorableSlice<String> for StorageString {
    /// Takes a `String` type and saves the underlying data in storage.
    ///
    /// ### Arguments
    ///
    /// * `string` - The string which will be stored.
    ///
    /// ### Number of Storage Accesses
    ///
    /// * Writes: `2`
    ///
    /// ### Examples
    ///
    /// ```sway
    /// storage {
    ///     stored_string: StorageString = StorageString {}
    /// }
    ///
    /// fn foo() {
    ///     let mut string = String::new();
    ///     string.push(5_u8);
    ///     string.push(7_u8);
    ///     string.push(9_u8);
    ///
    ///     storage.stored_string.store(string);
    /// }
    /// ```
    #[storage(write)]
    fn store(self, string: String) {
        let key = __get_storage_key();
        store_slice(key, string.as_raw_slice());
    }

    /// Constructs a `String` type from storage.
    ///
    /// ### Number of Storage Accesses
    ///
    /// * Reads: `2`
    ///
    /// ### Examples
    ///
    /// ```sway
    /// storage {
    ///     stored_string: StorageString = StorageString {}
    /// }
    ///
    /// fn foo() {
    ///     let mut string = String::new();
    ///     string.push(5_u8);
    ///     string.push(7_u8);
    ///     string.push(9_u8);
    ///
    ///     assert(storage.stored_string.load(key).is_none());
    ///     storage.stored_string.store(string);
    ///     let retrieved_string = storage.stored_string.load(key).unwrap();
    ///     assert(string == retrieved_string);
    /// }
    /// ```
    #[storage(read)]
    fn load(self) -> Option<String> {
        let key = __get_storage_key();
        match get_slice(key) {
            Option::Some(slice) => {
                // Uncomment when https://github.com/FuelLabs/sway/issues/4408 is resolved
                // Option::Some(String::from_raw_slice(slice))
                Option::Some(String {
                    bytes: Bytes::from_raw_slice(slice),
                })
            },
            Option::None => Option::None,
        }
    }

    /// Clears a stored `String` in storage.
    ///
    /// ### Number of Storage Accesses
    ///
    /// * Reads: `1`
    /// * Clears: `2`
    ///
    /// ### Examples
    ///
    /// ```sway
    /// storage {
    ///     stored_string: StorageString = StorageString {}
    /// }
    ///
    /// fn foo() {
    ///     let mut string = String::new();
    ///     string.push(5_u8);
    ///     string.push(7_u8);
    ///     string.push(9_u8);
    ///     storage.stored_string.store(string);
    ///
    ///     assert(storage.stored_string.load(key).is_some());
    ///     let cleared = storage.stored_string.clear();
    ///     assert(cleared);
    ///     let retrieved_string = storage.stored_string.load(key);
    ///     assert(retrieved_string.is_none());
    /// }
    /// ```
    #[storage(read, write)]
    fn clear(self) -> bool {
        let key = __get_storage_key();
        clear_slice(key)
    }

    /// Returns the length of `String` in storage.
    ///
    /// ### Number of Storage Accesses
    ///
    /// * Reads: `1`
    ///
    /// ### Examples
    ///
    /// ```sway
    /// storage {
    ///     stored_string: StorageString = StorageString {}
    /// }
    ///
    /// fn foo() {
    ///     let mut string = String::new();
    ///     string.push(5_u8);
    ///     string.push(7_u8);
    ///     string.push(9_u8);
    ///
    ///     assert(storage.stored_string.len() == 0)
    ///     storage.stored_string.store(string);
    ///     assert(storage.stored_string.len() == 3);
    /// }
    /// ```
    #[storage(read)]
    fn len(self) -> u64 {
        get::<u64>(__get_storage_key()).unwrap_or(0)
    }
}
