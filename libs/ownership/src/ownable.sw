library;

pub mod errors;
pub mod events;

use errors::InitializationError;
use events::{OwnershipRenounced, OwnershipSet, OwnershipTransferred};
use std::{auth::msg_sender, hash::sha256, storage::storage_api::{read, write}};
use src_5::{AccessError, State};

// Pre-computed hash digest of sha256("owner")
const OWNER = 0x4c1029697ee358715d3a14a2add817c4b01651440de808371f78165ac90dc581;

/// Returns the owner.
///
/// # Returns
///
/// * [State] - The state of the ownership.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use ownable::*;
///
/// fn foo() {
///     let stored_owner = _owner();
/// }
/// ```
#[storage(read)]
pub fn _owner() -> State {
    let owner_key = StorageKey::new(OWNER, 0, OWNER);
    owner_key.try_read().unwrap_or(State::Uninitialized)
}

/// Ensures that the sender is the owner.
///
/// # Reverts
///
/// * When the sender is not the owner.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use ownable::*;
///
/// fn foo() {
///     only_owner();
///     // Do stuff here
/// }
/// ```
#[storage(read)]
pub fn only_owner() {
    require(_owner() == State::Initialized(msg_sender().unwrap()), AccessError::NotOwner);
}

/// Revokes ownership of the current owner and disallows any new owners.
///
/// # Reverts
///
/// * When the sender is not the owner.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
/// * Writes: `1`
///
/// # Examples
///
/// ```sway
/// use ownable::{_owner, renounce_ownership};
///
/// fn foo() {
///     assert(owner() == State::Initialized(Identity::Address(Address::from(ZERO_B256)));
///     renounce_ownership();
///     assert(owner() == State::Revoked);
/// }
/// ```
#[storage(read, write)]
pub fn renounce_ownership() {
    only_owner();

    let owner_key = StorageKey::new(OWNER, 0, OWNER);
    owner_key.write(State::Revoked);

    log(OwnershipRenounced {
        previous_owner: msg_sender().unwrap(),
    });
}

/// Sets the passed identity as the initial owner.
///
/// # Arguments
///
/// * `new_owner`: [Identity] - The `Identity` that will be the first owner.
///
/// # Reverts
///
/// * When ownership has been set before.
///
/// # Number of Storage Acesses
///
/// * Reads: `1`
/// * Write: `1`
///
/// # Examples
///
/// ```sway
/// use ownable::{_owner, initialize_ownership};
///
/// fn foo(owner: Identity) {
///     assert(_owner() == State::Uninitialized);
///     initialize_ownership(owner);
///     assert(_owner() == State::Initialized(owner));
/// }
/// ```
#[storage(read, write)]
pub fn initialize_ownership(new_owner: Identity) {
    require(_owner() == State::Uninitialized, InitializationError::CannotReinitialized);

    let owner_key = StorageKey::new(OWNER, 0, OWNER);
    owner_key.write(State::Initialized(new_owner));

    log(OwnershipSet { new_owner });
}

/// Transfers ownership to the passed identity.
///
/// # Arguments
///
/// * `new_owner`: [Identity] - The `Identity` that will be the next owner.
///
/// # Reverts
///
/// * When the sender is not the owner.
///
/// # Number of Storage Acesses
///
/// * Reads: `1`
/// * Write: `1`
///
/// # Examples
///
/// ```sway
/// use ownable::{_owner, transfer_ownership};
///
/// fn foo(new_owner: Identity) {
///     assert(_owner() == State::Initialized(Identity::Address(Address::from(ZERO_B256)));
///     transfer_ownership(new_owner);
///     assert(_owner() == State::Initialized(new_owner));
/// }
/// ```
#[storage(read, write)]
pub fn transfer_ownership(new_owner: Identity) {
    only_owner();

    let owner_key = StorageKey::new(OWNER, 0, OWNER);
    owner_key.write(State::Initialized(new_owner));

    log(OwnershipTransferred {
        new_owner,
        previous_owner: msg_sender().unwrap(),
    });
}
