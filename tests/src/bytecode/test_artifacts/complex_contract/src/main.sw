contract;

use std::{constants::ZERO_B256, hash::*, math::*, storage::storage_vec::*,};

struct SimpleStruct {
    x: u32,
    y: b256,
}

enum SimpleEnum {
    X: (),
    Y: b256,
    Z: (b256, b256),
}

configurable {
    VALUE: u64 = 1,
    STRUCT: SimpleStruct = SimpleStruct {
        x: 0u32,
        y: ZERO_B256,
    },
    ENUM: SimpleEnum = SimpleEnum::X,
}

abi ComplexContract {
    #[storage(read, write)]
    fn push(value: [u8; 3]);
    #[storage(read, write)]
    fn pop() -> [u8; 3];
    #[storage(read)]
    fn get(index: u64) -> [u8; 3];
    #[storage(read, write)]
    fn remove(index: u64) -> [u8; 3];
    #[storage(read, write)]
    fn swap_remove(index: u64) -> [u8; 3];
    #[storage(read, write)]
    fn set(index: u64, value: [u8; 3]);
    #[storage(read, write)]
    fn insert(index: u64, value: [u8; 3]);
    #[storage(read)]
    fn len() -> u64;
    #[storage(read)]
    fn is_empty() -> bool;
    #[storage(write)]
    fn clear();
    #[storage(read, write)]
    fn swap(index_0: u64, index_1: u64);
    #[storage(read)]
    fn first() -> [u8; 3];
    fn return_configurables() -> (u64, SimpleStruct, SimpleEnum);
}

storage {
    my_vec: StorageVec<[u8; 3]> = StorageVec {},
}

impl ComplexContract for Contract {
    fn return_configurables() -> (u64, SimpleStruct, SimpleEnum) {
        (VALUE, STRUCT, ENUM)
    }

    #[storage(read, write)]
    fn push(value: [u8; 3]) {
        storage.my_vec.push(value);
    }

    #[storage(read, write)]
    fn pop() -> [u8; 3] {
        storage.my_vec.pop().unwrap()
    }

    #[storage(read)]
    fn get(index: u64) -> [u8; 3] {
        storage.my_vec.get(index).unwrap().read()
    }

    #[storage(read, write)]
    fn remove(index: u64) -> [u8; 3] {
        storage.my_vec.remove(index)
    }

    #[storage(read, write)]
    fn swap_remove(index: u64) -> [u8; 3] {
        storage.my_vec.swap_remove(index)
    }

    #[storage(read, write)]
    fn set(index: u64, value: [u8; 3]) {
        storage.my_vec.set(index, value);
    }

    #[storage(read, write)]
    fn insert(index: u64, value: [u8; 3]) {
        storage.my_vec.insert(index, value);
    }

    #[storage(read)]
    fn len() -> u64 {
        storage.my_vec.len()
    }

    #[storage(read)]
    fn is_empty() -> bool {
        storage.my_vec.is_empty()
    }

    #[storage(write)]
    fn clear() {
        storage.my_vec.clear();
    }

    #[storage(read, write)]
    fn swap(index_0: u64, index_1: u64) {
        storage.my_vec.swap(index_0, index_1);
    }

    #[storage(read)]
    fn first() -> [u8; 3] {
        storage.my_vec.first().unwrap().read()
    }
}
