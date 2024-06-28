library;

pub mod errors;
pub mod events;

use ::upgradability::{errors::SetProxyOwnerError, events::{ProxyOwnerSet, ProxyTargetSet}};
use std::{auth::msg_sender, storage::storage_api::{read, write}};
use standards::{src14::SRC14_TARGET_STORAGE, src5::{AccessError, State}};

/// Returns the proxy target.
///
/// # Returns
///
/// * [Option<ContractId>] - The ContractId of the proxy target.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use sway_libs::upgradability::proxy_target;
///
/// fn foo() {
///     let stored_proxy_target = proxy_target();
/// }
/// ```
#[storage(read)]
pub fn proxy_target() -> Option<ContractId> {
    let proxy_target_key = StorageKey::new(SRC14_TARGET_STORAGE, 0, SRC14_TARGET_STORAGE);
    proxy_target_key.read()
}

/// Change the target contract of a proxy contract.
///
/// # Arguments
///
/// * `new_target`: [ContractId] - The new proxy contract to which all fallback calls will be passed.
///
/// # Number of Storage Accesses
///
/// * writes: `1`
///
/// # Examples
///
/// ```sway
/// use sway_libs::upgradability::{proxy_target, set_proxy_target};
///
/// fn foo() {
///     assert(proxy_target() == None);
///
///     let new_target = ContractId::zero();
///     set_proxy_target(new_target);
///
///     assert(proxy_target() == Some(new_target));
/// }
/// ```
#[storage(write)]
pub fn set_proxy_target(new_target: ContractId) {
    let proxy_target_key = StorageKey::new(SRC14_TARGET_STORAGE, 0, SRC14_TARGET_STORAGE);
    proxy_target_key.write(Some(new_target));

    log(ProxyTargetSet { new_target });
}

/// Returns the owner of the proxy.
///
/// # Arguments
///
/// * `proxy_owner_storage_key`: [StorageKey<State>] - The storage key of the stored proxy owner.
///
/// # Returns
///
/// * [State] - The state of the proxy ownership.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use sway_libs::upgradability::proxy_owner;
///
/// storage {
///     proxy_owner: State = State::Uninitialized,
/// }
///
/// fn foo() {
///     let stored_proxy_owner = proxy_owner(storage.proxy_owner);
/// }
/// ```
#[storage(read)]
pub fn proxy_owner(proxy_owner_storage_key: StorageKey<State>) -> State {
    proxy_owner_storage_key.read()
}

/// Ensures that the sender is the proxy owner.
///
/// # Arguments
///
/// * `proxy_owner_storage_key`: [StorageKey<State>] - The storage key of the stored proxy owner.
///
/// # Reverts
///
/// * When the sender is not the proxy owner.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use sway_libs::ownership::only_proxy_owner;
///
/// storage {
///     proxy_owner: State = State::Uninitialized,
/// }
///
/// fn foo() {
///     only_proxy_owner(storage.proxy_owner);
///     // Do stuff here if the sender is the proxy owner
/// }
/// ```
#[storage(read)]
pub fn only_proxy_owner(proxy_owner_storage_key: StorageKey<State>) {
    require(
        proxy_owner(proxy_owner_storage_key) == State::Initialized(msg_sender().unwrap()),
        AccessError::NotOwner,
    );
}

/// Change proxy ownership to the passed State.
///
/// # Additional Information
///
/// This function can be used to transfer ownership between Identities or to revoke ownership.
///
/// # Arguments
///
/// * `new_proxy_owner`: [State] - The new state of the proxy ownership.
/// * `proxy_owner_storage_key`: [StorageKey<State>] - The storage key of the stored proxy owner.
///
/// # Reverts
///
/// * When the sender is not the proxy owner.
/// * When the new state of the proxy ownership is Uninitialized.
///
/// # Number of Storage Accesses
///
/// * writes: `1`
///
/// # Examples
///
/// ```sway
/// use sway_libs::upgradability::{proxy_owner, set_proxy_owner};
///
/// storage {
///     proxy_owner: State = State::Uninitialized,
/// }
///
/// fn foo(new_owner: Identity) {
///     assert(proxy_owner(storage.proxy_owner) == State::Initialized(Identity::Address(Address::zero()));
///
///     let new_proxy_owner = State::Initialized(new_owner);
///     set_proxy_owner(new_proxy_owner, storage.proxy_owner);
///
///     assert(proxy_owner(storage.proxy_owner) == State::Initialized(new_owner));
/// }
/// ```
#[storage(write)]
pub fn set_proxy_owner(
    new_proxy_owner: State,
    proxy_owner_storage_key: StorageKey<State>,
) {
    only_proxy_owner(proxy_owner_storage_key);
    require(
        new_proxy_owner != State::Uninitialized,
        SetProxyOwnerError::CannotUninitialize,
    );

    proxy_owner_storage_key.write(new_proxy_owner);

    log(ProxyOwnerSet {
        new_proxy_owner,
    });
}
