// TODO: Function definitions that use arrays should be updated to Vecs once
// https://github.com/FuelLabs/fuels-rs/issues/353 is resolved

library merkle_proof;

use std::{hash::sha256, option::Option, revert::require, vec::Vec};

pub enum ProofError {
    InvalidKey: (),
    InvalidMultiProof: (),
    InvalidProofLength: (),
}

pub const LEAF = 0u8;
pub const NODE = 1u8;

pub fn leaf_digest(data: b256) -> b256 {    
    sha256((LEAF, data))
}

fn hash_pair(a: b256, b: b256) -> b256 {
    if a <= b {
        // Hash(a + b)
        sha256((a, b))
    } else {
        // Hash(b + a)
        sha256((b, a))
    }
}

pub fn node_digest(left: b256, right: b256) -> b256 {
    sha256((NODE, left, right))
}

/// This function will compute a merkle root using the multiple merkle leaves and proof given.
///
/// # Arguments
///
/// * `merkle_leaves` - The hashes of relevant leaves for the merkle proof.
/// * `proof` - The merkle proof that will be used to traverse the merkle tree and compute a root.
/// * 'proof_flags' - The flags used to determine which hashes to use in order to compute the merkle root.
///
/// # Reverts
///
/// * When an incorrect number of proof flags for the multi-proof is given.
pub fn process_multi_proof(merkle_leaves: [b256;
2], proof: b256, proof_flags: [bool;
2]) -> b256 {
    // TODO: These should not be hard-coded. They are only to be used as placeholders until
    // https://github.com/FuelLabs/fuels-rs/issues/353 is resolved
    let total_hashes = 2;
    let merkle_leaves_len = 2;
    let proof_len = 1;
    // let total_hashes = proof_flags.len();
    // let merkle_leaves_len = merkle_leaves.len();
    // let proof_len = proof.len();
    require(merkle_leaves_len + proof_len - 1 == total_hashes, ProofError::InvalidMultiProof);

    let mut hashes: Vec<b256> = ~Vec::new();
    let mut iterator = 0;
    let mut leaf_pos = 0;
    let mut hash_pos = 0;
    let mut proof_pos = 0;

    // For each step we find a suitable `a` and `b` to hash:
    // `a` - A leaf hash if there are unused leaves or a computed hash
    // `b` - Based on the provided proof flags:
    //      * True - A leaf hash if there are unused leaves or a computed hash
    //      * False - A provided proof hash
    while iterator < total_hashes {
        let a = if leaf_pos < merkle_leaves_len {
            leaf_pos += 1;
            merkle_leaves[leaf_pos - 1]
        } else {
            hash_pos += 1;
            hashes.get(hash_pos - 1).unwrap()
        };

        let b = if proof_flags[iterator] {
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
        iterator += 1;
    }

    if total_hashes > 0 {
        hashes.get(total_hashes - 1).unwrap()
    } else if merkle_leaves_len > 0 {
        merkle_leaves[0]
    } else {
        proof
    }
}

/// This function will compute a merkle root given a leaf and corresponding proof.
///
/// # Arguments
///
/// * 'key' - The key or index of the leaf to prove.
/// * `merkle_leaf` - The hash of a leaf on the merkle tree.
/// * 'num_leaves' - The number of leaves in the merkle tree.
/// * `proof` - The merkle proof that will be used to traverse the merkle tree and compute a root.
///
/// # Reverts
///
/// * When there is more than 1 leaf and no proof is provided.
/// * When there is one or no leaves and a proof is provided.
/// * When the key is greater than or equal to the number of leaves.
/// * When the computed height gets larger than the proof.
pub fn process_proof(key: u64, merkle_leaf: b256, num_leaves: u64, proof: [b256;
2]) -> b256 {
    // let proof_length = proof.len();
    let proof_length = 2;
    require((num_leaves > 1 && proof_length != 0) || (num_leaves <= 1 && proof_length == 0), ProofError::InvalidProofLength);
    require(key < num_leaves, ProofError::InvalidKey);

    let mut digest = leaf_digest(merkle_leaf);
    // If there is no proof then the leaf is the root
    if proof_length == 0 {
        return digest
    }

    let mut height = 1;
    let mut stable_end = key;

    // While the current subtree is complete, determine the position of the next
    // sibling using the complete subtree algorithm.
    while true {
        // Determine if the subtree is complete.
        let sub_tree_start_index = (key / (1 << height)) * (1 << height);
        let sub_tree_end_index = sub_tree_start_index + (1 << height) - 1;

        // If the Merkle tree does not have a leaf at the `sub_tree_end_index`, we deem that the
        // subtree is not complete.
        if sub_tree_end_index >= num_leaves {
            break;
        }
        stable_end = sub_tree_end_index;
        require(proof_length > height - 1, ProofError::InvalidProofLength);

        // Determine if the key is in the first or the second half of the subtree.
        if (key - sub_tree_start_index) < (1 << (height - 1)) {
            digest = node_digest(digest, proof[height - 1]);
        } else {
            digest = node_digest(proof[height - 1], digest);
        }

        height += 1;
    }

    // Determine if the next hash belongs to an orphan that was elevated.
    if stable_end != num_leaves - 1 {
        require(proof_length > height - 1, ProofError::InvalidProofLength);
        digest = node_digest(digest, proof[height - 1]);
        height += 1;
    }

    // All remaining elements in the proof set will belong to the left sibling.
    while height - 1 < proof_length {
        digest = node_digest(proof[height - 1], digest);
        height += 1;
    }

    digest
}

/// This function will take multiple merkle leaves, a proof, and proof flags and returns whether the
/// corresponding root matches the root given.
///
/// # Arguments
///
/// * `merkle_leaves` - The hashes of relevant leaves for the merkle proof.
/// * `merkle_root` - The pre-computed merkle root that will be used to verify the leaves and proof.
/// * `proof` - The merkle proof that will be used to traverse the merkle tree and compute a root.
/// * 'proof_flags' - The flags used to determine which hashes to use in order to compute the merkle root.
pub fn verify_multi_proof(merkle_leaves: [b256;
2], merkle_root: b256, proof: b256, proof_flags: [bool;
2]) -> bool {
    process_multi_proof(merkle_leaves, proof, proof_flags) == merkle_root
}

/// This function will take a merkle leaf and proof and return whether the corresponding root
/// matches the root given.
///
/// # Arguments
///
/// * 'key' - The key or index of the leaf to verify.
/// * `merkle_leaf` - The hash of a leaf on the merkle tree.
/// * `merkle_root` - The pre-computed merkle root that will be used to verify the leaf and proof.
/// * 'num_leaves' - The number of leaves in the merkle tree.
/// * `proof` - The merkle proof that will be used to traverse the merkle tree and compute a root.
pub fn verify_proof(key: u64, merkle_leaf: b256, merkle_root: b256, num_leaves: u64, proof: [b256;
2]) -> bool {
    process_proof(key, merkle_leaf, num_leaves, proof) == merkle_root
}
