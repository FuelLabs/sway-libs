<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".docs/ownership-logo-dark-theme.png">
        <img alt="SwayApps logo" width="400px" src=".docs/ownership-logo-light-theme.png">
    </picture>
</p>

# Overview

The Ownership library provides a way to block users other than a single "owner" or "admin" from calling functions. Ownership is often used when needing administrative calls on a contract.

For more information please see the [specification](./SPECIFICATION.md).

# Using the Library

## Getting Started

In order to use the Ownership library it must be added to the Forc.toml file and then imported into your Sway project. To add Sway-libs as a dependency to the Forc.toml file in your project please see the [README.md](../../README.md).

You may import the Ownership library's functionalities like so:

```rust
use ownership::Ownership;
```

Once imported, the `Ownership` struct should be added to the storage block of your contract. There are two approaches when declaring ownership in storage.

1. Initalize the owner on contract deployment by calling the `initalized()` function.

```rust
storage {
    owner: Ownership = Ownership::initalized(Identity::Address(Address::from(0x0000000000000000000000000000000000000000000000000000000000000000))),
}
```

2. Leave the owner uninitialized and call the `set_ownership()` function in your own constructor.

```rust
storage {
    owner: Ownership = Ownership::uninitialized(),
}

#[storage(read, write)]
fn my_constructor(new_owner: Identity) {
    storage.owner.set_ownership(new_owner);
}
```

> **Note** If this approach is taken, `set_ownership()` **MUST** be called to have a contract owner.

## Basic Functionality

To restrict a function to only the owner, call the `only_owner()` function.

```rust
storage.owner.only_owner();
```

To return the owner from storage, call the `owner()` function.

```rust
let owner: Option<Identity> = storage.owner.owner();
```

For more information please see the [specification](./SPECIFICATION.md).
