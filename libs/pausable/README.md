# Pausable Library

The Pausable library allows contracts to implement an emergency stop mechanism. This can be useful for scenarios such as having an emergency switch to freeze all transactions in the event of a large bug.

It is highly encouraged to use the [Ownership Library](https://docs.fuel.network/docs/sway-libs/ownership/) in combination with the Pausable Library to ensure that only a single administrative user has the ability to pause your contract.

For implementation details on the Pausable Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/pausable/pausable/).

## Importing the Pausable Library

In order to use the Pausable library, the Pausable Library must be added to your `Forc.toml` file and then imported into your Sway project.

To add the Pausable Library as a dependency to your `Forc.toml` file in your project, use the `forc add` command.

```bash
forc add pausable@0.26.2
```

> **NOTE:** Be sure to set the version to the latest release.

To import the Pausable Library to your Sway Smart Contract, add the following to your Sway file:

```sway
use pausable::*;
```

## Basic Functionality

### Implementing the `Pausable` abi

The Pausable Library has two states:

- `Paused`
- `Unpaused`

By default, your contract will start in the `Unpaused` state. To pause your contract, you may call the `_pause()` function. The example below provides a basic pausable contract using the Pausable Library's `Pausable` abi without any restrictions such as an administrator.

```sway
use pausable::{_is_paused, _pause, _unpause, Pausable};

impl Pausable for Contract {
    #[storage(write)]
    fn pause() {
        _pause();
    }

    #[storage(write)]
    fn unpause() {
        _unpause();
    }

    #[storage(read)]
    fn is_paused() -> bool {
        _is_paused()
    }
}
```

## Applying Paused Restrictions

When developing a contract, you may want to lock functions down to a specific state. To do this, you may call either of the `require_paused()` or `require_not_paused()` functions. The example below shows these functions in use.

```sway
use pausable::require_paused;

#[storage(read)]
fn require_paused_state() {
    require_paused();
    // This comment will only ever be reached if the contract is in the paused state
}
```

```sway
use pausable::require_not_paused;

#[storage(read)]
fn require_not_paused_state() {
    require_not_paused();
    // This comment will only ever be reached if the contract is in the unpaused state
}
```

## Using the Ownership Library with the Pausable Library

It is highly recommended to integrate the [Ownership Library](https://docs.fuel.network/docs/sway-libs/ownership/) with the Pausable Library and apply restrictions the `pause()` and `unpause()` functions. This will ensure that only a single user may pause and unpause a contract in cause of emergency. Failure to apply this restriction will allow any user to obstruct a contract's functionality.

The follow example implements the `Pausable` abi and applies restrictions to it's pause/unpause functions. The owner of the contract must be set in a constructor defined by `MyConstructor` in this example.

```sway
use pausable::{_is_paused, _pause, _unpause, Pausable};
use ownership::{initialize_ownership, only_owner};

abi MyConstructor {
    #[storage(read, write)]
    fn my_constructor(new_owner: Identity);
}

impl MyConstructor for Contract {
    #[storage(read, write)]
    fn my_constructor(new_owner: Identity) {
        initialize_ownership(new_owner);
    }
}

impl Pausable for Contract {
    #[storage(write)]
    fn pause() {
        // Add the `only_owner()` check to ensure only the owner may unpause this contract.
        only_owner();
        _pause();
    }

    #[storage(write)]
    fn unpause() {
        // Add the `only_owner()` check to ensure only the owner may unpause this contract.
        only_owner();
        _unpause();
    }

    #[storage(read)]
    fn is_paused() -> bool {
        _is_paused()
    }
}
```
