library;

use std::alloc::alloc_bytes;

// ANCHOR: import
use sway_libs::bytecode::*;
// ANCHOR_END: import

// ANCHOR: known_issue
fn make_mutable(not_mutable_bytecode: Vec<u8>) {
    // Copy the bytecode to a newly allocated memory to avoid memory ownership error.
    let mut bytecode_slice = raw_slice::from_parts::<u8>(
        alloc_bytes(not_mutable_bytecode.len()),
        not_mutable_bytecode
            .len(),
    );
    not_mutable_bytecode
        .ptr()
        .copy_bytes_to(bytecode_slice.ptr(), not_mutable_bytecode.len());
    let mut bytecode_vec = Vec::from(bytecode_slice);
    // You may now use `bytecode_vec` in your computation and verification function calls
}
// ANCHOR_END: known_issue

// ANCHOR: swap_configurables
fn swap(my_bytecode: Vec<u8>, my_configurables: Vec<(u64, Vec<u8>)>) {
    let mut my_bytecode = my_bytecode;
    let resulting_bytecode: Vec<u8> = swap_configurables(my_bytecode, my_configurables);
}
// ANCHOR_END: swap_configurables

// ANCHOR: compute_bytecode_root
fn compute_bytecode(my_bytecode: Vec<u8>) {
    let root: b256 = compute_bytecode_root(my_bytecode);
}

fn compute_bytecode_configurables(my_bytecode: Vec<u8>, my_configurables: Vec<(u64, Vec<u8>)>) {
    let mut my_bytecode = my_bytecode;
    let root: b256 = compute_bytecode_root_with_configurables(my_bytecode, my_configurables);
}
// ANCHOR_END: compute_bytecode_root

// ANCHOR: verify_contract_bytecode
fn verify_contract(my_contract: ContractId, my_bytecode: Vec<u8>) {
    verify_contract_bytecode(my_contract, my_bytecode);
    // By reaching this line the contract has been verified to match the bytecode provided.
}

fn verify_contract_configurables(
    my_contract: ContractId,
    my_bytecode: Vec<u8>,
    my_configurables: Vec<(u64, Vec<u8>)>,
) {
    let mut my_bytecode = my_bytecode;
    verify_contract_bytecode_with_configurables(my_contract, my_bytecode, my_configurables);
    // By reaching this line the contract has been verified to match the bytecode provided.
}
// ANCHOR_END: verify_contract_bytecode

// ANCHOR: compute_predicate_address
fn compute_predicate(my_bytecode: Vec<u8>) {
    let address: Address = compute_predicate_address(my_bytecode);
}

fn compute_predicate_configurables(my_bytecode: Vec<u8>, my_configurables: Vec<(u64, Vec<u8>)>) {
    let mut my_bytecode = my_bytecode;
    let address: Address = compute_predicate_address_with_configurables(my_bytecode, my_configurables);
}
// ANCHOR_END: compute_predicate_address

// ANCHOR: predicate_address_from_root
fn predicate_address(my_root: b256) {
    let address: Address = predicate_address_from_root(my_root);
}
// ANCHOR_END: predicate_address_from_root

// ANCHOR: verify_predicate_address
fn verify_predicate(my_predicate: Address, my_bytecode: Vec<u8>) {
    verify_predicate_address(my_predicate, my_bytecode);
    // By reaching this line the predicate bytecode matches the address provided.
}

fn verify_predicate_configurables(
    my_predicate: Address,
    my_bytecode: Vec<u8>,
    my_configurables: Vec<(u64, Vec<u8>)>,
) {
    let mut my_bytecode = my_bytecode;
    verify_predicate_address_with_configurables(my_predicate, my_bytecode, my_configurables);
    // By reaching this line the predicate bytecode matches the address provided.
}
// ANCHOR_END: verify_predicate_address
