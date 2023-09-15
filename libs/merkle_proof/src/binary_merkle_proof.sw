library;

use std::{bytes::Bytes, hash::{Hash, sha256}};

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
/// use sway_libs::binary_merkle_proof::leaf_digest;
/// use std::contants::ZERO_B256;
///
/// fn foo() {
///     let data = ZERO_B256;
///     let digest = leaf_digest(data);
///     assert(digest == 0x54f05a87f5b881780cdc40e3fddfebf72e3ba7e5f65405ab121c7f22d9849ab4);
/// }
/// ```
pub fn leaf_digest(data: b256) -> b256 {
    let mut bytes = Bytes::with_capacity(33);
    let new_ptr = bytes.buf.ptr().add_uint_offset(1);

    bytes.buf.ptr().write_byte(LEAF);
    __addr_of(data).copy_bytes_to(new_ptr, 32);
    bytes.len = 33;

    sha256(bytes)
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
/// use sway_libs::binary_merkle_proof::node_digest;
/// use std::contants::ZERO_B256;
///
/// fn foo() {
///     let leaf_1 = ZERO_B256;
///     let leaf_2 = ZERO_B256;
///     let digest = node_digest(leaf_1, leaf_2);
///     assert(digest == 0xee510d4daf24756c7b56b56b838212b193d9265c85c4a3b2c74f5a3189477c80);
/// }
/// ```
pub fn node_digest(left: b256, right: b256) -> b256 {
    let mut bytes = Bytes::with_capacity(65);
    let new_ptr_left = bytes.buf.ptr().add_uint_offset(1);
    let new_ptr_right = bytes.buf.ptr().add_uint_offset(33);

    bytes.buf.ptr().write_byte(NODE);
    __addr_of(left).copy_bytes_to(new_ptr_left, 32);
    __addr_of(right).copy_bytes_to(new_ptr_right, 32);
    bytes.len = 65;

    sha256(bytes)
}

/// Calculates the length of the path to a leaf
///
/// # Arguments
///
/// * `key`: [u64] - The key or index of the leaf.
/// * `num_leaves`: [u64] - The total number of leaves in the Merkle Tree.
///
/// # Returns
///
/// * [u64] - The length from the leaf to a root.
fn path_length_from_key(key: u64, num_leaves: u64) -> u64 {
    let mut total_length = 0;
    let mut num_leaves = num_leaves;
    let mut key = key;

    while true {
        // The height of the left subtree is equal to the offset of the starting bit of the path
        let path_length = starting_bit(num_leaves);
        // Determine the number of leaves in the left subtree
        let num_leaves_left_sub_tree = (1 << (path_length - 1));

        if key <= (num_leaves_left_sub_tree - 1) {
            // If the leaf is in the left subtreee, path length is full height of the left subtree
            total_length = total_length + path_length;
            break;
        } else if num_leaves_left_sub_tree == 1 {
            // If the left sub tree has only one leaf, path has one additional step
            total_length = total_length + 1;
            break;
        } else if (num_leaves - num_leaves_left_sub_tree) <= 1 {
            // If the right sub tree only has one leaf, path has one additonal step
            total_length = total_length + 1;
            break;
        } else {
            // Otherwise add 1 to height and loop
            total_length = total_length + 1;
            key = key - num_leaves_left_sub_tree;
            num_leaves = num_leaves - num_leaves_left_sub_tree;
        }
    }

    total_length
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
/// use sway_libs::binary_merkle_proof::process_proof;
/// use std::contants::ZERO_B256;
///
/// fn foo() {
///     let key = 0;
///     let leaf = ZERO_B256;
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
    require((num_leaves > 1 && proof_length == path_length_from_key(key, num_leaves)) || (num_leaves <= 1 && proof_length == 0), ProofError::InvalidProofLength);
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

/// Calculates the starting bit of the path to a leaf
///
/// # Arguments
///
/// * `num_leaves`: [u64] - The number of leaves in the Merkle Tree.
///
/// # Returns
///
/// * [u64] - The starting bit.
fn starting_bit(num_leaves: u64) -> u64 {
    let mut starting_bit = 0;

    while (1 << starting_bit) < num_leaves {
        starting_bit = starting_bit + 1;
    }

    starting_bit
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
/// use sway_libs::binary_merkle_proof::process_proof;
/// use std::contants::ZERO_B256;
///
/// fn foo() {
///     let key = 0;
///     let leaf = ZERO_B256;
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
