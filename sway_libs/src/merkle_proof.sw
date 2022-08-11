// TODO: Function definitions that use arrays should be updated to Vecs once
// https://github.com/FuelLabs/fuels-rs/issues/353 is resolved

library merkle_proof;

use std::{hash::sha256, option::Option, revert::{require, revert}, vec::Vec};

fn hash_pair(a: b256, b: b256) -> b256 {
    if a <= b {
        // Hash(a + b)
        sha256((a, b))
    } else {
        // Hash(b + a)
        sha256((b, a))
    }
}

pub enum ProofError {
    InvalidMultiproof: (),
}

/// This function will verify the merkle leaf and proof given against the root.
///
/// # Arguments
///
/// * `merkle_leaf` - The hash of a leaf on the merkle tree.
/// * `merkle_root` - The pre-computed merkle root that will be used to verify the leaf and proof.
/// * `proof` - The merkle proof that will be used to traverse the merkle tree and compute a root.
///
/// # Reverts
///
/// * When an element in the provided `proof` is `None`.
pub fn verify_proof(merkle_leaf: b256, merkle_root: b256, proof: [b256;
2]) -> bool {
    let mut computed_hash = merkle_leaf;
    let mut index = 0;
    // let proof_length = proof.len();
    let proof_length = 2;

    // Itterate over proof
    while index < proof_length {
        // Get the current element in the proof
        // let proof_element: Option<b256> = proof.get(index);
        let proof_element = Option::Some(proof[index]);
        let proof_element = match proof_element {
            Option::Some(b256) => proof_element.unwrap(), Option::None(b256) => revert(0), 
        };

        computed_hash = hash_pair(computed_hash, proof_element);
        index += 1;
    }

    // Check if the computed hash is equal to the provided root
    computed_hash == merkle_root
}

/// This function will verify the merkle leaf and proof given against the root.
///
/// # Arguments
///
/// * `merkle_leaves` - The hashes of relevant leaves for the merkle proof.
/// * `merkle_root` - The pre-computed merkle root that will be used to verify the leaves and proof.
/// * `proof` - The merkle proof that will be used to traverse the merkle tree and compute a root.
/// * 'proof_flags' - The flags used to determine which hashes to use in order to compute the merkle root.
///
/// # Reverts
///
/// * When an incorrect number of proof flags for the multi-proof is given.
pub fn verify_multi_proof(merkle_leaves: [b256;
2], merkle_root: b256, proof: b256, proof_flags: [bool;
2]) -> bool {
    // TODO: These should not be hard-coded. Only used as placeholders until
    // https://github.com/FuelLabs/fuels-rs/issues/353 is resolved
    let total_hashes = 2;
    let merkle_leaves_len = 2;
    let proof_len = 1;
    require(merkle_leaves_len + proof_len - 1 == total_hashes, ProofError::InvalidMultiproof);

    let mut hashes: Vec<b256> = ~Vec::new();
    let mut itterator = 0;
    let mut leaf_pos = 0;
    let mut hash_pos = 0;
    let mut proof_pos = 0;

    // For each step we find a suitable `a` and `b` to hash:
    // `a` - A leaf if we have remaining leaves to hash or a computed hash
    // `b` - Based on the provided proof flags:
    //      * True - A leaf if we have remaining leaves to hash or a computed hash
    //      * False - A provided proof
    while itterator < total_hashes {
        let a = if leaf_pos < merkle_leaves_len {
            leaf_pos += 1;
            merkle_leaves[leaf_pos - 1]
        } else {
            hash_pos += 1;
            hashes.get(hash_pos - 1).unwrap()
        };

        let b = if proof_flags[itterator] {
            if leaf_pos < merkle_leaves_len {
                leaf_pos += 1;
                merkle_leaves[leaf_pos - 1]
            } else {
                hash_pos += 1;
                hashes.get(hash_pos - 1).unwrap()
            }
        } else {
            proof_pos += 1;
            proof
        };

        hashes.push(hash_pair(a, b));
        itterator += 1;
    }

    // Compare results with merkle root
    if total_hashes > 0 {
        hashes.get(total_hashes - 1).unwrap() == merkle_root
    } else if merkle_leaves_len > 0 {
        merkle_leaves[0] == merkle_root
    } else {
        proof == merkle_root
    }
}
