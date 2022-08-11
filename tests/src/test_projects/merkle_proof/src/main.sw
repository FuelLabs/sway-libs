contract;

use sway_libs::merkle_proof::{verify_proof, verify_multi_proof};

abi MerkleProofTest {
    fn verify_proof(merkle_leaf: b256, merkle_root: b256, proof: [b256; 2]) -> bool;
    fn verify_multi_proof(merkle_leaves: [b256; 2], merkle_root: b256, proof: b256, proof_flags: [bool; 2]) -> bool;
}

impl MerkleProofTest for Contract {
    fn verify_proof(merkle_leaf: b256, merkle_root: b256, proof: [b256; 2]) -> bool {
        verify_proof(merkle_leaf, merkle_root, proof)
    }

    fn verify_multi_proof(merkle_leaves: [b256; 2], merkle_root: b256, proof: b256, proof_flags: [bool; 2]) -> bool { 
        verify_multi_proof(merkle_leaves, merkle_root, proof, proof_flags) 
    }
}
