contract;

use std::bytes::Bytes;
use string::String;
use storage_string::StorageString;

storage {
    stored_string: StorageString = StorageString {},
}

abi MyContract {
    #[storage(read, write)]
    fn clear_string() -> bool;
    #[storage(read)]
    fn get_string() -> Option<Vec<u8>>;
    #[storage(write)]
    fn store_string(string: Vec<u8>);
    #[storage(read)]
    fn stored_len() -> u64;
}

impl MyContract for Contract {
    #[storage(read, write)]
    fn clear_string() -> bool {
        storage.stored_string.clear()
    }

    #[storage(read)]
    fn get_string() -> Option<Vec<u8>> {
        Option::Some(storage.stored_string.load().unwrap().as_vec())
    }

    #[storage(write)]
    fn store_string(string: Vec<u8>) {
        storage.stored_string.store(String::from_utf8(string));
    }

    #[storage(read)]
    fn stored_len() -> u64 {
        storage.stored_string.len()
    }
}
