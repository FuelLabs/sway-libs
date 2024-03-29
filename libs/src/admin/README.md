<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".docs/admin-logo-dark-theme.png">
        <img alt="SwayApps logo" width="400px" src=".docs/admin-logo-light-theme.png">
    </picture>
</p>

# Overview

The Admin library provides a way to block users without an "adimistrative status" from calling functions within a contract. Admin is often used when needing administrative calls on a contract that involve multiple users or a whitelist.

This library extends the [Ownership Library](../ownership/). The Ownership library must be imported and used to enable the Admin library. Only the contract's owner may add and remove administrative users. 

For more information please see the [specification](./SPECIFICATION.md).

# Using the Library

## Getting Started

In order to use the Admin library, Sway Libs must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [README.md](../../README.md).

You may import the Admin library's functionalities like so:

```sway
use sway_libs::admin::*;
```

Once imported, the Admin library's functions will be available. To use them, the contract's owner must add a user as an admin with the `add_admin()` function. There is no limit to the number of admins a contract may have.

```sway
#[storage(read, write)]
fn add_a_admin(new_admin: Identity) {
    // Can only be called by the Ownership Library's Owner
    add_admin(new_admin);
}
```

## Basic Functionality

To restrict a function to only an admin, call the `only_admin()` function.

```sway
only_admin();
// Only an admin may reach this line.
```

> **NOTE:** Admins and the contract's owner are independent of one another. `only_admin()` will revert if called by the contract's owner.

To restrict a function to only an admin or the contract's owner, call the `only_owner_or_admin()` function.

```sway
only_owner_or_admin();
// Only an admin may reach this line.
```

To check the administrative privledges of a user, call the `is_admin()` function.

```sway
#[storage(read)]
fn check_if_admin(admin: Identity) {
    let status = is_admin(admin);
    assert(status);
}
```

## Integrating the Admin Library into the Ownership Library

To implement the Ownership library with the Admin library, be sure to set a contract owner for your contract. The following demonstrates the integration of the Ownership library with the Admin library.

```sway
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
```

For more information please see the [specification](./SPECIFICATION.md).
