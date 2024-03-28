<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".docs/merkle-logo-dark-theme.png">
        <img alt="SwayApps logo" width="400px" src=".docs/merkle-logo-light-theme.png">
    </picture>
</p>

# Overview

Merkle trees allow for on-chain verification of off-chain data. With the merkle root posted on-chain, the generation of proofs off-chain can provide verifibly true data. 

More information can be found in the [specification](./SPECIFICATION.md).

# Using the Library

## Using the Merkle Proof Library In Sway

In order to use the Merkle library, Sway Libs must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [README.md](../../README.md).

You may import the Merkle library's functionalities like so:

```sway
use sway_libs::merkle::binary_proof::*;
```

Once imported, using the Merkle Proof library is as simple as calling the desired function. Here is a list of function definitions that you may use. For more information please see the [specification](./SPECIFICATION.md).

- `leaf_digest(data: b256) -> b256`
- `node_digest(left: b256, right: b256) -> b256`
- `process_proof(key: u64, merkle_leaf: b256, num_leaves: u64, proof: [b256; 2]) -> b256`
- `verify_proof(key: u64, merkle_leaf: b256, merkle_root: b256, num_leaves: u64, proof: [b256; 2]) -> bool`

## Using the Merkle Proof Library in Fuels-rs

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
