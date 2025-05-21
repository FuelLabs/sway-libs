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
    fn initialize();
}

// ANCHOR: ownership_configurable
configurable {
    INITAL_OWNER: Identity = Identity::Address(Address::zero()),
}

impl MyContract for Contract {
    #[storage(read, write)]
    fn initialize() {
        initialize_ownership(INITAL_OWNER);
    }
}
// ANCHOR_END: ownership_configurable
