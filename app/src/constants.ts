export const FUEL_GREEN = '#00f58c';

// TODO: Determine the URL based on the NODE_ENV.
// export const SERVER_URI = 'https://api.sway-playground.org';
export const SERVER_URI = 'http://0.0.0.0:8080';

export const DEFAULT_SWAY_CONTRACT = `contract;

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
        let incremented = storage.counter.read() + amount;
        storage.counter.write(incremented);
        incremented
    }

    #[storage(read)]
    fn get_counter() -> u64 {
        storage.counter.read()
    }
}`;

export const DEFAULT_SOLIDITY_CONTRACT = `pragma solidity ^0.8.24;

contract Counter {
    uint64 public count;

    // Function to get the current count
    function get_counter() public view returns (uint64) {
        return count;
    }

    // Function to increment count by 1
    function increment_counter() public {
        count += 1;
    }

    // Function to decrement count by 1
    function dec() public {
        // This function will fail if count = 0
        count -= 1;
    }
}`;
