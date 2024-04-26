contract;

// ANCHOR: import
use sway_libs::pausable::*;
// ANCHOR_END: import

// ANCHOR: pausable_impl
use sway_libs::pausable::{_is_paused, _pause, _unpause, Pausable};

impl Pausable for Contract {
    #[storage(write)]
    fn pause() {
        _pause();
    }

    #[storage(write)]
    fn unpause() {
        _unpause();
    }

    #[storage(read)]
    fn is_paused() -> bool {
        _is_paused()
    }
}
// ANCHOR_END: pausable_impl

// ANCHOR: require_paused
use sway_libs::pausable::require_paused;

#[storage(read)]
fn require_paused_state() {
    require_paused();
    // This comment will only ever be reached if the contract is in the paused state
}
// ANCHOR_END: require_paused

// ANCHOR: require_not_paused
use sway_libs::pausable::require_not_paused;

#[storage(read)]
fn require_not_paused_state() {
    require_not_paused();
    // This comment will only ever be reached if the contract is in the unpaused state
}
// ANCHOR_END: require_not_paused
