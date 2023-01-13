contract;

use sway_libs::ownable::{data_structures::State, only_owner, owner, renounce_ownership, set_ownership, state, transfer_ownership};

abi OwnableTest {
    #[storage(read)]
    fn only_owner();
    #[storage(read)]
    fn owner() -> Option<Identity>;
    #[storage(read, write)]
    fn renounce_ownership();
    #[storage(read, write)]
    fn set_ownership(new_owner: Identity);
    #[storage(read)]
    fn state() -> State;
    #[storage(read, write)]
    fn transfer_ownership(new_owner: Identity);
}

impl OwnableTest for Contract {
    #[storage(read)]
    fn only_owner() {
        only_owner();
    }

    #[storage(read)]
    fn owner() -> Option<Identity> {
        owner()
    }

    #[storage(read, write)]
    fn renounce_ownership() {
        renounce_ownership();
    }

    #[storage(read, write)]
    fn set_ownership(new_owner: Identity) {
        set_ownership(new_owner);
    }

    #[storage(read)]
    fn state() -> State {
        state()
    }

    #[storage(read, write)]
    fn transfer_ownership(new_owner: Identity) {
        transfer_ownership(new_owner);
    }
}
