# Bytecode Library

The Bytecode Library allows for on-chain verification and computation of bytecode roots for contracts and predicates.

A bytecode root for a contract and predicate is the Merkle root of the [binary Merkle tree](https://github.com/FuelLabs/fuel-specs/blob/master/src/protocol/cryptographic-primitives.md#binary-merkle-tree) with each leaf being 16KiB of instructions. This library will compute any contract's or predicate's bytecode root/address allowing for the verification of deployed contracts and generation of predicate addresses on-chain.

For implementation details on the Bytecode Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/bytecode/bytecode/).

## Importing the Bytecode Library

In order to use the Bytecode Library, the Bytecode Library must be added to your `Forc.toml` file and then imported into your Sway project.

To add the Bytecode Library as a dependency to your `Forc.toml` file in your project, use the `forc add` command.

```bash
forc add bytecode@0.26.0
```

> **NOTE:** Be sure to set the version to the latest release.

To import the Bytecode Library to your Sway Smart Contract, add the following to your Sway file:

```sway
use bytecode::*;
```

## Using the Bytecode Library In Sway

Once imported, using the Bytecode Library is as simple as calling the desired function. Here is a list of function definitions that you may use.

- `compute_bytecode_root()`
- `compute_predicate_address()`
- `predicate_address_from_root()`
- `swap_configurables()`
- `verify_contract_bytecode()`
- `verify_predicate_address()`

## Known Issues

Please note that if you are passing the bytecode from the SDK and are including configurable values, the `Vec<u8>` bytecode provided must be copied to be mutable. The following can be added to make your bytecode mutable:

```sway
fn make_mutable(not_mutable_bytecode: Vec<u8>) {
    // Copy the bytecode to a newly allocated memory to avoid memory ownership error.
    let mut bytecode_slice = raw_slice::from_parts::<u8>(
        alloc_bytes(not_mutable_bytecode.len()),
        not_mutable_bytecode
            .len(),
    );
    not_mutable_bytecode
        .ptr()
        .copy_bytes_to(bytecode_slice.ptr(), not_mutable_bytecode.len());
    let mut bytecode_vec = Vec::from(bytecode_slice);
    // You may now use `bytecode_vec` in your computation and verification function calls
}
```

## Basic Functionality

The examples below are intended for internal contract calls. If you are passing bytecode from the SDK, please follow the steps listed above in known issues to avoid the memory ownership error.

## Swapping Configurables

Given some bytecode, you may swap the configurables of both Contracts and Predicates by calling the `swap_configurables()` function.

```sway
fn swap(
    my_bytecode: Vec<u8>,
    my_configurables: ContractConfigurables,
) {
    let mut my_bytecode = my_bytecode;
    let resulting_bytecode: Vec<u8> = swap_configurables(my_bytecode, my_configurables);
}
```

## Contracts

### Computing the Bytecode Root

To compute a contract's bytecode root you may call the `compute_bytecode_root()` function.

```sway
fn compute_bytecode(
    my_bytecode: Vec<u8>,
    my_configurables: Option<ContractConfigurables>,
) {
    let mut my_bytecode = my_bytecode;
    let root: BytecodeRoot = compute_bytecode_root(my_bytecode, my_configurables);
}
```

### Verifying a Contract's Bytecode Root

To verify a contract's bytecode root you may call `verify_bytecode_root()` function.

```sway
fn verify_contract(
    my_contract: ContractId,
    my_bytecode: Vec<u8>,
    my_configurables: Option<ContractConfigurables>,
) {
    let mut my_bytecode = my_bytecode;
    verify_contract_bytecode(my_contract, my_bytecode, my_configurables);
    // By reaching this line the contract has been verified to match the bytecode provided.
}
```

## Predicates

### Computing the Address from Bytecode

To compute a predicate's address you may call the `compute_predicate_address()` function.

```sway
fn compute_predicate(
    my_bytecode: Vec<u8>,
    my_configurables: Option<ContractConfigurables>,
) {
    let mut my_bytecode = my_bytecode;
    let address: Address = compute_predicate_address(my_bytecode, my_configurables);
}
```

### Computing the Address from a Root

If you have the root of a predicate, you may compute it's corresponding predicate address by calling the `predicate_address_from_root()` function.

```sway
fn predicate_address(my_root: BytecodeRoot) {
    let address: Address = predicate_address_from_root(my_root);
}
```

### Verifying the Address

To verify a predicates's address you may call `verify_predicate_address()` function.

```sway
fn verify_predicate(
    my_predicate: Address,
    my_bytecode: Vec<u8>,
    my_configurables: Option<ContractConfigurables>,
) {
    let mut my_bytecode = my_bytecode;
    verify_predicate_address(my_predicate, my_bytecode, my_configurables);
    // By reaching this line the predicate bytecode matches the address provided.
}
```
