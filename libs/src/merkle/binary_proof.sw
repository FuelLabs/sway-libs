library;

use std::{alloc::alloc_bytes, bytes::Bytes, hash::{Hash, sha256}};
use ::merkle::utils::{path_length_from_key, starting_bit};

pub enum ProofError {
    InvalidKey: (),
    InvalidProofLength: (),
}

/// Concatenated to leaf hash input as described by
/// "MTH({d(0)}) = SHA-256(0x00 || d(0))"
pub const LEAF = 0u8;
/// Concatenated to node hash input as described by
/// "MTH(D[n]) = SHA-256(0x01 || MTH(D[0:k]) || MTH(D[k:n]))"
pub const NODE = 1u8;

/// Returns the computed leaf hash of "MTH({d(0)}) = SHA-256(0x00 || d(0))".
///
/// # Arguments
///
/// * 'data': [b256] - The hash of the leaf data.
///
/// # Returns
///
/// * [b256] - The computed hash.
///
/// # Examples
///
/// ```sway
/// use sway_libs::merkle::binary_proof::leaf_digest;
///
/// fn foo() {
///     let data = b256::zero();
///     let digest = leaf_digest(data);
///     assert(digest == 0x54f05a87f5b881780cdc40e3fddfebf72e3ba7e5f65405ab121c7f22d9849ab4);
/// }
/// ```
pub fn leaf_digest(data: b256) -> b256 {
    let ptr = alloc_bytes(33);
    ptr.write_byte(LEAF);
    __addr_of(data).copy_bytes_to(ptr.add_uint_offset(1), 32);

    sha256(Bytes::from(raw_slice::from_parts::<u8>(ptr, 33)))
}

/// Returns the computed node hash of "MTH(D[n]) = SHA-256(0x01 || MTH(D[0:k]) || MTH(D[k:n]))".
///
/// # Arguments
///
/// * 'left': [b256] - The hash of the left node.
/// * 'right': [b256] - The hash of the right node.
///
/// # Returns
///
/// * [b256] - The hash of the node data.
///
/// # Examples
///
/// ```sway
/// use sway_libs::merkle::binary_proof::node_digest;
///
/// fn foo() {
///     let leaf_1 = b256::zero();
///     let leaf_2 = b256::zero();
///     let digest = node_digest(leaf_1, leaf_2);
///     assert(digest == 0xee510d4daf24756c7b56b56b838212b193d9265c85c4a3b2c74f5a3189477c80);
/// }
/// ```
pub fn node_digest(left: b256, right: b256) -> b256 {
    let ptr = alloc_bytes(65);
    ptr.write_byte(NODE);
    __addr_of(left).copy_bytes_to(ptr.add_uint_offset(1), 32);
    __addr_of(right).copy_bytes_to(ptr.add_uint_offset(33), 32);

    sha256(Bytes::from(raw_slice::from_parts::<u8>(ptr, 65)))
}

