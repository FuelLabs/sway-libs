library merkle_proof;

use std::{
    hash::sha256,
    option::Option,
    revert::revert,
    vec::Vec,
};

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
pub fn verify_merkle_proof(merkle_leaf: b256, merkle_root: b256, proof: Vec<b256>) -> bool {
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

        if computed_hash <= proof_element {
            // Hash(current computed hash + current element of the proof)
            computed_hash = sha256((computed_hash, proof_element));
        } else {
            // Hash(current element of the proof + current computed hash)
            computed_hash = sha256((proof_element, computed_hash));
        }

        index = index + 1;
    }

    // Check if the computed hash is equal to the provided root
    computed_hash == merkle_root
}