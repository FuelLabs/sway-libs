<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".docs/pausable-logo-dark-theme.png">
        <img alt="pausable_logo_light" width="400px" src=".docs/pausable-logo-light-theme.png">
    </picture>
</p>

# Overview

The Pausable library allows contracts to implement an emergency stop mechanism. This can be useful for scenarios such as having an emergency switch to freeze all transactions in the event of a large bug.

This library is completely stateless and follows a packet oriented design providing significant gas savings.

> **NOTE** It is highly encouraged to use the [Ownership Library](../ownership/) in combination with the Pausable Library to ensure that only a single administrative user has the ability to pause your contract.

More information can be found in the [specification](./SPECIFICATION.md).

# Using the Library

## Getting Started

In order to use the Pausable library it must be added to the `Forc.toml` file and then imported into your Sway project. To add Pausable as a dependency to the `Forc.toml` file in your project please see the [README.md](../../README.md).

You may import the Pausable library's functionalities like so:

```rust
use pausable::*;
```

## Basic Functionality

Once imported, the Pausable library's functions should be available. Using the Pausable Library is as simple as calling your desired function.

The Pausable Library has two states:

`- Paused`
`- Unpaused`

By default, your contract will start in the `Unpaused` state. To pause your contract, you may call the `_pause()` function. The example below provides a basic pausable contract using the Pausable Library's `Pausable` abi without any restrictions such as an administrator.

```sway
use pausable::{_is_paused, _pause, _unpause, Pausable};

impl Pausable for Contract {
    fn pause() {
        _pause();
    }

    fn unpause() {
        _unpause();
    }

    fn is_paused() -> bool {
        _is_paused()
    }
}
```

## Requiring A State

When developing a contract, you may want to lock functions down to a specific state. To do this, you may call either of the `require_paused()` or `require_not_paused()` functions. The example below shows these functions in use.

```sway
use pausable::{require_not_paused, require_paused};

abi MyAbi {
    fn require_paused_state();
    fn require_not_paused_state();
}

impl MyAbi for Contract {
    fn require_paused_state() {
        require_paused();
        // This comment will only ever be reached if the contract is in the paused state
    }

    fn require_not_paused_state() {
        require_not_paused();
        // This comment will only ever be reached if the contract is in the unpaused state
    }
}
```
