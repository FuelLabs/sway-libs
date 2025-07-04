# Merkle Library

Merkle trees allow for on-chain verification of off-chain data. With the merkle root posted on-chain, the generation of proofs off-chain can provide verifiably true data.

The Merkle Library currently supports two different tree structures: Binary Trees and Sparse Trees. For information implementation specifications, please refer to the [Merkle Tree Specification](https://docs.fuel.network/docs/specs/protocol/cryptographic-primitives/#merkle-trees).

For implementation details on the Merkle Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/merkle/merkle/).

## Importing the Merkle Library

In order to use the Merkle Library, the Merkle Library must be added to your `Forc.toml` file and then imported into your Sway project.

To add the Merkle Library as a dependency to your `Forc.toml` file in your project, use the `forc add` command.

```bash
forc add merkle@0.26.0
```

> **NOTE:** Be sure to set the version to the latest release.

To import the Binary Merkle Library to your Sway Smart Contract, add the following to your Sway file:

```sway
use merkle::binary::{leaf_digest, process_proof, verify_proof};
use merkle::common::{MerkleRoot, node_digest, ProofSet};
```

To import the Sparse Merkle Library to your Sway Smart Contract, add the following to your Sway file:

```sway
use merkle::sparse::*;
use merkle::common::{MerkleRoot, ProofSet};
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
fn compute_leaf(hashed_data: b256) {
    let leaf: b256 = leaf_digest(hashed_data);
}
```

To compute a node given two leaves, use the `node_digest()` function:

```sway
fn compute_node(leaf_a: b256, leaf_b: b256) {
    let node: b256 = node_digest(leaf_a, leaf_b);
}
```

> **NOTE** Order matters when computing a node.

#### Computing the Merkle Root of a Binary Tree

To compute a Merkle root given a proof, use the `process_proof()` function.

```sway
fn process(key: u64, leaf: b256, num_leaves: u64, proof: ProofSet) {
    let merkle_root: MerkleRoot = process_proof(key, leaf, num_leaves, proof);
}
```

#### Verifying the Proof of a Binary Tree

To verify a proof against a merkle root, use the `verify_proof()` function.

```sway
fn verify(
    merkle_root: MerkleRoot,
    key: u64,
    leaf: b256,
    num_leaves: u64,
    proof: ProofSet,
) {
    assert(verify_proof(key, leaf, merkle_root, num_leaves, proof));
}
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
use fuel_merkle::binary::in_memory::MerkleTree;
```

#### Using Fuel-Merkle's Binary Tree

##### Generating A Binary Tree

To create a merkle tree using Fuel-Merkle is as simple as pushing your leaves in increasing order.

```rust
// Create a new Merkle Tree and define leaves
let mut tree = MerkleTree::new();
let leaves = [b"A", b"B", b"C"].to_vec();

// Hash the leaves and then push to the merkle tree
for datum in &leaves {
    let mut hasher = Sha256::new();
    hasher.update(datum);
    let hash = hasher.finalize();
    tree.push(&hash);
}
```

##### Generating And Verifying A Binary Proof

To generate a proof for a specific leaf, you must have the index or key of the leaf. Simply call the prove function:

```rust
// Define the key or index of the leaf you want to prove and the number of leaves
let key: u64 = 0;

// Get the merkle root and proof set
let (merkle_root, proof_set) = tree.prove(key).unwrap();

// Convert the proof set from Vec<Bytes32> to Vec<Bits256>
let mut bits256_proof: Vec<Bits256> = Vec::new();
for itterator in proof_set {
    bits256_proof.push(Bits256(itterator));
}
```

Once the proof has been generated, you may call the Sway Smart Contract's `verify_proof` function:

```rust
// Create the merkle leaf
let mut leaf_hasher = Sha256::new();
leaf_hasher.update(leaves[key as usize]);
let hashed_leaf_data = leaf_hasher.finalize();
let merkle_leaf = leaf_sum(&hashed_leaf_data);

// Get the number of leaves or data points
let num_leaves: u64 = leaves.len() as u64;

// Call the Sway contract to verify the generated merkle proof
let result: bool = contract_instance
    .methods()
    .verify(
        Bits256(merkle_root),
        key,
        Bits256(merkle_leaf),
        num_leaves,
        bits256_proof,
    )
    .call()
    .await
    .unwrap()
    .value;
assert!(result);
```

## Using the Sparse Merkle Proof Library In Sway

Once imported, using the Sparse Merkle Proof library is as simple as calling the desired function on the `Proof` type. Here is a list of function definitions that you may use.

- `root()`
- `verify()`

To explore additional utility and support functions available, please check out the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/merkle/merkle/).

### Sparse Sway Functionality

#### Computing the Merkle Root of a Sparse Tree

