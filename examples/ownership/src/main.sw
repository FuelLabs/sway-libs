// ANCHOR: example_contract
contract;

use ownership::{
    _owner,
    initialize_ownership,
    only_owner,
    renounce_ownership,
    transfer_ownership,
};
use standards::src5::{SRC5, State};

configurable {
    INITAL_OWNER: Identity = Identity::Address(Address::zero()),
}

impl SRC5 for Contract {
    #[storage(read)]
    fn owner() -> State {
        _owner()
    }
}

abi MyContract {
    #[storage(read, write)]
    fn initialize();
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
    fn initialize() {
        initialize_ownership(INITAL_OWNER);
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
// ANCHOR_END: example_contract
