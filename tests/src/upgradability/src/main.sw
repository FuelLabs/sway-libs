contract;

use sway_libs::upgradability::{
    _proxy_owner,
    _proxy_target,
    _set_proxy_owner,
    _set_proxy_target,
    only_proxy_owner,
};
use standards::{src14::{SRC14, SRC14Extension}, src5::State};

configurable {
    INITIAL_TARGET: Option<ContractId> = None,
    INITIAL_OWNER: State = State::Uninitialized,
}

#[namespace(SRC14)]
storage {
    // target is at sha256("storage_SRC14_0")
    target: Option<ContractId> = None,
    proxy_owner: State = State::Uninitialized,
}

abi UpgradableTest {
    #[storage(read)]
    fn only_proxy_owner();

    #[storage(write)]
    fn set_proxy_owner(new_proxy_owner: State);

    #[storage(write)]
    fn initialize_proxy();
}

impl SRC14 for Contract {
    #[storage(read, write)]
    fn set_proxy_target(new_target: ContractId) {
        _set_proxy_target(new_target);
    }

    #[storage(read)]
    fn proxy_target() -> Option<ContractId> {
        _proxy_target()
    }
}

impl SRC14Extension for Contract {
    #[storage(read)]
    fn proxy_owner() -> State {
        _proxy_owner(storage.proxy_owner)
    }
}

impl UpgradableTest for Contract {
    #[storage(read)]
    fn only_proxy_owner() {
        only_proxy_owner(storage.proxy_owner);
    }

    #[storage(write)]
    fn set_proxy_owner(new_proxy_owner: State) {
        _set_proxy_owner(new_proxy_owner, storage.proxy_owner);
    }

    // Used to immediately set the storage variables as the configured constants
    #[storage(write)]
    fn initialize_proxy() {
        storage.target.write(INITIAL_TARGET);
        storage.proxy_owner.write(INITIAL_OWNER);
    }
}