To compute a Sparse Merkle root given a proof, use the `root()` function. You must provide the appropriate `MerkleTreeKey` and leaf data. Please note that the leaf data should be `Some` if you are proving an inclusion proof, and `None` if your are proving an exclusion proof.

```sway
fn compute_root(key: MerkleTreeKey, leaf: Option<Bytes>, proof: Proof) {
    let merkle_root: MerkleRoot = proof.root(key, leaf);
}
```

#### Verifying the Proof of a Sparse Tree

To verify a proof against a merkle root, use the `verify()` function. You must provide the appropriate `MerkleTreeKey`, `MerkleRoot`, and leaf data. Please note that the leaf data should be `Some` if you are proving an inclusion proof, and `None` if your are proving an exclusion proof.

```sway
fn verify_proof(
    root: MerkleRoot,
    key: MerkleTreeKey,
    leaf: Option<Bytes>,
    proof: Proof,
) {
    let result: bool = proof.verify(root, key, leaf);
    assert(result);
}
```

#### Verifying an Inclusion Proof with Hashed Data

If you would like to verify an inclusion proof using only the SHA256 hash of the leaf data rather than the entire `Bytes`, you may do so as shown:

```sway
fn inclusion_proof_hash(key: MerkleTreeKey, leaf: b256, proof: Proof) {
    assert(proof.is_inclusion());

    // Compute the merkle root of an inclusion proof using the sha256 hash of the leaf
    let root: MerkleRoot = proof.as_inclusion().unwrap().root_from_hash(key, leaf);

    // Verifying an inclusion proof using the sha256 hash of the leaf
    let result: bool = proof.as_inclusion().unwrap().verify_hash(root, key, leaf);
    assert(result);
}
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
use fuel_merkle::sparse::in_memory::MerkleTree as SparseTree;
use fuel_merkle::sparse::proof::ExclusionLeaf as FuelExclusionLeaf;
use fuel_merkle::sparse::proof::Proof as FuelProof;
use fuel_merkle::sparse::MerkleTreeKey as SparseTreeKey;
use fuels::types::{Bits256, Bytes};
```

#### Using Fuel-Merkle's Sparse Tree

##### Generating A Sparse Tree

To create a merkle tree using Fuel-Merkle is as simple as pushing your leaves in increasing order.

```rust
// Create a new Merkle Tree and define leaves
let mut tree = SparseTree::new();
let leaves = ["A", "B", "C"].to_vec();
let leaf_to_prove = "A";
let key = SparseTreeKey::new(leaf_to_prove);

// Hash the leaves and then push to the merkle tree
for datum in &leaves {
    let _ = tree.update(SparseTreeKey::new(datum), datum.as_bytes());
}
```

##### Generating And Verifying A Sparse Proof

To generate a proof for a specific leaf, you must have the index or key of the leaf. Simply call the prove function:

```rust
// Get the merkle root and proof set
let root = tree.root();
let fuel_proof: FuelProof = tree.generate_proof(&key).unwrap();

// Convert the proof from a FuelProof to the Sway Proof
let sway_proof: Proof = fuel_to_sway_sparse_proof(fuel_proof);
```

Once the proof has been generated, you may call the Sway Smart Contract's `verify_proof` function:

```rust
// Call the Sway contract to verify the generated merkle proof
let result: bool = contract_instance
    .methods()
    .verify(
        Bits256(root),
        Bits256(*key),
        Some(Bytes(leaves[0].into())),
        sway_proof,
    )
    .call()
    .await
    .unwrap()
    .value;

assert!(result);
```

##### Converting from a Fuel Proof to a Sway Proof

The Rust SDK does not currently support the `Proof` type in Sway and will conflict with the `Proof` type in fuel-merkle. Therefore, you MUST import the `Proof` type from fuel-merkle as `FuelProof`.

To convert between the two types, you may use the following function:

```rust
pub fn fuel_to_sway_sparse_proof(fuel_proof: FuelProof) -> Proof {
    let mut proof_bits: Vec<Bits256> = Vec::new();
    for iterator in fuel_proof.proof_set().iter() {
        proof_bits.push(Bits256(iterator.clone()));
    }

    match fuel_proof {
        FuelProof::Exclusion(exlcusion_proof) => Proof::Exclusion(ExclusionProof {
            proof_set: proof_bits,
            leaf: match exlcusion_proof.leaf {
                FuelExclusionLeaf::Leaf(leaf_data) => ExclusionLeaf::Leaf(ExclusionLeafData {
                    leaf_key: Bits256(leaf_data.leaf_key),
                    leaf_value: Bits256(leaf_data.leaf_value),
                }),
                FuelExclusionLeaf::Placeholder => ExclusionLeaf::Placeholder,
            },
        }),
        FuelProof::Inclusion(_) => Proof::Inclusion(InclusionProof {
            proof_set: proof_bits,
        }),
    }
}
```
