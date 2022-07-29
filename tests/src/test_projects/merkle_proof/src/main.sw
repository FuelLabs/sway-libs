contract;

use sway_libs::merkle_proof::verify_merkle_proof;
use std::{
    vec::Vec,
};

abi MerkleProofTest {
    fn verify_merkle_proof(merkle_leaf: b256, merkle_root: b256, proof: Vec<b256>) -> bool;
    fn verify_multi_proof(merkle_leaves: Vec<b256>, merkle_root: b256, proof: Vec<b256>, proof_flags: Vec<bool>) -> bool;
}

impl MerkleProofTest for Contract {
    fn verify_proof(merkle_leaf: b256, merkle_root: b256, proof: Vec<b256>) -> bool {
        verify_proof(merkle_leaf, merkle_root, proof)
    }

    fn verify_multi_proof(merkle_leaves: Vec<b256>, merkle_root: b256, proof: Vec<b256>, proof_flags: Vec<bool>) -> bool { 
        verify_multi_proof(merkle_leaves, merkle_root, proof, proof_flags) 
    }
}
