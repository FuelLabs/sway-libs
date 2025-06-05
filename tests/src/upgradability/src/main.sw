contract;

use upgradability::{
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

storage {
    SRC14 {
        /// The [ContractId] of the target contract.
        ///
        /// # Additional Information
        ///
        /// `target` is stored at sha256("storage_SRC14_0")
        target in 0x7bb458adc1d118713319a5baa00a2d049dd64d2916477d2688d76970c898cd55: Option<ContractId> = None,
        /// The [State] of the proxy owner.
        ///
        /// # Additional Information
        ///
        /// `proxy_owner` is stored at sha256("storage_SRC14_1")
        proxy_owner in 0xbb79927b15d9259ea316f2ecb2297d6cc8851888a98278c0a2e03e1a091ea754: State = State::Uninitialized,
    },
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
        _proxy_owner()
    }
}

impl UpgradableTest for Contract {
    #[storage(read)]
    fn only_proxy_owner() {
        only_proxy_owner();
    }

    #[storage(write)]
    fn set_proxy_owner(new_proxy_owner: State) {
        _set_proxy_owner(new_proxy_owner);
    }

    // Used to immediately set the storage variables as the configured constants
    #[storage(write)]
    fn initialize_proxy() {
        storage::SRC14.target.write(INITIAL_TARGET);
        storage::SRC14.proxy_owner.write(INITIAL_OWNER);
    }
}
