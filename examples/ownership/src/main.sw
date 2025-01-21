// ANCHOR: example_contract
contract;

use sway_libs::ownership::{
    _owner,
    initialize_ownership,
    only_owner,
    renounce_ownership,
    transfer_ownership,
};
use standards::src5::{SRC5, State};

impl SRC5 for Contract {
    #[storage(read)]
    fn owner() -> State {
        _owner()
    }
}

abi MyContract {
    #[storage(read, write)]
    fn constructor(new_owner: Identity);
    #[storage(read)]
    fn restricted_action();
    #[storage(read, write)]
    fn change_owner(new_owner: Identity);
    #[storage(read, write)]
    fn revoke_ownership();
    #[storage(read)]
    fn get_current_owner() -> State;
}

impl MyContract for Contract {
    #[storage(read, write)]
    fn constructor(new_owner: Identity) {
        initialize_ownership(new_owner);
    }

    // A function restricted to the owner
    #[storage(read)]
    fn restricted_action() {
        only_owner();
        // Protected action
    }

    // Transfer ownership
    #[storage(read, write)]
    fn change_owner(new_owner: Identity) {
        transfer_ownership(new_owner);
    }

    // Renounce ownership
    #[storage(read, write)]
    fn revoke_ownership() {
        renounce_ownership();
    }

    // Get current owner state
    #[storage(read)]
    fn get_current_owner() -> State {
        _owner()
    }
}
// ANCHOR: example_contract
