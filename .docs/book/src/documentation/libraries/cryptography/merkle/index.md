# Merkle Library

Merkle trees allow for on-chain verification of off-chain data. With the merkle root posted on-chain, the generation of proofs off-chain can provide verifibly true data. 

More information can be found in the [specification](../../../../../../../libs/merkle_proof/SPECIFICATION.md).

# Using the Library

## Importing the Merkle Library

In order to use the Merkle Library, Sway Libs must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../../../getting_started/index.md).

To import the Merkle Library to your Sway Smart Contract, add the following to your Sway file:

```sway
use sway_libs::merkle::binary_proof::*;
```

## Using the Merkle Proof Library In Sway

Once imported, using the Merkle Proof library is as simple as calling the desired function. Here is a list of function definitions that you may use. For more information please see the [specification](./SPECIFICATION.md).

- `leaf_digest()`
- `node_digest()`
- `process_proof()`
- `verify_proof()`

## Basic Functionality

### Computing Leaves and Nodes

The Binary Proof currently allows for you to compute leaves and nodes of a merkle tree given the appropriate hash digest.

To compute a leaf use the `leaf_digest()` function:

```sway
fn foo(hashed_data: b256) {
    let leaf: b256 = leaf_digest(hashed_data);
}
```

To compute a node given two leaves, use the `node_digest()` function:

```sway
fn foo(leaf_a: b256, leaf_b: b256) {
    let node: b256 = node_digest(leaf_a, leaf_b);
}
```

> **NOTE** Order matters when computing a node.

### Computing the Merkle Root

To compute a Merkle root given a proof, use the `process_proof()` function.

```sway
fn foo(key: u64, leaf: b256, num_leaves: u64, proof: Vec<b256>) {
    let merkle_root: b256 = process_proof(key, leaf, num_leaves, proof);
}
```

### Verifying a Proof

To verify a proof against a merkle root, use the `verify_proof()` function.

```sway
fn foo(merkle_roof: b256, key: u64, leaf: b256, num_leaves: u64, proof: Vec<b256>) {
    assert(verify_proof(key, leaf, merkle_root, num_leaves, proof));
}
```

## Using the Merkle Proof Library with Fuels-rs

To generate a Merkle Tree and corresponding proof for your Sway Smart Contract, use the [Fuel-Merkle](https://github.com/FuelLabs/fuel-vm/tree/master/fuel-merkle) crate. 

### Importing Into Your Project

The import the Fuel-Merkle crate, the following should be added to the project's `Cargo.toml` file under `[dependencies]`:

```
fuel-merkle = { version = "0.33.0" }
```

### Importing Into Your Rust File

The following should be added to your Rust file to use the Fuel-Merkle crate.

```rust
use fuel_merkle::{
    binary::in_memory::MerkleTree,
    common::Bytes32,
};
```

### Using Fuel-Merkle

#### Generating A Tree

To create a merkle tree using Fuel-Merkle is as simple as pushing your leaves in increasing order. 

```rust
let mut tree = MerkleTree::new();
let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
for datum in leaves.iter() {
    let mut hasher = Sha256::new();
    hasher.update(&datum);
    let hash: Bytes32 = hasher.finalize().try_into().unwrap();
    tree.push(hash);
}
```

#### Generating And Verifying A Proof

To generate a proof for a specific leaf, you must have the index or key of the leaf. Simply call the prove function:

```rust
let mut proof = tree.prove(key).unwrap();
```

Once the proof has been generated, you may call the Sway Smart Contract's `verify_proof` function:

```rust
let merkle_root = proof.0;
let merkle_leaf = proof.1[0];
proof.1.remove(0);
contract_instance.verify_proof(key, merkle_leaf, merkle_root, num_leaves, proof.1).call().await;
```
