library;

use std::{
    alloc::{alloc_bytes, realloc_bytes},
    bytes::Bytes,
    constants::ZERO_B256,
    external::bytecode_root,
    hash::{Hash, sha256, Hasher},
};

/// Pre-defined number of bytes of a leaf in a bytecode merkle tree.
const LEAF_SIZE = 16 * 1024;
/// Pre-defined number of bytes of a multiple in a leaf to pad to in a bytecode merkle tree.
const MULTIPLE = 8;
/// Prepended byte to leaves in a bytecode merkle tree.
const LEAF = 0u8;
/// Prepended byte to nodes in a bytecode merkle tree.
const NODE = 1u8;
/// Seed for the calculation of the predicate id from its code.
///
/// # Additional Information
///
/// https://github.com/FuelLabs/fuel-specs/blob/master/src/identifiers/contract-id.md
const SEED = [70u8, 85u8, 69u8, 76u8];

/// Takes the bytecode root of predicate generates the address of a predicate.
pub fn _generate_predicate_address(bytecode_root: b256) -> Address {
    // Prepend the seed to the bytecode root to compute the predicate address
    let mut seed = Bytes::with_capacity(4);
    seed.push(SEED[0]);
    seed.push(SEED[1]);
    seed.push(SEED[2]);
    seed.push(SEED[3]);

    let mut hasher = Hasher::new();
    hasher.write(seed);
    hasher.write(Bytes::from(bytecode_root));
    Address::from(hasher.sha256())
}

/// Takes some bytecode and computes the bytecode root.
pub fn _compute_bytecode_root(bytecode: Vec<u8>) -> b256 {
    let mut vec_digest: Vec<b256> = generate_leaves(bytecode);
    let mut size = (vec_digest.len() + 1) >> 1;
    let mut odd = vec_digest.len() & 1;

    while true {
        // Iterate over this level
        let mut iterator = 0;
        while iterator < size - odd {
            let j = iterator << 1;
            vec_digest.set(iterator, node_digest(vec_digest.get(j).unwrap(), vec_digest.get(j + 1).unwrap()));
            iterator += 1;
        }

        // Check if we have an odd or even amount of nodes at this level
        if odd == 1 {
            vec_digest.set(iterator, vec_digest.get(iterator << 1).unwrap());
        }

        // If we only have one node left then that is the root
        if size == 1 {
            break;
        }

        odd = (size & 1);
        size = (size + 1) >> 1;
    }

    vec_digest.get(0).unwrap()
}

/// Swaps out configurable values in a contract or predicate's bytecode.
pub fn _swap_configurables(bytecode: Vec<u8>, configurables: Vec<(u64, Vec<u8>)>) -> Vec<u8> {
    // Copy the bytecode to a newly allocated memory to avoid memory ownership error.
    let mut bytecode_slice = raw_slice::from_parts::<u8>(alloc_bytes(bytecode.len()), bytecode.len());
    bytecode.buf.ptr.copy_bytes_to(
        bytecode_slice.ptr(), 
        bytecode.len()
    );

    // Iterate over every configurable
    let mut configurable_iterator = 0;
    while configurable_iterator < configurables.len() {
        let (offset, data) = configurables.get(configurable_iterator).unwrap();
        
        // Overwrite the configurable data into the bytecode
        data.buf.ptr.copy_bytes_to(
            bytecode_slice.ptr().add::<u8>(offset), 
            data.len()
        );

        configurable_iterator += 1;
    }

    Vec::from(bytecode_slice)
}

/// Takes some bytes and creates a new leaf digest.
fn leaf_digest(data: raw_slice) -> b256 {
    let number_of_bytes = data.number_of_bytes();
    let mut bytes = Bytes::with_capacity(number_of_bytes + 1);

    // Prepend LEAF to the leaf bytes
    bytes.buf.ptr().write_byte(LEAF);
    data.ptr().copy_bytes_to(
        bytes.buf.ptr().add_uint_offset(1), 
        number_of_bytes
    );
    bytes.len = number_of_bytes + 1;

    // Compute the digest
    let mut result_buffer = b256::min();
    asm(
        hash: result_buffer,
        ptr: bytes.buf.ptr,
        bytes: bytes.len,
    ) {
        s256 hash ptr bytes;
        hash: b256
    }
}

/// Takes two nodes and creates a new node digest.
fn node_digest(left: b256, right: b256) -> b256 {
    let mut bytes = Bytes::with_capacity(65);
    let new_ptr_left = bytes.buf.ptr().add_uint_offset(1);
    let new_ptr_right = bytes.buf.ptr().add_uint_offset(33);

    // Prepend NODE and concat the 2 node bytes for the current node
    bytes.buf.ptr().write_byte(NODE);
    __addr_of(left).copy_bytes_to(new_ptr_left, 32);
    __addr_of(right).copy_bytes_to(new_ptr_right, 32);
    bytes.len = 65;

    // Compute the digest
    let mut result_buffer = b256::min();
    asm(
        hash: result_buffer,
        ptr: bytes.buf.ptr,
        bytes: bytes.len,
    ) {
        s256 hash ptr bytes;
        hash: b256
    }
}

/// Takes some bytecode and computes the resulting leaves for a merkle tree.
fn generate_leaves(bytecode: Vec<u8>) -> Vec<b256> {
    // Number of leaves is '(bytecode.len() / LEAF_SIZE)' if it's perfectly divisible by LEAF_SIZE.
    // Otherwise `(bytecode.len() / LEAF_SIZE) + 1` to account for padding.
    let num_leaves = match bytecode.len() % LEAF_SIZE {
        0 => bytecode.len() / LEAF_SIZE,
        _ => bytecode.len() / LEAF_SIZE + 1,
    };
    let mut leaves_digest: Vec<b256> = Vec::new();

    // Iterate over all the leaves
    let mut leaf_iterator = 0; 
    let mut bytes_remaining = bytecode.len();
    while leaf_iterator < num_leaves {
        let leaf_offset_ptr = bytecode.buf.ptr.add_uint_offset(leaf_iterator * LEAF_SIZE);

        // Group bytes into leaves of size LEAF_SIZE
        // If we have less than LEAF_SIZE, check if it's a multiple of MULTIPLE.
        // If it is, then simply add it as a leaf.
        // If it isn't, then pad with zeros to the nearest MULTIPLE.
        if bytes_remaining >= LEAF_SIZE {
            // Add leaf with size LEAF_SIZE
            let leaf_slice = raw_slice::from_parts::<u8>(leaf_offset_ptr, LEAF_SIZE);
            leaves_digest.push(leaf_digest(leaf_slice));
            bytes_remaining -= LEAF_SIZE;
        } else if bytes_remaining % MULTIPLE == 0 {
            // Leaf size is a multiple of MULTIPLE so no need to pad
            let leaf_slice = raw_slice::from_parts::<u8>(leaf_offset_ptr, bytes_remaining);
            leaves_digest.push(leaf_digest(leaf_slice));
        } else {
            // Pad to size of MULTIPLE and then add as a leaf
            let padding = MULTIPLE - (bytes_remaining % MULTIPLE);
            let leaf_offset_ptr = realloc_bytes(leaf_offset_ptr, bytes_remaining, bytes_remaining + padding);
            let leaf_slice = raw_slice::from_parts::<u8>(leaf_offset_ptr, bytes_remaining + padding);
            leaves_digest.push(leaf_digest(leaf_slice));
        }

        leaf_iterator += 1;
    }

    leaves_digest
}
