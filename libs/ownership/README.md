# Ownership Library

The **Ownership Library** provides a straightforward way to restrict specific calls in a Sway contract to a single _owner_. Its design follows the [SRC-5](https://docs.fuel.network/docs/sway-standards/src-5-ownership/) standard from [Sway Standards](https://docs.fuel.network/docs/sway-standards/) and offers a set of functions to initialize, verify, revoke, and transfer ownership.

For implementation details, visit the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/ownership/ownership/).

## Importing the Ownership Library

In order to use the Ownership Library, the Ownership Library and the [SRC-5](https://docs.fuel.network/docs/sway-standards/src-5-ownership/) Standard must be added to your `Forc.toml` file and then imported into your Sway project.

To add the Ownership Library and the [SRC-5](https://docs.fuel.network/docs/sway-standards/src-5-ownership/) Standard as a dependency to your `Forc.toml` file in your project, use the `forc add` command.

```bash
forc add ownership@0.26.0
forc add src5@0.8.0
```

> **NOTE:** Be sure to set the version to the latest release.

To import the Ownership Library and [SRC-5](https://docs.fuel.network/docs/sway-standards/src-5-ownership/) Standard to your Sway Smart Contract, add the following to your Sway file:

```sway
use ownership::*;
use src5::*;
```

## Integrating the Ownership Library into the SRC-5 Standard

When integrating the Ownership Library with [SRC-5](https://docs.fuel.network/docs/sway-standards/src-5-ownership/), ensure that the `SRC5` trait from **Sway Standards** is implemented in your contract, as shown below. The `_owner()` function from this library is used to fulfill the SRC-5 requirement of exposing the ownership state.

```sway
use ownership::_owner;
use src5::{SRC5, State};

impl SRC5 for Contract {
    #[storage(read)]
    fn owner() -> State {
        _owner()
    }
}
```

## Basic Usage

### Setting a Contract Owner

Establishes the initial ownership state by calling `initialize_ownership(new_owner)`. This can only be done once, typically in your contract's constructor.

```sway
#[storage(read, write)]
fn my_constructor(new_owner: Identity) {
    initialize_ownership(new_owner);
}
```

Please note that the example above does not apply any restrictions on who may call the `initialize()` function. This leaves the opportunity for a bad actor to front-run your contract and claim ownership for themselves. To ensure the intended `Identity` is set as the contract owner upon contract deployment, use a `configurable` where the `INITIAL_OWNER` is the intended owner of the contract.

```sway
configurable {
    INITAL_OWNER: Identity = Identity::Address(Address::zero()),
}

impl MyContract for Contract {
    #[storage(read, write)]
    fn initialize() {
        initialize_ownership(INITAL_OWNER);
    }
}
```

### Applying Restrictions

Protect functions so only the owner can call them by invoking `only_owner()` at the start of those functions.

```sway
#[storage(read)]
fn only_owner_may_call() {
    only_owner();
    // Only the contract's owner may reach this line.
}
```

### Checking the Ownership Status

To retrieve the current ownership state, call `_owner()`.

```sway
#[storage(read)]
fn get_owner_state() {
    let owner: State = _owner();
}
```

### Transferring Ownership

To transfer ownership from the current owner to a new owner, call `transfer_ownership(new_owner)`.

```sway
#[storage(read, write)]
fn transfer_contract_ownership(new_owner: Identity) {
    // The caller must be the current owner.
    transfer_ownership(new_owner);
}
```

### Renouncing Ownership

To revoke ownership entirely and disallow the assignment of a new owner, call `renounce_ownership()`.

```sway
#[storage(read, write)]
fn renounce_contract_owner() {
    // The caller must be the current owner.
    renounce_ownership();
    // Now no one owns the contract.
}
```

## Events

### `OwnershipRenounced`

Emitted when ownership is revoked.

- **Fields:**
  - `previous_owner`: Identity of the owner prior to revocation.

### `OwnershipSet`

Emitted when initial ownership is set.

- **Fields:**
  - `new_owner`: Identity of the newly set owner.

### `OwnershipTransferred`

Emitted when ownership is transferred from one owner to another.

- **Fields:**
  - `new_owner`: Identity of the new owner.
  - `previous_owner`: Identity of the prior owner.

## Errors

### `InitializationError`

- **Variants:**
  - `CannotReinitialized`: Thrown when attempting to initialize ownership if the owner is already set.

### `AccessError`

- **Variants:**
  - `NotOwner`: Thrown when a function restricted to the owner is called by a non-owner.

## Example Integration

Below is a example illustrating how to use this library within a Sway contract:

```sway
contract;

use ownership::{_owner, initialize_ownership, only_owner, renounce_ownership, transfer_ownership};
use src5::{SRC5, State};

configurable {
    INITAL_OWNER: Identity = Identity::Address(Address::zero()),
}

impl SRC5 for Contract {
    #[storage(read)]
    fn owner() -> State {
        _owner()
    }
}

abi MyContract {
    #[storage(read, write)]
    fn initialize();
    #[storage(read)]
    fn restricted_action();
    #[storage(read, write)]
    fn change_owner(new_owner: Identity);
    #[storage(read, write)]
    fn revoke_ownership();
    #[storage(read)]
    fn get_current_owner() -> State;
}

impl MyContract for Contract {
    #[storage(read, write)]
    fn initialize() {
        initialize_ownership(INITAL_OWNER);
    }

    // A function restricted to the owner
    #[storage(read)]
    fn restricted_action() {
        only_owner();
        // Protected action
    }

    // Transfer ownership
    #[storage(read, write)]
    fn change_owner(new_owner: Identity) {
        transfer_ownership(new_owner);
    }

    // Renounce ownership
    #[storage(read, write)]
    fn revoke_ownership() {
        renounce_ownership();
    }

    // Get current owner state
    #[storage(read)]
    fn get_current_owner() -> State {
        _owner()
    }
}
```

1. **Initialization:** Call `constructor(new_owner)` once to set the initial owner.  
2. **Restricted Calls:** Use `only_owner()` to guard any owner-specific functions.  
3. **Ownership Checks:** Retrieve the current owner state via `_owner()`.  
4. **Transfer or Renounce:** Use `transfer_ownership(new_owner)` or `renounce_ownership()` for ownership modifications.
