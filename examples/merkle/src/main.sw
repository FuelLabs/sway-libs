contract;

// ANCHOR: import
use sway_libs::merkle::binary_proof::*;
// ANCHOR_END: import

abi MerkleExample {
    fn verify(
        merkle_root: b256,
        key: u64,
        leaf: b256,
        num_leaves: u64,
        proof: Vec<b256>,
    ) -> bool;
}

impl MerkleExample for Contract {
    fn verify(
        merkle_root: b256,
        key: u64,
        leaf: b256,
        num_leaves: u64,
        proof: Vec<b256>,
    ) -> bool {
        verify_proof(key, leaf, merkle_root, num_leaves, proof)
    }
}

// ANCHOR: leaf_digest
fn compute_leaf(hashed_data: b256) {
    let leaf: b256 = leaf_digest(hashed_data);
}
// ANCHOR_END: leaf_digest

// ANCHOR: node_digest
fn compute_node(leaf_a: b256, leaf_b: b256) {
    let node: b256 = node_digest(leaf_a, leaf_b);
}
// ANCHOR_END: node_digest

// ANCHOR: process_proof
fn process(key: u64, leaf: b256, num_leaves: u64, proof: Vec<b256>) {
    let merkle_root: b256 = process_proof(key, leaf, num_leaves, proof);
}
// ANCHOR_END: process_proof

// ANCHOR: verify_proof
fn verify(
    merkle_root: b256,
    key: u64,
    leaf: b256,
    num_leaves: u64,
    proof: Vec<b256>,
) {
    assert(verify_proof(key, leaf, merkle_root, num_leaves, proof));
}
// ANCHOR_END: verify_proof
