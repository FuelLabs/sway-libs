library;

mod administrator_errors;
mod administrator_events;

use administrator_errors::AdminError;
use administrator_events::AdminEvent;
use ::nft_core::nft_storage::ADMIN;
use std::{auth::msg_sender, storage::{get, store}};

abi Administrator {
    #[storage(read)]
    fn admin() -> Option<Identity>;
    #[storage(read, write)]
    fn set_admin(new_admin: Option<Identity>);
}

/// Returns the administrator for the library.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
#[storage(read)]
pub fn admin() -> Option<Identity> {
    get::<Option<Identity>>(ADMIN).unwrap_or(Option::None)
}

/// Changes the library's administrator.
///
/// # Arguments
///
/// * `admin` - The user which is to be set as the new admin.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
/// * Writes: `1`
///
/// # Reverts
///
/// * When the admin is storage is not `None`.
/// * When the sender is not the `admin` in storage.
#[storage(read, write)]
pub fn set_admin(new_admin: Option<Identity>) {
    let admin = get::<Option<Identity>>(ADMIN).unwrap_or(Option::None);
    require(admin.is_none() || (admin.is_some() && admin.unwrap() == msg_sender().unwrap()), AdminError::SenderNotAdmin);

    store(ADMIN, new_admin);

    log(AdminEvent {
        admin: new_admin,
    });
}
