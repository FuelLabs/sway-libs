library;

use std::{alloc::alloc_bytes, bytes::Bytes, hash::{Hash, sha256}};

pub enum ProofError {
    InvalidKey: (),
    InvalidProofLength: (),
}

pub type ProofSet = Vec<b256>;
pub type MerkleRoot = b256;

/// Concatenated to leaf hash input as described by
/// "MTH({d(0)}) = SHA-256(0x00 || d(0))"
pub const LEAF = 0u8;
/// Concatenated to node hash input as described by
/// "MTH(D[n]) = SHA-256(0x01 || MTH(D[0:k]) || MTH(D[k:n]))"
pub const NODE = 1u8;

/// Returns the computed node hash of "MTH(D[n]) = SHA-256(0x01 || MTH(D[0:k]) || MTH(D[k:n]))".
///
/// # Arguments
///
/// * `left`: [b256] - The hash of the left node.
/// * `right`: [b256] - The hash of the right node.
///
/// # Returns
///
/// * [b256] - The hash of the node data.
///
/// # Examples
///
/// ```sway
/// use sway_libs::merkle::common::node_digest;
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
