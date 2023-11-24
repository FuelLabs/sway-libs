library;

mod errors;

use errors::AccessError;
use ownership::{_owner, only_owner};
use src_5::State;
use std::{auth::msg_sender, storage::storage_api::clear,};
/
// Sets a new administrator.
///
/// # Arguments
///
/// * `new_admin`: [Identity] = The `Identity` which is to recieve administrator status.
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
/// use admin::{add_admin, is_admin};
///
/// fn foo(new_admin: Identity) {
///     add_admin(new_admin);
///     assert(is_admin(new_admin));
/// }
/// ```
#[storage(read, write)]
pub fn add_admin(new_admin: Identity) {
    only_owner();
    let admin_value
 = match new_admin {
        Identity::Address(addr) => addr.value,
        Identity::ContractId(contr) => contr.value,
    };
    let admin_key = StorageKey::<Identity>::new(admin_value, 0, admin_value);
    admin_key.
write(new_admin);
}
/
// Removes an administrator.
///
/// # Arguments
///
/// * `old_admin`: [Identity] = The `Identity` which the administrator status is to be removed.
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
/// use admin::{remove_admin, is_admin};
///
/// fn foo(old_admin: Identity) {
///     remove_admin(old_admin);
///     assert(!is_admin(old_admin));
/// }
/// ```
#[storage(read, write)]
pub fn remove_admin(old_admin: Identity) {
    only_owner();
    let admin_value
 = match old_admin {
        Identity::Address(addr) => addr.value,
        Identity::ContractId(contr) => contr.value,
    };
    let admin_key = StorageKey::<Identity>::new(admin_value, 0, admin_value);
    // TODO: Update to use StorageKey::clear() on next release
    // https://github.com/FuelLabs/sway/pull/5284
    let _
 = clear::<Identity>(admin_key.slot, admin_key.offset);
}
/
// Returns whether `admin` is an administrator.
///
/// # Arguments
///
/// * `admin`: [Identity] = The `Identity` of which to check the administrator status.
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
/// use admin::{is_admin};
///
/// fn foo(admin: Identity) {
///     assert(is_admin(admin));
/// }
/// ```
#[storage(read)]
pub fn is_admin(admin: Identity) -> bool {
    let admin_value = match admin {
        Identity::Address(addr) => addr.value,
        Identity::ContractId(contr) => contr.value,
    };
    let admin_key = StorageKey::<Identity>::new(admin_value, 0, admin_value);
    match admin_key
.try_read() {
        Some(identity) => {
            admin == identity
        },
        None => {
            false
        },
    }
}
/
// Ensures that the sender is an administrator.
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
/// use admin::{only_admin};
///
/// fn foo() {
///     only_admin();
///     // Only reachable by an administrator
/// }
/// ```
#[storage(read)]
pub fn only_admin() {
    require(is_admin(msg_sender().unwrap()), AccessError::NotAdmin);
}
/
// Ensures that the sender is an owner or administrator.
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
/// use admin::{only_owner_or_admin};
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
        AccessError::NotAdmin,
    );
}
