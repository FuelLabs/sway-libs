library;

// ANCHOR: import
use ownership::*;
use src5::*;
// ANCHOR_END: import

// ANCHOR: integrate_with_src5
use ownership::_owner;
use src5::{SRC5, State};

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

// ANCHOR: transfer_ownership
#[storage(read, write)]
fn transfer_contract_ownership(new_owner: Identity) {
    // The caller must be the current owner.
    transfer_ownership(new_owner);
}
// ANCHOR_END: transfer_ownership

// ANCHOR: renouncing_ownership
#[storage(read, write)]
fn renounce_contract_owner() {
    // The caller must be the current owner.
    renounce_ownership();
    // Now no one owns the contract.
}
// ANCHOR_END: renouncing_ownership
