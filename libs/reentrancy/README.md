# Reentrancy Guard Library

The Reentrancy Guard Library provides an API to check for and disallow reentrancy on a contract. A reentrancy attack happens when a function is externally invoked during its execution, allowing it to be run multiple times in a single transaction.

The reentrancy check is used to check if a contract ID has been called more than once in the current call stack.

A reentrancy, or "recursive call" attack can cause some functions to behave in unexpected ways. This can be prevented by asserting a contract has not yet been called in the current transaction. An example can be found [here](https://swcregistry.io/docs/SWC-107).

For implementation details on the Reentrancy Guard Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/reentrancy/reentrancy/).

## Importing the Reentrancy Guard Library

In order to use the Reentrancy Guard library, the Reentrancy Guard Library must be added to your `Forc.toml` file and then imported into your Sway project.

To add the Reentrancy Guard Library as a dependency to your `Forc.toml` file in your project, use the `forc add` command.

```bash
forc add reentrancy@0.26.0
```

> **NOTE:** Be sure to set the version to the latest release.

To import the Reentrancy Guard Library to your Sway Smart Contract, add the following to your Sway file:

```sway
use reentrancy::*;
```

## Basic Functionality

Once imported, using the Reentrancy Library can be done by calling one of the two functions:

- `is_reentrant() -> bool`
- `reentrancy_guard()`

### Using the Reentrancy Guard

Once imported, using the Reentrancy Guard Library can be used by calling the `reentrancy_guard()` in your Sway Smart Contract. The following shows a Sway Smart Contract that applies the Reentrancy Guard Library:

```sway
use reentrancy::reentrancy_guard;

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
use reentrancy::is_reentrant;

fn check_if_reentrant() {
    assert(!is_reentrant());
}
```

## Cross Contract Reentrancy

Cross-Contract Reentrancy is not possible on Fuel due to the use of Native Assets. As such, no contract calls are performed when assets are transferred. However standard security practices when relying on other contracts for state should still be applied, especially when making external calls.
