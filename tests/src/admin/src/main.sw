contract;

use {admin::*, ownership::*};
use standards::src5::{SRC5, State};

abi AdminTest {
    #[storage(read, write)]
    fn add_admin(new_admin: Identity);
    #[storage(read, write)]
    fn remove_admin(old_admin: Identity);
    #[storage(read)]
    fn is_admin(admin: Identity) -> bool;
    #[storage(read)]
    fn only_admin();
    #[storage(read)]
    fn only_owner_or_admin();
}

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

impl AdminTest for Contract {
    #[storage(read, write)]
    fn add_admin(new_admin: Identity) {
        add_admin(new_admin);
    }

    #[storage(read, write)]
    fn remove_admin(old_admin: Identity) {
        revoke_admin(old_admin);
    }

    #[storage(read)]
    fn is_admin(admin: Identity) -> bool {
        is_admin(admin)
    }

    #[storage(read)]
    fn only_admin() {
        only_admin();
    }

    #[storage(read)]
    fn only_owner_or_admin() {
        only_owner_or_admin();
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

impl SRC5 for Contract {
    #[storage(read)]
    fn owner() -> State {
        _owner()
    }
}
