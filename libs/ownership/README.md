# Overview

The Ownership library provides a way to block users other than a single "owner" or "admin" from calling functions. Ownership is often used when needing administrative calls on a contract.

It is important to note that unlike Solidity, Sway does not use constructors. When a contract is deployed there is no owner until one is set. It is important to implement a constructor where the owner is initalized.

> **Note**
> Storage in libraries is not offically supported by Sway. Current storage uses a hash key for manual storage management and will be updated when https://github.com/FuelLabs/sway/issues/2585 is resolved.

For more information please see the [specification](./SPECIFICATION.md).

# Using the Library

## Getting Started

In order to use the `Ownership` library it must be added to the Forc.toml file and then imported into your Sway project. To add Sway-libs as a dependency to the Forc.toml in your project, please see the [README.md](../../../README.md).

```rust
use sway_libs::ownable::{only_owner, owner, set_ownership};
```

Once imported, an owner can be set by calling the `set_ownership` function. 

```rust
set_ownership(new_owner_identity);
```

> **Note**
> This function should be called in your constructor.

## Basic Functionality

To restrict a function to only the owner, call the `only_owner` function.

```rust
only_owner();
```

To return the owner from storage, call the `owner` function.

```rust
let owner: Option<Identity> = owner();
```

For more information please see the [specification](./SPECIFICATION.md).
