contract;

use pausable::{_is_paused, _pause, _unpause, Pausable, require_not_paused, require_paused};

abi RequireTests {
    #[storage(read)]
    fn test_require_paused();
    #[storage(read)]
    fn test_require_not_paused();
}

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

impl RequireTests for Contract {
    #[storage(read)]
    fn test_require_paused() {
        require_paused();
    }

    #[storage(read)]
    fn test_require_not_paused() {
        require_not_paused();
    }
}

#[test]
fn test_is_paused() {
    let pausable_abi = abi(Pausable, CONTRACT_ID);

    assert(!pausable_abi.is_paused());
}

#[test]
fn test_pause() {
    let pausable_abi = abi(Pausable, CONTRACT_ID);

    assert(!pausable_abi.is_paused());
    pausable_abi.pause();
    assert(pausable_abi.is_paused());
}

#[test]
fn test_unpause() {
    let pausable_abi = abi(Pausable, CONTRACT_ID);
    pausable_abi.pause();

    assert(pausable_abi.is_paused());
    pausable_abi.unpause();
    assert(!pausable_abi.is_paused());
}

#[test]
fn test_require_not_paused() {
    let require_abi = abi(RequireTests, CONTRACT_ID);

    require_abi.test_require_not_paused();
}

#[test(should_revert)]
fn test_revert_require_not_paused() {
    let pausable_abi = abi(Pausable, CONTRACT_ID);
    let require_abi = abi(RequireTests, CONTRACT_ID);
    pausable_abi.pause();

    require_abi.test_require_not_paused();
}

#[test]
fn test_require_paused() {
    let pausable_abi = abi(Pausable, CONTRACT_ID);
    let require_abi = abi(RequireTests, CONTRACT_ID);
    pausable_abi.pause();

    require_abi.test_require_paused();
}

#[test(should_revert)]
fn test_revert_require_paused() {
    let require_abi = abi(RequireTests, CONTRACT_ID);

    require_abi.test_require_paused();
}
