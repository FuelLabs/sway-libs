# Merkle Library

Merkle trees allow for on-chain verification of off-chain data. With the merkle root posted on-chain, the generation of proofs off-chain can provide verifiably true data.

The Merkle Library currently supports two different tree structures: Binary Trees and Sparse Trees. For information implementation specifications, please refer to the [Merkle Tree Specification](https://docs.fuel.network/docs/specs/protocol/cryptographic-primitives/#merkle-trees).

For implementation details on the Merkle Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/merkle/index.html).

## Importing the Merkle Library

In order to use the Merkle Library, Sway Libs must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../getting_started/index.md).

To import the Binary Merkle Library to your Sway Smart Contract, add the following to your Sway file:

```sway
{{#include ../../../../examples/merkle_binary/src/main.sw:import}}
```

To import the Sparse Merkle Library to your Sway Smart Contract, add the following to your Sway file:

```sway
{{#include ../../../../examples/merkle_sparse/src/main.sw:import}}
```

## Using the Binary Merkle Proof Library In Sway

Once imported, using the Binary Merkle Proof library is as simple as calling the desired function. Here is a list of function definitions that you may use.

- `leaf_digest()`
- `node_digest()`
- `process_proof()`
- `verify_proof()`

### Binary Sway Functionality

#### Computing Leaves and Nodes of a Binary Tree

The Binary Proof currently allows for you to compute leaves and nodes of a merkle tree given the appropriate hash digest.

To compute a leaf use the `leaf_digest()` function:

```sway
{{#include ../../../../examples/merkle_binary/src/main.sw:leaf_digest}}
```

To compute a node given two leaves, use the `node_digest()` function:

```sway
{{#include ../../../../examples/merkle_binary/src/main.sw:node_digest}}
```

> **NOTE** Order matters when computing a node.

#### Computing the Merkle Root of a Binary Tree

To compute a Merkle root given a proof, use the `process_proof()` function.

```sway
{{#include ../../../../examples/merkle_binary/src/main.sw:process_proof}}
```

#### Verifying the Proof of a Binary Tree

To verify a proof against a merkle root, use the `verify_proof()` function.

```sway
{{#include ../../../../examples/merkle_binary/src/main.sw:verify_proof}}
```

### Using the Binary Merkle Proof Library with Fuels-rs

To generate a Binary Merkle Tree and corresponding proof for your Sway Smart Contract, use the [Fuel-Merkle](https://github.com/FuelLabs/fuel-vm/tree/master/fuel-merkle) crate.

#### Importing Binary Into Your Project

To import the Fuel-Merkle crate, the following should be added to the project's `Cargo.toml` file under `[dependencies]`:

```sway
fuel-merkle = { version = "0.56.0" }
```

> **NOTE** Make sure to use the latest version of the [fuel-merkle](https://crates.io/crates/fuel-merkle) crate.

#### Importing Binary Into Your Rust File

The following should be added to your Rust file to use the Fuel-Merkle crate.

```rust
{{#include ../../../../examples/merkle_sparse/mod.rs:import}}
```

#### Using Fuel-Merkle's Binary Tree

##### Generating A Binary Tree

To create a merkle tree using Fuel-Merkle is as simple as pushing your leaves in increasing order.

```rust
{{#include ../../../../examples/merkle_sparse/mod.rs:generating_a_tree}}
```

##### Generating And Verifying A Binary Proof

To generate a proof for a specific leaf, you must have the index or key of the leaf. Simply call the prove function:

```rust
{{#include ../../../../examples/merkle_sparse/mod.rs:generating_proof}}
```

Once the proof has been generated, you may call the Sway Smart Contract's `verify_proof` function:

```rust
{{#include ../../../../examples/merkle_sparse/mod.rs:verify_proof}}
```

## Using the Sparse Merkle Proof Library In Sway

Once imported, using the Sparse Merkle Proof library is as simple as calling the desired function on the `Proof` type. Here is a list of function definitions that you may use.

- `root()`
- `verify()`

To explore additional utility and support functions available, please check out the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/merkle/index.html).

### Sparse Sway Functionality

#### Computing the Merkle Root of a Sparse Tree

To compute a Sparse Merkle root given a proof, use the `root()` function. You must provide the appropriate `MerkleTreeKey` and leaf data. Please note that the leaf data should be `Some` if you are proving an inclusion proof, and `None` if your are proving an exclusion proof.

```sway
{{#include ../../../../examples/merkle_sparse/src/main.sw:compute_root}}
```

#### Verifying the Proof of a Sparse Tree

To verify a proof against a merkle root, use the `verify()` function. You must provide the appropriate `MerkleTreeKey`, `MerkleRoot`, and leaf data. Please note that the leaf data should be `Some` if you are proving an inclusion proof, and `None` if your are proving an exclusion proof.

```sway
{{#include ../../../../examples/merkle_sparse/src/main.sw:verify_proof}}
```

#### Verifying an Inclusion Proof with Hashed Data

If you would like to verify an inclusion proof using only the SHA256 hash of the leaf data rather than the entire `Bytes`, you may do so as shown:

```sway
{{#include ../../../../examples/merkle_sparse/src/main.sw:using_hash}}
```

### Using the Sparse Merkle Proof Library with Fuels-rs

To generate a Sparse Merkle Tree and corresponding proof for your Sway Smart Contract, use the [Fuel-Merkle](https://github.com/FuelLabs/fuel-vm/tree/master/fuel-merkle) crate.

#### Importing Sparse Tree Into Your Project

To import the Fuel-Merkle crate, the following should be added to the project's `Cargo.toml` file under `[dependencies]`:

```sway
fuel-merkle = { version = "0.56.0" }
```

> **NOTE** Make sure to use the latest version of the [fuel-merkle](https://crates.io/crates/fuel-merkle) crate.

#### Importing Sparse Tree Into Your Rust File

The following should be added to your Rust file to use the Fuel-Merkle crate.

```rust
{{#include ../../../../examples/merkle_sparse/mod.rs:import}}
```

#### Using Fuel-Merkle's Sparse Tree

##### Generating A Sparse Tree

To create a merkle tree using Fuel-Merkle is as simple as pushing your leaves in increasing order.

```rust
{{#include ../../../../examples/merkle_sparse/mod.rs:generating_a_tree}}
```

##### Generating And Verifying A Sparse Proof

To generate a proof for a specific leaf, you must have the index or key of the leaf. Simply call the prove function:

```rust
{{#include ../../../../examples/merkle_sparse/mod.rs:generating_proof}}
```

Once the proof has been generated, you may call the Sway Smart Contract's `verify_proof` function:

```rust
{{#include ../../../../examples/merkle_sparse/mod.rs:verify_proof}}
```

##### Converting from a Fuel Proof to a Sway Proof

The Rust SDK does not currently support the `Proof` type in Sway and will conflict with the `Proof` type in fuel-merkle. Therefore, you MUST import the `Proof` type from fuel-merkle as `FuelProof`.

To convert between the two types, you may use the following function:

```rust
{{#include ../../../../examples/merkle_sparse/mod.rs:sway_conversion}}
```
