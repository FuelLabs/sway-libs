contract;

use ownership::ownable::{
    data_structures::State,
    only_owner,
    owner,
    renounce_ownership,
    set_ownership,
    transfer_ownership,
};

abi OwnableTest {
    #[storage(read)]
    fn only_owner();
    #[storage(read)]
    fn owner() -> State;
    #[storage(read, write)]
    fn renounce_ownership();
    #[storage(read, write)]
    fn set_ownership(new_owner: Identity);
    #[storage(read, write)]
    fn transfer_ownership(new_owner: Identity);
}

impl OwnableTest for Contract {
    #[storage(read)]
    fn only_owner() {
        only_owner();
    }

    #[storage(read)]
    fn owner() -> State {
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

    #[storage(read, write)]
    fn transfer_ownership(new_owner: Identity) {
        transfer_ownership(new_owner);
    }
}
