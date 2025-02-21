contract;

use sway_libs::merkle::common::node_digest;
use sway_libs::merkle::sparse::Proof;
use std::bytes::Bytes;

abi MerkleProofTest {
    fn binary_leaf_digest(data: b256) -> b256;
    fn node_digest(left: b256, right: b256) -> b256;
    fn binary_process_proof(
        key: u64,
        merkle_leaf: b256,
        num_leaves: u64,
        proof: Vec<b256>,
    ) -> b256;
    fn binary_verify_proof(
        key: u64,
        merkle_leaf: b256,
        merkle_root: b256,
        num_leaves: u64,
        proof: Vec<b256>,
    ) -> bool;
    fn sparse_process_proof(
        key: b256,
        merkle_leaf: Option<Bytes>,
        proof: Proof,
    ) -> b256;
    fn sparse_verify_proof(
        key: b256,
        merkle_leaf: Option<Bytes>,
        proof: Proof,
        merkle_root: b256,
    ) -> bool;
    fn sparse_leaf_digest(key: b256, data: b256) -> b256;
}

impl MerkleProofTest for Contract {
    fn binary_leaf_digest(data: b256) -> b256 {
        sway_libs::merkle::binary::leaf_digest(data)
    }

    fn node_digest(left: b256, right: b256) -> b256 {
        node_digest(left, right)
    }

    fn binary_process_proof(
        key: u64,
        merkle_leaf: b256,
        num_leaves: u64,
        proof: Vec<b256>,
    ) -> b256 {
        sway_libs::merkle::binary::process_proof(key, merkle_leaf, num_leaves, proof)
    }

    fn binary_verify_proof(
        key: u64,
        merkle_leaf: b256,
        merkle_root: b256,
        num_leaves: u64,
        proof: Vec<b256>,
    ) -> bool {
        sway_libs::merkle::binary::verify_proof(key, merkle_leaf, merkle_root, num_leaves, proof)
    }

    fn sparse_process_proof(
        key: b256,
        merkle_leaf: Option<Bytes>,
        proof: Proof,
    ) -> b256 {
        sway_libs::merkle::sparse::process_proof(key, merkle_leaf, proof)
    }

    fn sparse_verify_proof(
        key: b256,
        merkle_leaf: Option<Bytes>,
        proof: Proof,
        merkle_root: b256,
    ) -> bool {
        sway_libs::merkle::sparse::verify_proof(key, merkle_leaf, proof, merkle_root)
    }

    fn sparse_leaf_digest(key: b256, data: b256) -> b256 {
        sway_libs::merkle::sparse::leaf_digest(key, data)
    }
}
