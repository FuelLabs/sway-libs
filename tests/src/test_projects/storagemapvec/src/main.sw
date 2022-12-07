contract;

use sway_libs::storagemapvec::StorageMapVec;

storage {
    mapvec: StorageMapVec<u64, u64> = StorageMapVec {},
}

abi TestContract {
    #[storage(read, write)]
    fn push(key: u64, value: u64);

    #[storage(read, write)]
    fn pop(key: u64) -> Option<u64>;

    #[storage(read)]
    fn get(key: u64, index: u64) -> Option<u64>;

    #[storage(read)]
    fn len(key: u64) -> u64;

    #[storage(read)]
    fn is_empty(key: u64) -> bool;

    #[storage(write)]
    fn clear(key: u64);

    // #[storage(read)]
    // fn to_vec(key: u64) -> Vec<u64>;
}

impl TestContract for Contract {
    #[storage(read, write)]
    fn push(key: u64, value: u64) {
        storage.mapvec.push(key, value);
    }

    #[storage(read, write)]
    fn pop(key: u64) -> Option<u64> {
        storage.mapvec.pop(key)
    }

    #[storage(read)]
    fn get(key: u64, index: u64) -> Option<u64> {
        storage.mapvec.get(key, index)
    }

    #[storage(read)]
    fn len(key: u64) -> u64 {
        storage.mapvec.len(key)
    }

    #[storage(read)]
    fn is_empty(key: u64) -> bool {
        storage.mapvec.is_empty(key)
    }

    #[storage(write)]
    fn clear(key: u64) {
        storage.mapvec.clear(key)
    }

    // #[storage(read)]
    // fn to_vec(key: u64) -> Vec<u64> {
        // storage.mapvec.to_vec(key)
    // }
}
