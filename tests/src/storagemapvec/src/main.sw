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

    #[storage(read)]
    fn to_vec_as_tup(key: u64) -> (u64, u64, u64);

    #[storage(read, write)]
    fn swap(key: u64, index_a: u64, index_b: u64);

    #[storage(read, write)]
    fn swap_remove(key: u64, index: u64) -> u64;

    // #[storage(read, write)]
    // fn insert(key: u64, index: u64, value: u64);

    #[storage(read, write)]
    fn remove(key: u64, index: u64) -> u64;
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

    #[storage(read)]
    fn to_vec_as_tup(key: u64) -> (u64, u64, u64) {
        let vec = storage.mapvec.to_vec(key);
        (vec.get(0).unwrap(), vec.get(1).unwrap(), vec.get(2).unwrap())
    }

    #[storage(read, write)]
    fn swap(key: u64, index_a: u64, index_b: u64) {
        storage.mapvec.swap(key, index_a, index_b)
    }

    #[storage(read, write)]
    fn swap_remove(key: u64, index: u64) -> u64 {
        storage.mapvec.swap_remove(key, index)
    }

    // #[storage(read, write)]
    // fn insert(key: u64, index: u64, value: u64) {
    //     storage.mapvec.insert(key, index, value)
    // }

    #[storage(read, write)]
    fn remove(key: u64, index: u64) -> u64 {
        storage.mapvec.remove(key, index)
    }
}
