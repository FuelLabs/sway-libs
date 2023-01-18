library binary_merkle_proof;

use std::{bytes::Bytes, hash::sha256};

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
/// * 'data' - The hash of the leaf data.
pub fn leaf_digest(data: b256) -> b256 {
    let mut result_buffer: b256 = b256::min();

    // TODO: Update to use From<T> once https://github.com/FuelLabs/sway/issues/3810 is implemented
    let mut bytes_u8 = Bytes::with_capacity(1);
    let mut b256_as_bytes = Bytes::with_capacity(32);
    bytes_u8.push(LEAF);
    b256_as_bytes.len = 32;
    __addr_of(data).copy_bytes_to(b256_as_bytes.buf.ptr, 32);

    let bytes = bytes_u8.join(b256_as_bytes);

        // TODO: Update to use bytes.sha256() when https://github.com/FuelLabs/sway/issues/3809 is implemented
    asm(hash: result_buffer, ptr: bytes.buf.ptr, bytes: bytes.len) {
        s256 hash ptr bytes;
        hash: b256
    }
}

/// Returns the computed node hash of "MTH(D[n]) = SHA-256(0x01 || MTH(D[0:k]) || MTH(D[k:n]))".
///
/// # Arguments
///
/// * 'left' - The hash of the left node.
/// * 'right' - The hash of the right node.
pub fn node_digest(left: b256, right: b256) -> b256 {
    let mut result_buffer: b256 = b256::min();

    // TODO: Update to use From<T> once https://github.com/FuelLabs/sway/issues/3810 is implemented
    let mut bytes_u8 = Bytes::with_capacity(1);
    let mut left_as_bytes = Bytes::with_capacity(32);
    let mut right_as_bytes = Bytes::with_capacity(32);
    bytes_u8.push(NODE);
    left_as_bytes.len = 32;
    right_as_bytes.len = 32;
    __addr_of(left).copy_bytes_to(left_as_bytes.buf.ptr, 32);
    __addr_of(right).copy_bytes_to(right_as_bytes.buf.ptr, 32);

    let left_right_as_bytes = left_as_bytes.join(right_as_bytes);
    let bytes = bytes_u8.join(left_right_as_bytes);

        // TODO: Update to use bytes.sha256() when https://github.com/FuelLabs/sway/issues/3809 is implemented
    asm(hash: result_buffer, ptr: bytes.buf.ptr, bytes: bytes.len) {
        s256 hash ptr bytes;
        hash: b256
    }
}

/// Calculates the length of the path to a leaf
///
/// # Arguments
///
/// * `key` - The key or index of the leaf.
/// * `num_leaves` - The total number of leaves in the Merkle Tree.
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
/// * 'key' - The key or index of the leaf to prove.
/// * `merkle_leaf` - The hash of a leaf on the Merkle Tree.
/// * 'num_leaves' - The number of leaves in the Merkle Tree.
/// * `proof` - The Merkle proof that will be used to traverse the Merkle Tree and compute a root.
///
/// # Reverts
///
/// * When an incorrect proof length is provided.
/// * When there is one or no leaves and a proof is provided.
/// * When the key is greater than or equal to the number of leaves.
/// * When the computed height gets larger than the proof.
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
/// * `num_leaves` - The number of leaves in the Merkle Tree.
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
/// * 'key' - The key or index of the leaf to verify.
/// * `merkle_leaf` - The hash of a leaf on the Merkle Tree.
/// * `merkle_root` - The pre-computed Merkle root that will be used to verify the leaf and proof.
/// * 'num_leaves' - The number of leaves in the Merkle Tree.
/// * `proof` - The Merkle proof that will be used to traverse the Merkle Tree and compute a root.
pub fn verify_proof(
    key: u64,
    merkle_leaf: b256,
    merkle_root: b256,
    num_leaves: u64,
    proof: Vec<b256>,
) -> bool {
    merkle_root == process_proof(key, merkle_leaf, num_leaves, proof)
}
