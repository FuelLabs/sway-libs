# Reentrancy Guard Library

The Reentrancy Guard Library provides an API to check for and disallow reentrancy on a contract. A reentrancy attack happens when a function is externally invoked during its execution, allowing it to be run multiple times in a single transaction

# Known Issues

While this can protect against both single-function reentrancy and cross-function reentrancy attacks, it WILL NOT PREVENT a cross-contract reentrancy attack.

# Using the Library

## Importing the Reentrancy Guard Library

In order to use the Reentrancy Guard library, Sway Libs must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../../../getting_started/index.md).

To import the Reentrancy Guard Library to your Sway Smart Contract, add the following to your Sway file:

```sway
use sway_libs::reentrancy::*;
```

## Basic Functionality

Once imported, using the Reentrancy Library can be done by calling one of the two functions:

- `is_reentrant() -> bool`
- `reentrancy_guard()`

### Using the Reentrancy Guard

Once imported, using the Reentrancy Guard Library can be used by calling the `reentrancy_guard()` in your Sway Smart Contract. The following shows a Sway Smart Contract that applies the Reentrancy Guard Library:

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

### Checking Reentrancy Status

To check if the current caller is a reentrant, you may call the `is_reentrant()` function.

```sway
use sway_libs::reentrancy::is_reentrant;

fn check_if_reentrant() {
    assert(!is_reentrant());
}
```

More information can be found in the [specification](../../../../../../../libs/reentrancy/SPECIFICATION.md).
