<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".docs/bytecode-logo-dark-theme.png">
        <img alt="Bytecode logo" width="400px" src=".docs/bytecode-logo-light-theme.png">
    </picture>
</p>

# Overview

The Bytecode Library allows for on-chain verification and computation of bytecode roots for contracts and predicates. 

A bytecode root for a contract and predicate is the Merkle root of the [binary Merkle tree](https://github.com/FuelLabs/fuel-specs/blob/master/src/protocol/cryptographic-primitives.md#binary-merkle-tree) with each leaf being 16KiB of instructions. This library will compute any contract's or predicate's bytecode root/address allowing for the verification of deployed contracts and generation of predicate addresses on-chain. 

More information can be found in the [specification](./SPECIFICATION.md).

# Using the Library

## Using the Bytecode Library In Sway

In order to use the Bytecode Library, Sway Libs must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway-libs as a dependency to the `Forc.toml` file in your project please see the [README.md](../../README.md).

You may import the Bytecode Library's functionalities like so:

```sway
use sway_libs::bytecode::*;
```

Once imported, using the Bytecode Library is as simple as calling the desired function. Here is a list of function definitions that you may use. For more information please see the [specification](./SPECIFICATION.md).

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

## Basic Functionality

Please note that if you are passing the bytecode from the SDK and are including configurable values, the `Vec<u8>` bytecode provided must be copied to be mutable. The examples below are intended for internal contract calls. 

## Contracts

To compute a contract's bytecode root you may call the `compute_bytecode_root()` or `compute_bytecode_root_with_configurables()` functions.

```sway
fn foo(my_bytecode: Vec<u8>) {
    let root: b256 = compute_bytecode_root(my_bytecode);
}

fn bar(my_bytecode: Vec<u8>, my_configurables: Vec<(u64, Vec<u8>)>) {
    let mut my_bytecode = my_bytecode;
    let root: b256 = compute_bytecode_root_with_configurables(my_bytecode, my_configurables);
}
```

To verify a contract's bytecode root you may call `compute_bytecode_root()` or `verify_contract_bytecode_with_configurables()` functions.

```sway
fn foo(my_contract: ContractId, my_bytecode: Vec<u8>) {
    verify_contract_bytecode(my_contract, my_bytecode);
    // By reaching this line the contract has been verified to match the bytecode provided.
}

fn bar(my_contract: ContractId, my_bytecode: Vec<u8>, my_configurables: Vec<(u64, Vec<u8>)>) {
    let mut my_bytecode = my_bytecode;
    verify_contract_bytecode_with_configurables(my_contract, my_bytecode, my_configurables);
    // By reaching this line the contract has been verified to match the bytecode provided.
}
```

## Predicates

To compute a predicates's address you may call the `compute_predicate_address()` or `compute_predicate_address_with_configurables()` functions.

```sway
fn foo(my_bytecode: Vec<u8>) {
    let address: Address = compute_predicate_address(my_bytecode);
}

fn bar(my_bytecode: Vec<u8>, my_configurables: Vec<(u64, Vec<u8>)>) {
    let mut my_bytecode = my_bytecode;
    let address: Address = compute_predicate_address_with_configurables(my_bytecode, my_configurables);
}
```

To verify a predicates's address you may call `verify_predicate_address()` or `verify_predicate_address_with_configurables()` functions.

```sway
fn foo(my_predicate: Address, my_bytecode: Vec<u8>) {
    verify_predicate_address(my_predicate, my_bytecode);
    // By reaching this line the predicate bytecode matches the address provided.
}

fn bar(my_predicate: Address, my_bytecode: Vec<u8>, my_configurables: Vec<(u64, Vec<u8>)>) {
    let mut my_bytecode = my_bytecode;
    verify_predicate_bytecode_with_configurables(my_predicate, my_bytecode, my_configurables);
    // By reaching this line the predicate bytecode matches the address provided.
}
```