/// This function will compute and return a Merkle root given a leaf and corresponding proof.
///
/// # Arguments
///
/// * 'key': [u64] - The key or index of the leaf to prove.
/// * `merkle_leaf`: [b256] - The hash of a leaf on the Merkle Tree.
/// * 'num_leaves': [u64] - The number of leaves in the Merkle Tree.
/// * `proof`: [Vec<b256>] - The Merkle proof that will be used to traverse the Merkle Tree and compute a root.
///
/// # Returns
///
/// * [b256] - The calculated root.
///
/// # Reverts
///
/// * When an incorrect proof length is provided.
/// * When there is one or no leaves and a proof is provided.
/// * When the key is greater than or equal to the number of leaves.
/// * When the computed height gets larger than the proof.
///
/// # Examples
///
/// ```sway
/// use sway_libs::merkle::binary_proof::process_proof;
///
/// fn foo() {
///     let key = 0;
///     let leaf = b256::zero();
///     let num_leaves = 3;
///     let mut proof = Vec::new();
///     proof.push(0xb51fc5c7f5b6393a5b13bb6068de2247ac09df1d3b1bec17627502cb1d1a6ac6);
///     let root = process_proof(key, leaf, num_leaves, proof);
///     assert(root == 0xed84ee783dcb8999206160218e4fe8a1dc5ccb056e3b98f0a6fa633ca5896a47);
/// }
/// ```
pub fn process_proof(
    key: u64,
    merkle_leaf: b256,
    num_leaves: u64,
    proof: Vec<b256>,
) -> b256 {
    let proof_length = proof.len();
    require(
        (num_leaves > 1 && proof_length == path_length_from_key(key, num_leaves)) || (num_leaves <= 1 && proof_length == 0),
        ProofError::InvalidProofLength,
    );
    require(key < num_leaves, ProofError::InvalidKey);

    let mut digest = merkle_leaf;
    // If proof length is zero then the leaf is the root
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

        // If the Merkle Tree does not have a leaf at the `sub_tree_end_index`, we deem that the
        // subtree is not complete.
        if sub_tree_end_index >= num_leaves {
            break;
        }
        stable_end = sub_tree_end_index;
        require(proof_length > height - 1, ProofError::InvalidProofLength);

        // Determine if the key is in the first or the second half of the subtree.
        if (key - sub_tree_start_index) < (1 << (height - 1)) {
            digest = node_digest(digest, proof.get(height - 1).unwrap());
        } else {
            digest = node_digest(proof.get(height - 1).unwrap(), digest);
        }

        height = height + 1;
    }

    // Determine if the next hash belongs to an orphan that was elevated.
    if stable_end != (num_leaves - 1) {
        require(proof_length > height - 1, ProofError::InvalidProofLength);
        digest = node_digest(digest, proof.get(height - 1).unwrap());
        height = height + 1;
    }

    // All remaining elements in the proof set will belong to the left sibling.
    while (height - 1) < proof_length {
        digest = node_digest(proof.get(height - 1).unwrap(), digest);
        height = height + 1;
    }

    digest
}

/// This function will take a Merkle leaf and proof and return whether the corresponding root
/// matches the root given.
///
/// # Arguments
///
/// * 'key': [u64] - The key or index of the leaf to verify.
/// * `merkle_leaf`: [b256] - The hash of a leaf on the Merkle Tree.
/// * `merkle_root`: [b256] - The pre-computed Merkle root that will be used to verify the leaf and proof.
/// * 'num_leaves': [u64] - The number of leaves in the Merkle Tree.
/// * `proof`: [Vec<b256>] - The Merkle proof that will be used to traverse the Merkle Tree and compute a root.
///
/// # Returns
///
/// * [bool] - `true` if the computed root matches the provided root, otherwise 'false'.
///
/// # Reverts
///
/// * When an incorrect proof length is provided.
/// * When there is one or no leaves and a proof is provided.
/// * When the key is greater than or equal to the number of leaves.
/// * When the computed height gets larger than the proof.
///
/// # Examples
///
/// ```sway
/// use sway_libs::merkle::binary_proof::process_proof;
///
/// fn foo() {
///     let key = 0;
///     let leaf = b256::zero();
///     let num_leaves = 3;
///     let mut proof = Vec::new();
///     proof.push(0xb51fc5c7f5b6393a5b13bb6068de2247ac09df1d3b1bec17627502cb1d1a6ac6);
///     let root = 0xed84ee783dcb8999206160218e4fe8a1dc5ccb056e3b98f0a6fa633ca5896a47;
///
///     assert(verify_proof(key, leaf, root, num_leaves, proof) == true);
/// }
/// ```
pub fn verify_proof(
    key: u64,
    merkle_leaf: b256,
    merkle_root: b256,
    num_leaves: u64,
    proof: Vec<b256>,
) -> bool {
    merkle_root == process_proof(key, merkle_leaf, num_leaves, proof)
}
