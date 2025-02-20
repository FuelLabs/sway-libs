library;

use ::merkle::common::{node_digest, ProofError};

/// This function will compute and return the root of a Sparse Merkle Tree given a leaf, key, and corresponding proof.
///
/// # Arguments
///
/// * `key`: [b256] - The key or index of the leaf to prove.
/// * `leaf`: [b256] - The hash of a leaf on the Sparse Merkle Tree.
/// * `proof`: [Vec<b256>] - The Sparse Merkle proof that will be used to traverse the Sparse Merkle Tree and compute a root.
///
/// # Reverts
///
/// * When the proof is greater than 256 elements.
///
/// # Returns
///
/// * [b256] - The calculated root.
///
/// # Examples
///
/// ```sway
/// use sway_libs::merkle::sparse::process_proof;
///
/// fn foo() {
///     let key = b256::zero();
///     let leaf = b256::zero();
///     let mut proof = Vec::new();
///     proof.push(0xb51fc5c7f5b6393a5b13bb6068de2247ac09df1d3b1bec17627502cb1d1a6ac6);
///     let root = process_proof(key, leaf, proof);
///     assert(root == 0xed84ee783dcb8999206160218e4fe8a1dc5ccb056e3b98f0a6fa633ca5896a47);
/// }
/// ```
pub fn process_proof(key: b256, leaf: b256, proof: Vec<b256>) -> b256 {
    require(proof.len() <= 256, ProofError::InvalidProofLength);

    // In Fuel Merkle, we hash key and value here instead of just using the leaf
    let mut current_hash = leaf;
    let mut iter = 0;
    for sibling_hash in proof.iter() {
        let index = proof.len() - 1 - iter;
        current_hash = match bit_at_index(key, index) {
            false => node_digest(current_hash, sibling_hash),
            true => node_digest(sibling_hash, current_hash),
        };
        iter += 1;
    }

    current_hash
}

/// This function will take a Sparse Merkle leaf and proof and return whether the computed root matches the root given.
///
/// # Arguments
///
/// * `key`: [u64] - The key or index of the leaf to verify.
/// * `leaf`: [b256] - The hash of a leaf on the Sparse Merkle Tree.
/// * `proof`: [Vec<b256>] - The Sparse Merkle proof that will be used to traverse the Sparse Merkle Tree and compute a root.
/// * `root`: [b256] - The pre-computed Sparse Merkle root that will be used to verify the leaf and proof.
///
/// # Returns
///
/// * [bool] - `true` if the computed root matches the provided root, otherwise 'false'.
///
/// # Examples
///
/// ```sway
/// use sway_libs::merkle::sparse::verify_proof;
///
/// fn foo() {
///     let key = b256::zero();
///     let leaf = b256::zero();
///     let mut proof = Vec::new();
///     proof.push(0xb51fc5c7f5b6393a5b13bb6068de2247ac09df1d3b1bec17627502cb1d1a6ac6);
///     let root = 0xed84ee783dcb8999206160218e4fe8a1dc5ccb056e3b98f0a6fa633ca5896a47;
///
///     assert(verify_proof(key, leaf, proof, root) == true);
/// }
/// ```
pub fn verify_proof(key: b256, leaf: b256, proof: Vec<b256>, root: b256) -> bool {
    if proof.len() > 256 {
        return false;
    }

    root == process_proof(key, leaf, proof)
}

fn bit_at_index(key: b256, index: u64) -> bool {
    // The byte that contains the bit
    let byte_index = index / 8;
    // The bit within the containing byte
    let byte_bit_index = index % 8;
    let mask = (1 << (7 - byte_bit_index)).try_as_u8().unwrap();
    let byte = __addr_of(key).add::<u8>(byte_index).read_byte();
    byte & mask != 0u8
}
