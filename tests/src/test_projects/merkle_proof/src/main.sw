contract;

use sway_libs::merkle_proof::{process_multi_proof, process_proof, verify_multi_proof, verify_proof};

abi MerkleProofTest {
    fn process_multi_proof(merkle_leaves: [b256;
    2], proof: b256, proof_flags: [bool;
    2]) -> b256;
    fn process_proof(merkle_leaf: b256, proof: [b256;
    2]) -> b256;
    fn verify_multi_proof(merkle_leaves: [b256;
    2], merkle_root: b256, proof: b256, proof_flags: [bool;
    2]) -> bool;
    fn verify_proof(merkle_leaf: b256, merkle_root: b256, proof: [b256;
    2]) -> bool;
}

impl MerkleProofTest for Contract {
    fn process_multi_proof(merkle_leaves: [b256;
    2], proof: b256, proof_flags: [bool;
    2]) -> b256 {
        process_multi_proof(merkle_leaves, proof, proof_flags)
    }

    fn process_proof(merkle_leaf: b256, proof: [b256;
    2]) -> b256 {
        process_proof(merkle_leaf, proof)
    }

    fn verify_multi_proof(merkle_leaves: [b256;
    2], merkle_root: b256, proof: b256, proof_flags: [bool;
    2]) -> bool {
        verify_multi_proof(merkle_leaves, merkle_root, proof, proof_flags)
    }

    fn verify_proof(merkle_leaf: b256, merkle_root: b256, proof: [b256;
    2]) -> bool {
        verify_proof(merkle_leaf, merkle_root, proof)
    }
}
