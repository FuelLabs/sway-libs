export const FUEL_GREEN = '#00f58c';

export const SERVER_URI = process.env.REACT_APP_LOCAL_SERVER
  ? 'http://0.0.0.0:8080'
  : 'https://api.sway-playground.org';

export const DEFAULT_SWAY_CONTRACT = `contract;

abi Counter {
    #[storage(read, write)]
    fn increment(amount: u64) -> u64;

    #[storage(read)]
    fn get() -> u64;
}

storage {
    counter: u64 = 0,
}

impl Counter for Contract {
    #[storage(read, write)]
    fn increment(amount: u64) -> u64 {
        let incremented = storage.counter.read() + amount;
        storage.counter.write(incremented);
        incremented
    }

    #[storage(read)]
    fn get() -> u64 {
        storage.counter.read()
    }
}`;

export const DEFAULT_SOLIDITY_CONTRACT = `pragma solidity ^0.8.24;

contract Counter {
    uint64 count;

    function get() public view returns (uint64) {
        return count;
    }

    function increment() public {
        count += 1;
    }
}`;
