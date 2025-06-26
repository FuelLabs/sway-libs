contract;

use std::bytes::Bytes;
// ANCHOR: import
use merkle::sparse::*;
use merkle::common::{MerkleRoot, ProofSet};
// ANCHOR_END: import

abi MerkleExample {
    fn verify(
        merkle_root: MerkleRoot,
        key: MerkleTreeKey,
        leaf: Option<Bytes>,
        proof: Proof,
    ) -> bool;
}

impl MerkleExample for Contract {
    fn verify(
        merkle_root: MerkleRoot,
        key: MerkleTreeKey,
        leaf: Option<Bytes>,
        proof: Proof,
    ) -> bool {
        proof.verify(merkle_root, key, leaf)
    }
}

// ANCHOR: leaf_digest
fn compute_leaf(key: MerkleTreeKey, hashed_data: b256) {
    let leaf: b256 = leaf_digest(key, hashed_data);
}
// ANCHOR_END: leaf_digest

// ANCHOR: node_digest
fn compute_node(leaf_a: b256, leaf_b: b256) {
    use merkle::common::node_digest;
    let node: b256 = node_digest(leaf_a, leaf_b);
}
// ANCHOR_END: node_digest

// ANCHOR: compute_root
fn compute_root(key: MerkleTreeKey, leaf: Option<Bytes>, proof: Proof) {
    let merkle_root: MerkleRoot = proof.root(key, leaf);
}
// ANCHOR_END: compute_root

// ANCHOR: verify_proof
fn verify_proof(
    root: MerkleRoot,
    key: MerkleTreeKey,
    leaf: Option<Bytes>,
    proof: Proof,
) {
    let result: bool = proof.verify(root, key, leaf);
    assert(result);
}
// ANCHOR_END: verify_proof

// ANCHOR: using_hash
fn inclusion_proof_hash(key: MerkleTreeKey, leaf: b256, proof: Proof) {
    assert(proof.is_inclusion());

    // Compute the merkle root of an inclusion proof using the sha256 hash of the leaf
    let root: MerkleRoot = proof.as_inclusion().unwrap().root_from_hash(key, leaf);

    // Verifying an inclusion proof using the sha256 hash of the leaf
    let result: bool = proof.as_inclusion().unwrap().verify_hash(root, key, leaf);
    assert(result);
}
// ANCHOR_END: using_hash
