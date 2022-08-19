contract;

use sway_libs::merkle_proof::{
    leaf_digest,
    node_digest, 
    process_multi_proof, 
    process_proof, 
    verify_multi_proof, 
    verify_proof, 
};

abi MerkleProofTest {
    fn leaf_digest(data: b256) -> b256;
    fn node_digest(left: b256, right: b256) -> b256;
    fn process_multi_proof(merkle_leaves: [b256;
    2], proof: b256, proof_flags: [bool;
    2]) -> b256;
    fn process_proof(key: u64, merkle_leaf: b256, num_leaves: u64, proof: [b256;
    2]) -> b256;
    fn verify_multi_proof(merkle_leaves: [b256;
    2], merkle_root: b256, proof: b256, proof_flags: [bool;
    2]) -> bool;
    fn verify_proof(key: u64, merkle_leaf: b256, merkle_root: b256, num_leaves: u64, proof: [b256;
    2]) -> bool;
}

impl MerkleProofTest for Contract {
    fn leaf_digest(data: b256) -> b256 {
        leaf_digest(data)
    }
    
    fn node_digest(left: b256, right: b256) -> b256 {
        node_digest(left, right)
    }

    fn process_multi_proof(merkle_leaves: [b256;
    2], proof: b256, proof_flags: [bool;
    2]) -> b256 {
        process_multi_proof(merkle_leaves, proof, proof_flags)
    }

    fn process_proof(key: u64, merkle_leaf: b256, num_leaves: u64, proof: [b256;
    2]) -> b256 {
        process_proof(key, merkle_leaf, num_leaves, proof)
    }

    fn verify_multi_proof(merkle_leaves: [b256;
    2], merkle_root: b256, proof: b256, proof_flags: [bool;
    2]) -> bool {
        verify_multi_proof(merkle_leaves, merkle_root, proof, proof_flags)
    }

    fn verify_proof(key: u64, merkle_leaf: b256, merkle_root: b256, num_leaves: u64, proof: [b256;
    2]) -> bool {
        verify_proof(key, merkle_leaf, merkle_root, num_leaves, proof)
    }
}
