contract;

use ownership::{
    _owner,
    initialize_ownership,
    only_owner,
    renounce_ownership,
    transfer_ownership,
};
use standards::src5::{SRC5, State};

abi OwnableTest {
    #[storage(read)]
    fn only_owner();
    #[storage(read, write)]
    fn renounce_ownership();
    #[storage(read, write)]
    fn set_ownership(new_owner: Identity);
    #[storage(read, write)]
    fn transfer_ownership(new_owner: Identity);
}

impl SRC5 for Contract {
    #[storage(read)]
    fn owner() -> State {
        _owner()
    }
}

impl OwnableTest for Contract {
    #[storage(read)]
    fn only_owner() {
        only_owner();
    }

    #[storage(read, write)]
    fn renounce_ownership() {
        renounce_ownership();
    }

    #[storage(read, write)]
    fn set_ownership(new_owner: Identity) {
        initialize_ownership(new_owner);
    }

    #[storage(read, write)]
    fn transfer_ownership(new_owner: Identity) {
        transfer_ownership(new_owner);
    }
}
