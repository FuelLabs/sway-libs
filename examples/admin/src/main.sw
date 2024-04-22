library;

mod owner_integration;

// ANCHOR: import
use sway_libs::{admin::*, ownership::*};
// ANCHOR_END: import

// ANCHOR: add_admin
#[storage(read, write)]
fn add_a_admin(new_admin: Identity) {
    // Can only be called by contract's owner.
    add_admin(new_admin);
}
// ANCHOR_END: add_admin

// ANCHOR: remove_admin
#[storage(read, write)]
fn remove_an_admin(old_admin: Identity) {
    // Can only be called by contract's owner.
    revoke_admin(old_admin);
}
// ANCHOR_END: remove_admin

// ANCHOR: only_admin
#[storage(read)]
fn only_owner_may_call() {
    only_admin();
    // Only an admin may reach this line.
}
// ANCHOR_END: only_admin

// ANCHOR: both_admin
#[storage(read)]
fn both_owner_or_admin_may_call() {
    only_owner_or_admin();
    // Only an admin may reach this line.
}
// ANCHOR_END: both_admin

// ANCHOR: check_admin
#[storage(read)]
fn check_if_admin(admin: Identity) {
    let status = is_admin(admin);
    assert(status);
}
// ANCHOR_END: check_admin
