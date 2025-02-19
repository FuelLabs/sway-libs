library;

use ::merkle::common::{node_digest, ProofError};

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
/// use sway_libs::merkle::binary::process_proof;
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
/// use sway_libs::merkle::binary::verify_proof;
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
