library;

// ANCHOR: ownership_integration
use sway_libs::{admin::add_admin, ownership::initialize_ownership};

#[storage(read, write)]
fn my_constructor(new_owner: Identity) {
    initialize_ownership(new_owner);
}

#[storage(read, write)]
fn add_a_admin(new_admin: Identity) {
    // Can only be called by contract's owner set in the constructor above.
    add_admin(new_admin);
}
// ANCHOR_END: ownership_integration
