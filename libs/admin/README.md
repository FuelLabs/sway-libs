# Admin Library

The Admin library provides a way to block users without an "administrative status" from calling functions within a contract. The Admin Library differs from the [Ownership Library](https://docs.fuel.network/docs/sway-libs/ownership/) as multiple users may have administrative status. The Admin Library is often used when needing administrative calls on a contract that involve multiple users or a whitelist.

This library extends the [Ownership Library]([../ownership/index.md](https://docs.fuel.network/docs/sway-libs/ownership/)). The Ownership library must be imported and used to enable the Admin library. Only the contract's owner may add and remove administrative users.

For implementation details on the Admin Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/admin/admin/).

## Importing the Admin Library

In order to use the Admin Library, the Admin and the Ownership Libraries must be added to your `Forc.toml` file and then imported into your Sway project.

To add the Admin and the Ownership Libraries as dependencies to your `Forc.toml` file in your project, use the `forc add` command.

```bash
forc add admin@0.26.0
forc add ownership@0.26.0
```

> **NOTE:** Be sure to set the version to the latest release.

To import the Admin Library, be sure to include both the Admin and Ownership Libraries in your import statements.

```sway
use {admin::*, ownership::*};
```

## Integrating the Admin Library into the Ownership Library

To use the Admin library, be sure to set a contract owner for your contract. The following demonstrates setting a contract owner using the [Ownership Library](https://docs.fuel.network/docs/sway-libs/ownership/).

```sway
use {admin::add_admin, ownership::initialize_ownership};

#[storage(read, write)]
fn my_constructor(new_owner: Identity) {
    initialize_ownership(new_owner);
}

#[storage(read, write)]
fn add_a_admin(new_admin: Identity) {
    // Can only be called by contract's owner set in the constructor above.
    add_admin(new_admin);
}
```

## Basic Functionality

### Adding an Admin

To add a new admin to a contract, call the `add_admin()` function.

```sway
#[storage(read, write)]
fn add_a_admin(new_admin: Identity) {
    // Can only be called by contract's owner.
    add_admin(new_admin);
}
```

> **NOTE** Only the contract's owner may call this function. Please see the example above to set a contract owner.

### Removing an Admin

To remove an admin from a contract, call the `revoke_admin()` function.

```sway
#[storage(read, write)]
fn remove_an_admin(old_admin: Identity) {
    // Can only be called by contract's owner.
    revoke_admin(old_admin);
}
```

> **NOTE** Only the contract's owner may call this function. Please see the example above to set a contract owner.

### Applying Restrictions

To restrict a function to only an admin, call the `only_admin()` function.

```sway
#[storage(read)]
fn only_owner_may_call() {
    only_admin();
    // Only an admin may reach this line.
}
```

> **NOTE:** Admins and the contract's owner are independent of one another. `only_admin()` will revert if called by the contract's owner.

To restrict a function to only an admin or the contract's owner, call the `only_owner_or_admin()` function.

```sway
#[storage(read)]
fn both_owner_or_admin_may_call() {
    only_owner_or_admin();
    // Only an admin may reach this line.
}
```

### Checking Admin Status

To check the administrative privileges of a user, call the `is_admin()` function.

```sway
#[storage(read)]
fn check_if_admin(admin: Identity) {
    let status = is_admin(admin);
    assert(status);
}
```
