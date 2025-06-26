contract;

// ANCHOR: import
use reentrancy::*;
// ANCHOR_END: import

// ANCHOR: reentrancy_guard
use reentrancy::reentrancy_guard;

abi MyContract {
    fn my_non_reentrant_function();
}

impl MyContract for Contract {
    fn my_non_reentrant_function() {
        reentrancy_guard();

        // my code here
    }
}
// ANCHOR_END: reentrancy_guard

// ANCHOR: is_reentrant
use reentrancy::is_reentrant;

fn check_if_reentrant() {
    assert(!is_reentrant());
}
// ANCHOR_END: is_reentrant
