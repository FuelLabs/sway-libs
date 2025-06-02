# Ownership Library

The **Ownership Library** provides a straightforward way to restrict specific calls in a Sway contract to a single _owner_. Its design follows the [SRC-5](https://docs.fuel.network/docs/sway-standards/src-5-ownership/) standard from [Sway Standards](https://docs.fuel.network/docs/sway-standards/) and offers a set of functions to initialize, verify, revoke, and transfer ownership.

For implementation details, visit the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/ownership/index.html).

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
{{#include ../../../../examples/ownership/src/lib.sw:import}}
```

## Integrating the Ownership Library into the SRC-5 Standard

When integrating the Ownership Library with [SRC-5](https://docs.fuel.network/docs/sway-standards/src-5-ownership/), ensure that the `SRC5` trait from **Sway Standards** is implemented in your contract, as shown below. The `_owner()` function from this library is used to fulfill the SRC-5 requirement of exposing the ownership state.

```sway
{{#include ../../../../examples/ownership/src/lib.sw:integrate_with_src5}}
```

## Basic Usage

### Setting a Contract Owner

Establishes the initial ownership state by calling `initialize_ownership(new_owner)`. This can only be done once, typically in your contract's constructor.

```sway
{{#include ../../../../examples/ownership/src/lib.sw:initialize}}
```

Please note that the example above does not apply any restrictions on who may call the `initialize()` function. This leaves the opportunity for a bad actor to front-run your contract and claim ownership for themselves. To ensure the intended `Identity` is set as the contract owner upon contract deployment, use a `configurable` where the `INITIAL_OWNER` is the intended owner of the contract.

```sway
{{#include ../../../../examples/ownership_configurable/src/main.sw:ownership_configurable}}
```

### Applying Restrictions

Protect functions so only the owner can call them by invoking `only_owner()` at the start of those functions.

```sway
{{#include ../../../../examples/ownership/src/lib.sw:only_owner}}
```

### Checking the Ownership Status

To retrieve the current ownership state, call `_owner()`.

```sway
{{#include ../../../../examples/ownership/src/lib.sw:state}}
```

### Transferring Ownership

To transfer ownership from the current owner to a new owner, call `transfer_ownership(new_owner)`.

```sway
{{#include ../../../../examples/ownership/src/lib.sw:transfer_ownership}}
```

### Renouncing Ownership

To revoke ownership entirely and disallow the assignment of a new owner, call `renounce_ownership()`.

```sway
{{#include ../../../../examples/ownership/src/lib.sw:renouncing_ownership}}
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
{{#include ../../../../examples/ownership/src/main.sw:example_contract}}
```

1. **Initialization:** Call `constructor(new_owner)` once to set the initial owner.  
2. **Restricted Calls:** Use `only_owner()` to guard any owner-specific functions.  
3. **Ownership Checks:** Retrieve the current owner state via `_owner()`.  
4. **Transfer or Renounce:** Use `transfer_ownership(new_owner)` or `renounce_ownership()` for ownership modifications.
