contract;

abi TestContract {
    #[storage(read, write)]
    fn increment_counter(amount: u64) -> u64;

    #[storage(read)]
    fn get_counter() -> u64;
}

storage {
    counter: u64 = 0,
}

impl TestContract for Contract {
    #[storage(read, write)]
    fn increment_counter(amount: u64) -> u64 {
        let incremented = storage.counter + amount;
        storage.counter = incremented;
        incremented
    }

    #[storage(read)]
    fn get_counter() -> u64 {
        storage.counter
    }
}
