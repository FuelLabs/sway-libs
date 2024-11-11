# Pausable Library

The Pausable library allows contracts to implement an emergency stop mechanism. This can be useful for scenarios such as having an emergency switch to freeze all transactions in the event of a large bug.

It is highly encouraged to use the [Ownership Library](../ownership/index.md) in combination with the Pausable Library to ensure that only a single administrative user has the ability to pause your contract.

For implementation details on the Pausable Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/pausable/index.html).

## Importing the Pausable Library

In order to use the Pausable library, Sway Libs must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../getting_started/index.md).

To import the Pausable Library to your Sway Smart Contract, add the following to your Sway file:

```sway
{{#include ../../../../examples/pausable/pausable/src/main.sw:import}}
```

## Basic Functionality

### Implementing the `Pausable` abi

The Pausable Library has two states:

- `Paused`
- `Unpaused`

By default, your contract will start in the `Unpaused` state. To pause your contract, you may call the `_pause()` function. The example below provides a basic pausable contract using the Pausable Library's `Pausable` abi without any restrictions such as an administrator.

```sway
{{#include ../../../../examples/pausable/pausable/src/main.sw:pausable_impl}}
```

## Applying Paused Restrictions

When developing a contract, you may want to lock functions down to a specific state. To do this, you may call either of the `require_paused()` or `require_not_paused()` functions. The example below shows these functions in use.

```sway
{{#include ../../../../examples/pausable/pausable/src/main.sw:require_paused}}
```

```sway
{{#include ../../../../examples/pausable/pausable/src/main.sw:require_not_paused}}
```

## Using the Ownership Library with the Pausable Library

It is highly recommended to integrate the [Ownership Library](../ownership/index.md) with the Pausable Library and apply restrictions the `pause()` and `unpause()` functions. This will ensure that only a single user may pause and unpause a contract in cause of emergency. Failure to apply this restriction will allow any user to obstruct a contract's functionality.

The follow example implements the `Pausable` abi and applies restrictions to it's pause/unpause functions. The owner of the contract must be set in a constructor defined by `MyConstructor` in this example.

```sway
{{#include ../../../../examples/pausable/pausable_with_ownership/src/main.sw:impl_with_ownership}}
```
