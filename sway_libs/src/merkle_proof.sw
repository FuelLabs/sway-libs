library merkle_proof;

use std::{
    hash::sha256,
    option::Option,
    revert::revert,
    vec::Vec,
};

fn hash_pair(a: b256, b: b256) -> b256 {
    if a <= b {
        // Hash(a + b)
        sha256((a, b))
    } else {
        // Hash(b + a)
        sha256((b, a))
    }
}

/// This function will verify the merkle leaf and proof given against the root.
///
/// # Arguments
///
/// * `merkle_leaf` - The hash of a leaf on the merkle tree.
/// * `merkle_root` - The pre-computed merkle root that will be used to verify the lead and proof.
/// * `proof` - The merkle proof that will be used to traverse the merkle tree and compute a root.
///
/// # Reverts
///
/// * When an element in the provided `proof` is `None`.
pub fn verify_proof(merkle_leaf: b256, merkle_root: b256, proof: Vec<b256>) -> bool {
    let mut computed_hash = merkle_leaf;
    let mut index = 0;
    let proof_length = proof.len();

    // Itterate over proof
    while index < proof_length {
        // Get the current element in the proof
        let proof_element: Option<b256> = proof.get(index);
        let proof_element = match proof_element {
            Option::Some(b256) => proof_element.unwrap(), Option::None(b256) => revert(0), 
        };

        computed_hash = hash_pair(computed_hash, proof_element);

        index = index + 1;
    }

    // Check if the computed hash is equal to the provided root
    computed_hash == merkle_root
}

pub fn verify_multi_proof(merkle_leaves: Vec<b256>, merkle_root: b256, proof: Vec<b256>, proof_flags: Vec<bool>) -> bool {
    let mut hashes = ~Vec::new();
    let mut itterator = 0;
    let mut leaf_pos = 0;
    let mut hash_pos = 0;
    let mut proof_pos = 0;

    while itterator < proof_flags.len() {
        let a = if leaf_pos < merkle_leaves.len() {
                leaf_pos = leaf_pos + 1;
                merkle_leaves.get(leaf_pos - 1).unwrap()
            } else {
                hash_pos = hash_pos + 1;
                hashes.get(hash_pos - 1).unwrap()
        };

        let b = if proof_flags.get(itterator).unwrap() {
                if  leaf_pos < merkle_leaves.len() {
                    leaf_pos = leaf_pos + 1;
                    merkle_leaves.get(leaf_pos - 1).unwrap()
                } else {
                    hash_pos = hash_pos + 1;
                    hashes.get(hash_pos - 1).unwrap()
                }
            } else {
                proof_pos = proof_pos + 1;
                proof.get(proof_pos - 1).unwrap()
        };

        hashes.push(hash_pair(a, b));

        itterator = itterator + 1;
    }

    if proof_flags.len() > 0 {
        hashes.get(proof_flags.len() - 1).unwrap() == merkle_root
    } else if merkle_leaves.len() > 0 {
        merkle_leaves.get(0).unwrap() == merkle_root
    } else {
        proof.get(0).unwrap() == merkle_root
    }
}
