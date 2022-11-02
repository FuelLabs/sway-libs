library administrator;

dep administrator_errors;
dep administrator_events;

use administrator_errors::AdminError;
use administrator_events::AdminEvent;
use ::nft::nft_storage::ADMIN;
use std::{chain::auth::msg_sender, logging::log, storage::{get, store}};

/// Returns the administrator for the library.
#[storage(read)]
pub fn admin() -> Option<Identity> {
    get::<Option<Identity>>(ADMIN)
}

/// Changes the library's administrator.
///
/// # Arguments
///
/// * `admin` - The user which is to be set as the new admin.
///
/// # Reverts
///
/// * When the admin is storage is not `None`.
/// * When the sender is not the `admin` in storage.
#[storage(read, write)]
pub fn set_admin(new_admin: Option<Identity>) {
    let admin = get::<Option<Identity>>(ADMIN);
    require(admin.is_none() || (admin.is_some() && admin.unwrap() == msg_sender().unwrap()), AdminError::SenderNotAdmin);

    store(ADMIN, new_admin);

    log(AdminEvent {
        admin: new_admin,
    });
}
