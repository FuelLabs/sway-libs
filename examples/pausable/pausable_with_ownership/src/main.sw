contract;

// ANCHOR: impl_with_ownership
use pausable::{_is_paused, _pause, _unpause, Pausable};
use ownership::{initialize_ownership, only_owner};

abi MyConstructor {
    #[storage(read, write)]
    fn my_constructor(new_owner: Identity);
}

impl MyConstructor for Contract {
    #[storage(read, write)]
    fn my_constructor(new_owner: Identity) {
        initialize_ownership(new_owner);
    }
}

impl Pausable for Contract {
    #[storage(write)]
    fn pause() {
        // Add the `only_owner()` check to ensure only the owner may unpause this contract.
        only_owner();
        _pause();
    }

    #[storage(write)]
    fn unpause() {
        // Add the `only_owner()` check to ensure only the owner may unpause this contract.
        only_owner();
        _unpause();
    }

    #[storage(read)]
    fn is_paused() -> bool {
        _is_paused()
    }
}
// ANCHOR_END: impl_with_ownership
