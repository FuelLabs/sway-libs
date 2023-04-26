contract;

use ownership::*;
use ownership::data_structures::State;

storage {
    owner: Ownership = Ownership {},
}

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
        storage.owner.only_owner();
    }

    #[storage(read)]
    fn owner() -> State {
        storage.owner.owner()
    }

    #[storage(read, write)]
    fn renounce_ownership() {
        storage.owner.renounce_ownership();
    }

    #[storage(read, write)]
    fn set_ownership(new_owner: Identity) {
        storage.owner.set_ownership(new_owner);
    }

    #[storage(read, write)]
    fn transfer_ownership(new_owner: Identity) {
        storage.owner.transfer_ownership(new_owner);
    }
}
