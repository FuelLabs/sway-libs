library;

pub mod errors;
pub mod events;

use ::{errors::SetProxyOwnerError, events::{ProxyOwnerSet, ProxyTargetSet}};
use std::{auth::msg_sender, storage::storage_api::{read, write}};
use src14::SRC14_TARGET_STORAGE;
use src5::{AccessError, State};

/// The storage slot to store the proxy owner State.
///
/// Value is `sha256("storage_SRC14_1")`.
pub const PROXY_OWNER_STORAGE: b256 = 0xbb79927b15d9259ea316f2ecb2297d6cc8851888a98278c0a2e03e1a091ea754;

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
/// use upgradability::_proxy_target;
///
/// fn foo() {
///     let stored_proxy_target = _proxy_target();
/// }
/// ```
#[storage(read)]
pub fn _proxy_target() -> Option<ContractId> {
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
/// * Writes: `1`
///
/// # Examples
///
/// ```sway
/// use upgradability::{_proxy_target, _set_proxy_target};
///
/// fn foo() {
///     assert(_proxy_target() == None);
///
///     let new_target = ContractId::zero();
///     _set_proxy_target(new_target);
///
///     assert(_proxy_target() == Some(new_target));
/// }
/// ```
#[storage(write)]
pub fn _set_proxy_target(new_target: ContractId) {
    let proxy_target_key = StorageKey::new(SRC14_TARGET_STORAGE, 0, SRC14_TARGET_STORAGE);
    proxy_target_key.write(Some(new_target));

    log(ProxyTargetSet { new_target });
}

/// Returns the owner of the proxy.
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
/// use upgradability::_proxy_owner;
///
///
/// fn foo() {
///     let stored_proxy_owner = _proxy_owner();
/// }
/// ```
#[storage(read)]
pub fn _proxy_owner() -> State {
    let proxy_owner_key = StorageKey::new(PROXY_OWNER_STORAGE, 0, PROXY_OWNER_STORAGE);
    proxy_owner_key.read()
}

/// Ensures that the sender is the proxy owner.
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
/// use ownership::only_proxy_owner;
///
/// fn foo() {
///     only_proxy_owner();
///     // Do stuff here if the sender is the proxy owner
/// }
/// ```
#[storage(read)]
pub fn only_proxy_owner() {
    require(
        _proxy_owner() == State::Initialized(msg_sender().unwrap()),
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
///
/// # Reverts
///
/// * When the sender is not the proxy owner.
/// * When the new state of the proxy ownership is Uninitialized.
///
/// # Number of Storage Accesses
///
/// * Writes: `1`
///
/// # Examples
///
/// ```sway
/// use upgradability::{_proxy_owner, _set_proxy_owner};
///
/// fn foo(new_owner: Identity) {
///     assert(_proxy_owner() == State::Initialized(Identity::Address(Address::zero()));
///
///     let new_proxy_owner = State::Initialized(new_owner);
///     _set_proxy_owner(new_proxy_owner);
///
///     assert(_proxy_owner() == State::Initialized(new_owner));
/// }
/// ```
#[storage(write)]
pub fn _set_proxy_owner(new_proxy_owner: State) {
    only_proxy_owner();

    require(
        new_proxy_owner != State::Uninitialized,
        SetProxyOwnerError::CannotUninitialize,
    );

    let proxy_owner_key = StorageKey::new(PROXY_OWNER_STORAGE, 0, PROXY_OWNER_STORAGE);
    proxy_owner_key.write(new_proxy_owner);

    log(ProxyOwnerSet {
        new_proxy_owner,
    });
}
