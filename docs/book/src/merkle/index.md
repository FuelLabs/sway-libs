# Merkle Library

Merkle trees allow for on-chain verification of off-chain data. With the merkle root posted on-chain, the generation of proofs off-chain can provide verifiably true data.

For implementation details on the Merkle Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/merkle/index.html).

## Importing the Merkle Library

In order to use the Merkle Library, Sway Libs must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../getting_started/index.md).

To import the Merkle Library to your Sway Smart Contract, add the following to your Sway file:

```sway
{{#include ../../../../examples/merkle/src/main.sw:import}}
```

## Using the Merkle Proof Library In Sway

Once imported, using the Merkle Proof library is as simple as calling the desired function. Here is a list of function definitions that you may use.

- `leaf_digest()`
- `node_digest()`
- `process_proof()`
- `verify_proof()`

## Basic Functionality

### Computing Leaves and Nodes

The Binary Proof currently allows for you to compute leaves and nodes of a merkle tree given the appropriate hash digest.

To compute a leaf use the `leaf_digest()` function:

```sway
{{#include ../../../../examples/merkle/src/main.sw:leaf_digest}}
```

To compute a node given two leaves, use the `node_digest()` function:

```sway
{{#include ../../../../examples/merkle/src/main.sw:node_digest}}
```

> **NOTE** Order matters when computing a node.

### Computing the Merkle Root

To compute a Merkle root given a proof, use the `process_proof()` function.

```sway
{{#include ../../../../examples/merkle/src/main.sw:process_proof}}
```

### Verifying a Proof

To verify a proof against a merkle root, use the `verify_proof()` function.

```sway
{{#include ../../../../examples/merkle/src/main.sw:verify_proof}}
```

## Using the Merkle Proof Library with Fuels-rs

To generate a Merkle Tree and corresponding proof for your Sway Smart Contract, use the [Fuel-Merkle](https://github.com/FuelLabs/fuel-vm/tree/master/fuel-merkle) crate.

### Importing Into Your Project

The import the Fuel-Merkle crate, the following should be added to the project's `Cargo.toml` file under `[dependencies]`:

```sway
fuel-merkle = { version = "0.50.0" }
```

> **NOTE** Make sure to use the latest version of the [fuel-merkle](https://crates.io/crates/fuel-merkle) crate.

### Importing Into Your Rust File

The following should be added to your Rust file to use the Fuel-Merkle crate.

```sway
{{#include ../../../../examples/merkle/mod.rs:import}}
```

### Using Fuel-Merkle

#### Generating A Tree

To create a merkle tree using Fuel-Merkle is as simple as pushing your leaves in increasing order.

```sway
{{#include ../../../../examples/merkle/mod.rs:generating_a_tree}}
```

#### Generating And Verifying A Proof

To generate a proof for a specific leaf, you must have the index or key of the leaf. Simply call the prove function:

```sway
{{#include ../../../../examples/merkle/mod.rs:generating_proof}}
```

Once the proof has been generated, you may call the Sway Smart Contract's `verify_proof` function:

```sway
{{#include ../../../../examples/merkle/mod.rs:verify_proof}}
```
