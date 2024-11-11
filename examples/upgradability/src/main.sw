contract;

// ANCHOR: import
use sway_libs::upgradability::*;
use standards::{src14::*, src5::*};
// ANCHOR_END: import

// ANCHOR: integrate_with_src14
use sway_libs::upgradability::{_proxy_owner, _proxy_target, _set_proxy_target};
use standards::{src14::{SRC14, SRC14Extension}, src5::State};

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
// ANCHOR_END: integrate_with_src14

// ANCHOR: set_proxy_target
#[storage(read, write)]
fn set_proxy_target(new_target: ContractId) {
    _set_proxy_target(new_target);
}
// ANCHOR_END: set_proxy_target

// ANCHOR: proxy_target
#[storage(read)]
fn proxy_target() -> Option<ContractId> {
    _proxy_target()
}
// ANCHOR_END: proxy_target

// ANCHOR: set_proxy_owner
#[storage(write)]
fn set_proxy_owner(new_proxy_owner: State) {
    _set_proxy_owner(new_proxy_owner);
}
// ANCHOR_END: set_proxy_owner

// ANCHOR: proxy_owner
#[storage(read)]
fn proxy_owner() -> State {
    _proxy_owner()
}
// ANCHOR_END: proxy_owner

// ANCHOR: only_proxy_owner
#[storage(read)]
fn only_proxy_owner_may_call() {
    only_proxy_owner();
    // Only the proxy's owner may reach this line.
}
// ANCHOR_END: only_proxy_owner
