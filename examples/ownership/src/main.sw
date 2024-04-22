library;

// ANCHOR: import
use sway_libs::ownership::*;
use standards::src5::*;
// ANCHOR_END: import

// ANCHOR: integrate_with_src5
use sway_libs::ownership::_owner;
use standards::src5::{SRC5, State};

impl SRC5 for Contract {
    #[storage(read)]
    fn owner() -> State {
        _owner()
    }
}
// ANCHOR_END: integrate_with_src5

// ANCHOR: initialize
#[storage(read, write)]
fn my_constructor(new_owner: Identity) {
    initialize_ownership(new_owner);
}
// ANCHOR_END: initialize

// ANCHOR: only_owner
#[storage(read)]
fn only_owner_may_call() {
    only_owner();
    // Only the contract's owner may reach this line.
}
// ANCHOR_END: only_owner

// ANCHOR: state
#[storage(read)]
fn get_owner_state() {
    let owner: State = _owner();
}
// ANCHOR_END: state
