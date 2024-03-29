# Ownership Library

The Ownership Library provides a way to block anyone other than a **single** "owner" from calling functions. The Ownership Library is often used when needing administrative calls on a contract by a single user.

For implementation details on the Ownership Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/ownership/index.html).

# Using the Library

## Importing the Ownership Library

In order to use the Ownership library, Sway Libs and [Sway Standards]() must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../../../getting_started/index.md). To add Sway Standards as a dependency please see the [Sway Standards Book]().

To import the Ownership Library and [SRC-5](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-5.md) Standard to your Sway Smart Contract, add the following to your Sway file:

```sway
use sway_libs::ownership::*;
use standards::src5::*;
```

## Integrating the Ownership Library into the SRC-5 Standard

To implement the [SRC-5](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-5.md) standard with the Ownership library, be sure to add the Sway Standards dependency to your contract. The following demonstrates the integration of the Ownership library with the SRC-5 standard.

```sway
use sway_libs::ownership::_owner;
use standards::src_5::{State, SRC5};

impl SRC5 for Contract {
    #[storage(read)]
    fn owner() -> State {
        _owner()
    }
}
```

> **NOTE** A constructor method must be implemented to initialize the owner.

## Basic Functionality

### Setting a Contract Owner

Once imported, the Ownership Library's functions will be available. To use them initialize the owner for your contract by calling the `initialize_ownership()` function in your own constructor method.

```sway
#[storage(read, write)]
fn my_constructor(new_owner: Identity) {
    initialize_ownership(new_owner);
}
```

### Applying Restrictions

To restrict a function to only the owner, call the `only_owner()` function.

```sway
#[storage(read)]
fn only_owner_may_call() {
    only_owner();
    // Only the contract's owner may reach this line.
}
```

### Checking the Ownership Status

To return the ownership state from storage, call the `_owner()` function.

```sway
#[storage(read)]
fn get_owner_state() {
    let owner: State = _owner();
}
```
