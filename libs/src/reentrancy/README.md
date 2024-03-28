<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".docs/reentrancy-logo-dark-theme.png">
        <img alt="SwayApps logo" width="400px" src=".docs/reentrancy-logo-light-theme.png">
    </picture>
</p>

# Overview

The Reentrancy library provides an API to check for and disallow reentrancy on a contract.

More information can be found in the [specification](./SPECIFICATION.md).

## Known Issues

While this can protect against both single-function reentrancy and cross-function reentrancy
attacks, it WILL NOT PREVENT a cross-contract reentrancy attack.

## Using the Library

## Getting Started

In order to use the Reentrancy library, Sway Libs must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [README.md](../../README.md).

You may then import the Reentrancy library's functionalities like so:

```sway
use sway_libs::reentrancy::*;
```

### Using the Reentrancy Guard

Once imported, using the Reentrancy Library can be done by calling one of the two functions. For
more information, see the [specification](./SPECIFICATION.md).

- `is_reentrant() -> bool`
- `reentrancy_guard()`

The `reentrancy_guard` function asserts `is_reentrant()` returns false.

## Example

```sway
use sway_libs::reentrancy::reentrancy_guard;

abi MyContract {
    fn my_non_reentrant_function();
}

impl MyContract for Contract {
    fn my_non_reentrant_function() {
        reentrancy_guard();

        // my code here
    }
}
```
