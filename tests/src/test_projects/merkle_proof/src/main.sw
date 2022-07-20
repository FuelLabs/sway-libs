contract;

use sway_libs::merkle_proof::verify_merkle_proof;
use std::{
    vec::Vec,
};

abi MerkleProofTest {
    fn verify_merkle_proof(merkle_leaf: b256, merkle_root: b256, proof: Vec<b256>) -> bool;
}

impl MerkleProofTest for Contract {
    fn verify_merkle_proof(merkle_leaf: b256, merkle_root: b256, proof: Vec<b256>) -> bool {
        verify_merkle_proof(merkle_leaf, merkle_root, proof)
    }
}
