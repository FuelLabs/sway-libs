library;

pub mod errors;

use ::admin::errors::AdminError;
use ::ownership::{_owner, only_owner};
use standards::src5::State;
use std::{auth::msg_sender, hash::{Hash, sha256}, storage::storage_api::clear,};

// Sets a new administrator.
///
/// # Arguments
///
/// * `new_admin`: [Identity] - The `Identity` which is to receive administrator status.
///
/// # Reverts
///
/// * When the caller is not the contract owner.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
/// * Writes: `1`
///
/// # Examples
///
/// ```sway
/// use sway_libs::admin::{add_admin, is_admin};
///
/// fn foo(new_admin: Identity) {
///     add_admin(new_admin);
///     assert(is_admin(new_admin));
/// }
/// ```
#[storage(read, write)]
pub fn add_admin(new_admin: Identity) {
    only_owner();

    let key_digest = sha256(("admin", new_admin.bits()));
    let admin_key = StorageKey::<Identity>::new(key_digest, 0, key_digest);
    admin_key.write(new_admin);
}

/// Removes an administrator.
///
/// # Arguments
///
/// * `old_admin`: [Identity] - The `Identity` which the administrator status is to be removed.
///
/// # Reverts
///
/// * When the caller is not the contract owner.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
/// * Writes: `1`
///
/// # Examples
///
/// ```sway
/// use sway_libs::admin::{revoke_admin, is_admin};
///
/// fn foo(old_admin: Identity) {
///     revoke_admin(old_admin);
///     assert(!is_admin(old_admin));
/// }
/// ```
#[storage(read, write)]
pub fn revoke_admin(old_admin: Identity) {
    only_owner();

    let key_digest = sha256(("admin", old_admin.bits()));
    let admin_key = StorageKey::<Identity>::new(key_digest, 0, key_digest);
    let _ = admin_key.clear();
}

/// Returns whether `admin` is an administrator.
///
/// # Arguments
///
/// * `admin`: [Identity] - The `Identity` of which to check the administrator status.
///
/// # Returns
///
/// * [bool] - `true` if the `admin` is an administrator, otherwise `false`.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use sway_libs::admin::{is_admin};
///
/// fn foo(admin: Identity) {
///     assert(is_admin(admin));
/// }
/// ```
#[storage(read)]
pub fn is_admin(admin: Identity) -> bool {
    let key_digest = sha256(("admin", admin.bits()));
    let admin_key = StorageKey::<Identity>::new(key_digest, 0, key_digest);
    match admin_key.try_read() {
        Some(identity) => {
            admin == identity
        },
        None => {
            false
        },
    }
}

/// Ensures that the sender is an administrator.
///
/// # Additional Information
///
/// NOTE: Owner and administrator are independent of one another. If an Owner calls this function, it will revert.
///
/// # Reverts
///
/// * When the caller is not an administrator.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use sway_libs::admin::{only_admin};
///
/// fn foo() {
///     only_admin();
///     // Only reachable by an administrator
/// }
/// ```
#[storage(read)]
pub fn only_admin() {
    require(is_admin(msg_sender().unwrap()), AdminError::NotAdmin);
}

/// Ensures that the sender is an owner or administrator.
///
/// # Reverts
///
/// * When the caller is not an owner or administrator.
///
/// # Number of Storage Accesses
///
/// * Reads: `2`
///
/// # Examples
///
/// ```sway
/// use sway_libs::admin::{only_owner_or_admin};
///
/// fn foo() {
///     only_owner_or_admin();
///     // Only reachable by an owner or administrator
/// }
/// ```
#[storage(read)]
pub fn only_owner_or_admin() {
    let sender = msg_sender().unwrap();
    require(
        _owner() == State::Initialized(sender) || is_admin(sender),
        AdminError::NotAdmin,
    );
}
