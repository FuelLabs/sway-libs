contract;

use sway_libs::merkle_proof::{
    leaf_digest,
    node_digest, 
    process_proof, 
    verify_proof, 
};

abi MerkleProofTest {
    fn leaf_digest(data: b256) -> b256;
    fn node_digest(left: b256, right: b256) -> b256;
    fn process_proof(key: u64, merkle_leaf: b256, num_leaves: u64, proof: [b256;
    2]) -> b256;
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

    fn process_proof(key: u64, merkle_leaf: b256, num_leaves: u64, proof: [b256;
    2]) -> b256 {
        process_proof(key, merkle_leaf, num_leaves, proof)
    }

    fn verify_proof(key: u64, merkle_leaf: b256, merkle_root: b256, num_leaves: u64, proof: [b256;
    2]) -> bool {
        verify_proof(key, merkle_leaf, merkle_root, num_leaves, proof)
    }
}
