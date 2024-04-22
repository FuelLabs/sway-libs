# Bytecode Library

The Bytecode Library allows for on-chain verification and computation of bytecode roots for contracts and predicates.

A bytecode root for a contract and predicate is the Merkle root of the [binary Merkle tree](https://github.com/FuelLabs/fuel-specs/blob/master/src/protocol/cryptographic-primitives.md#binary-merkle-tree) with each leaf being 16KiB of instructions. This library will compute any contract's or predicate's bytecode root/address allowing for the verification of deployed contracts and generation of predicate addresses on-chain.

For implementation details on the Bytecode Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/bytecode/index.html).

## Importing the Bytecode Library

In order to use the Bytecode Library, Sway Libs must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../getting_started/index.md).

To import the Bytecode Library to your Sway Smart Contract, add the following to your Sway file:

```sway
{{#include ../../../../examples/bytecode/src/main.sw:import}}
```

## Using the Bytecode Library In Sway

Once imported, using the Bytecode Library is as simple as calling the desired function. Here is a list of function definitions that you may use.

- `compute_bytecode_root()`
- `compute_bytecode_root_with_configurables()`
- `compute_predicate_address()`
- `compute_predicate_address_with_configurables()`
- `predicate_address_from_root()`
- `swap_configurables()`
- `verify_contract_bytecode()`
- `verify_contract_bytecode_with_configurables()`
- `verify_predicate_address()`
- `verify_predicate_address_with_configurables()`

## Known Issues

Please note that if you are passing the bytecode from the SDK and are including configurable values, the `Vec<u8>` bytecode provided must be copied to be mutable. The following can be added to make your bytecode mutable:

```sway
{{#include ../../../../examples/bytecode/src/main.sw:known_issue}}
```

## Basic Functionality

The examples below are intended for internal contract calls. If you are passing bytecode from the SDK, please follow the steps listed above in known issues to avoid the memory ownership error.

## Swapping Configurables

Given some bytecode, you may swap the configurables of both Contracts and Predicates by calling the `swap_configurables()` function.

```sway
{{#include ../../../../examples/bytecode/src/main.sw:swap_configurables}}
```

## Contracts

### Computing the Bytecode Root

To compute a contract's bytecode root you may call the `compute_bytecode_root()` or `compute_bytecode_root_with_configurables()` functions.

```sway
{{#include ../../../../examples/bytecode/src/main.sw:compute_bytecode_root}}
```

### Verifying a Contract's Bytecode Root

To verify a contract's bytecode root you may call `verify_bytecode_root()` or `verify_contract_bytecode_with_configurables()` functions.

```sway
{{#include ../../../../examples/bytecode/src/main.sw:verify_contract_bytecode}}
```

## Predicates

### Computing the Address from Bytecode

To compute a predicates's address you may call the `compute_predicate_address()` or `compute_predicate_address_with_configurables()` functions.

```sway
{{#include ../../../../examples/bytecode/src/main.sw:compute_predicate_address}}
```

### Computing the Address from a Root

If you have the root of a predicate, you may compute it's corresponding predicate address by calling the `predicate_address_from_root()` function.

```sway
{{#include ../../../../examples/bytecode/src/main.sw:predicate_address_from_root}}
```

### Verifying the Address

To verify a predicates's address you may call `verify_predicate_address()` or `verify_predicate_address_with_configurables()` functions.

```sway
{{#include ../../../../examples/bytecode/src/main.sw:verify_predicate_address}}
```
