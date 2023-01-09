# Overview

StorageMapVec is a temporary workaround for implementing a StorageMap<K, StorageVec<V>>. See why you cannot use StorageMap<K, StorageVec<V>> directly in [this issue](https://github.com/FuelLabs/sway/issues/2639). This library will be deprecated when that issue is resolved.

More information can be found in the [specification](./SPECIFICATION.md).

## Known Issues

StorageMapVec, like its predecessors (StorageMap, StorageVec) cannot be used recursively or multiple times (in a struct) for the same storage variable, or else it will overwrite its previous values.

# Using the Library

## Using the Merkle Proof Library In Sway

Once imported, using the StorageMapVec library is as simple as making a storage variable and then calling the methods on it. Here is an example. For more information please see the [specification](./SPECIFICATION.md).

`use sway_libs::storagemapvec::StorageMapVec;

storage {
    mapvec: StorageMapVec<u64, u64> = StorageMapVec {},
}

abi MyContract {
    #[storage(read, write)]
    fn push(key: u64, value: u64);

    #[storage(read)]
    fn get(key: u64, index: u64);
}

impl MyContract for Contract {
    #[storage(read, write)]
    fn push(key: u64, value: u64) {
        // this will push the value to the vec, which is accessible with the key
        storage.mapvec.push(key, value);
    }

    #[storage(read)]
    fn get(key: u64, index: u64) {
        // this will retrieve the vec at given key, and then retrieve the value at given index from that vec
        storage.mapvec.get(key, index)
    }
}
`

## Using the Merkle Proof Library in Fuels-rs

To generate a Merkle Tree and corresponding proof for your Sway Smart Contract, use the [Fuel-Merkle](https://github.com/FuelLabs/fuel-merkle) crate. 

### Importing Into Your Project

The import the Fuel-Merkle crate, the following should be added to the project's `Cargo.toml` file under `[dependencies]`:

```
fuel-merkle = { version = "0.3" }
```

### Importing Into Your Rust File

The following should be added to your Rust file to use the Fuel-Merkle crate.

```rust
use fuel_merkle::binary::in_memory::MerkleTree;
```

### Using Fuel-Merkle

#### Generating A Tree

To create a merkle tree using Fuel-Merkle is as simple as pushing your leaves in increasing order. 

```rust
let mut tree = MerkleTree::new();
let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
for datum in leaves.iter() {
    tree.push(datum);
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
