<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".docs/ownership-logo-dark-theme.png">
        <img alt="SwayApps logo" width="400px" src=".docs/ownership-logo-light-theme.png">
    </picture>
</p>

# Overview

The Ownership library provides a way to block users other than a single "owner" from calling functions. Ownership is often used when needing administrative calls on a contract.

For more information please see the [specification](./SPECIFICATION.md).

# Using the Library

## Getting Started

In order to use the Ownership library it must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway-libs as a dependency to the `Forc.toml` file in your project please see the [README.md](../../README.md).

> **NOTE** Until [Issue #5025](https://github.com/FuelLabs/sway/issues/5025) is resolved, in order to use the Ownership Library you must also add the [SRC-5](https://github.com/FuelLabs/sway-standards/tree/master/standards/src_5) standard as a dependencies.

You may import the Ownership library's functionalities like so:

```sway
use ownership::*;
```

Once imported, the Ownership library's functions should be available. To use them, be sure to initialize the owner for your contract by calling the `initialize_ownership()` function in your own constructor.

```sway
#[storage(read, write)]
fn my_constructor(new_owner: Identity) {
    initialize_ownership(new_owner);
}
```

## Basic Functionality

To restrict a function to only the owner, call the `only_owner()` function.

```sway
only_owner();
// Only the contract's owner may reach this line.
```

To return the ownership state from storage, call the `_owner()` function.

```sway
let owner: State = _owner();
```

## Integrating the Ownership Library into the SRC-5 Standard

To implement the SRC-5 standard with the Ownership library, be sure to add the [SRC-5](https://github.com/FuelLabs/sway-standards/tree/master/standards/src_5) abi to your contract. The following demonstrates the integration of the Ownership library with the SRC-5 standard.

```sway
use ownership::_owner;
use src_5::{State, SRC5};

impl SRC5 for Contract {
    #[storage(read)]
    fn owner() -> State {
        _owner()
    }
}
```

> **NOTE** A constructor must be implemented to initialize the owner.

For more information please see the [specification](./SPECIFICATION.md).
