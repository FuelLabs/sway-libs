contract;

use sway_libs::storagemapvec::StorageMapVec;

storage {
    mapvec: StorageMapVec<u64, u64> = StorageMapVec {},
}

abi TestContract {
    #[storage(read, write)]
    fn push(key: u64, value: u64);
    #[storage(read, write)]
    fn pop(key: u64, value: u64) -> Option<u64>;
    
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
}
