library;

mod data_structures;
mod errors;
mod events;
mod ownable_storage;

use data_structures::State;
use errors::AccessError;
use events::{OwnershipRenounced, OwnershipSet, OwnershipTransferred};
use ownable_storage::OWNER;
use std::{auth::msg_sender, hash::sha256, storage::{get, store}};

/// Ensures that the sender is the owner.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Reverts
///
/// * When the sender is not the owner.
///
/// # Examples
///
/// ```sway
/// use ownable::only_owner;
///
/// fn foo() {
///     only_owner();
///     // Do stuff here
/// }
/// ```
#[storage(read)]
pub fn only_owner() {
    let owner = get::<State>(OWNER).unwrap_or(State::Uninitialized);
    require(State::Initialized(msg_sender().unwrap()) == owner, AccessError::NotOwner);
}

/// Returns the owner.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use ownable::owner;
///
/// fn foo() {
///     let stored_owner = owner();
/// }
/// ```
#[storage(read)]
pub fn owner() -> State {
    get::<State>(OWNER).unwrap_or(State::Uninitialized)
}

/// Revokes ownership of the current owner and disallows any new owners.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
/// * Writes: `1`
///
/// # Reverts
///
/// * When the sender is not the owner.
///
/// # Examples
///
/// ```sway
/// use ownable::{owner, renounce_ownership, set_ownership};
///
/// fn foo(owner: Identity) {
///     set_ownership(owner);
///     assert(owner() == State::Initialized(owner));
///     renounce_ownership();
///     assert(owner() == State::Revoked);
/// }
/// ```
#[storage(read, write)]
pub fn renounce_ownership() {
    only_owner();

    store(OWNER, State::Revoked);

    log(OwnershipRenounced {
        previous_owner: msg_sender().unwrap(),
    });
}

/// Sets the passed identity as the initial owner.
///
/// # Number of Storage Acesses
///
/// * Reads: `1`
/// * Write: `1`
///
/// # Reverts
///
/// * When ownership has been set before.
///
/// # Examples
///
/// ```sway
/// use ownable::set_ownership;
///
/// fn foo(owner: Identity) {
///     assert(owner() == State::Uninitialized);
///     set_ownership(owner);
///     assert(owner() == State::Initialized(owner));
/// }
/// ```
#[storage(read, write)]
pub fn set_ownership(new_owner: Identity) {
    require(get::<State>(OWNER).unwrap_or(State::Uninitialized) == State::Uninitialized, AccessError::CannotReinitialized);

    store(OWNER, State::Initialized(new_owner));

    log(OwnershipSet { new_owner });
}

/// Transfers ownership to the passed identity.
///
/// # Number of Storage Acesses
///
/// * Reads: `1`
/// * Write: `1`
///
/// # Reverts
///
/// * When the sender is not the owner.
///
/// # Examples
///
/// ```sway
/// use ownable::{set_ownership, transfer_ownership};
///
/// fn foo(owner: Identity, second_owner: Identity) {
///     set_ownership(owner);
///     assert(owner() == State::Initialized(owner));
///     transfer_ownership(second_owner);
///     assert(owner() == State::Initialized(second_owner));
/// }
/// ```
#[storage(read, write)]
pub fn transfer_ownership(new_owner: Identity) {
    only_owner();
    store(OWNER, State::Initialized(new_owner));

    log(OwnershipTransferred {
        new_owner,
        previous_owner: msg_sender().unwrap(),
    });
}
