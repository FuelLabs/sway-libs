contract;

configurable {
    VALUE: u64 = 1,
}

abi MyContract {
    fn test_function() -> u64;
}

impl MyContract for Contract {
    // All this contract does is return the stored configurable value
    fn test_function() -> u64 {
        VALUE
    }
}
