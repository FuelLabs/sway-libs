library;

mod utils;

use std::external::bytecode_root;
use utils::{_compute_bytecode_root, _generate_predicate_address, _swap_configurables};

/// Takes the bytecode of a contract or predicate and computes the bytecode root.
///
/// # Arguments
///
/// * `bytecode`: [Vec<u8>] - The bytecode of a contract or predicate.
///
/// # Returns
///
/// * [b256] - The bytecode root of the contract or predicate.
///
/// # Examples
///
/// ```sway
/// use std::constants::ZERO_B256;
/// use bytecode::compute_bytecode_root;
///
/// fn foo(my_bytecode: Vec<u8>) {
///     let bytecode_root = compute_bytecode_root(my_bytecode);
///     assert(bytecode_root != ZERO_B256);
/// }
/// ```
pub fn compute_bytecode_root(bytecode: Vec<u8>) -> b256 {
    _compute_bytecode_root(bytecode.into())
}

/// Takes the bytecode of a contract or predicate and configurables and computes the bytecode root.
///
/// # Arguments
///
/// * `bytecode`: [Vec<u8>] - The bytecode of a contract or predicate.
/// * `configurables`: [Vec<(u64, Vec<u8>)] - The configurable values to swap.
///
/// # Returns
///
/// * [b256] - The bytecode root of the contract or predicate.
///
/// # Examples
///
/// ```sway
/// use std::constants::ZERO_B256;
/// use bytecode::compute_bytecode_root_with_configurables;
///
/// fn foo(my_bytecode: Vec<u8>, my_configurables: Vec<(u64, Vec<u8>)>) {
///     let mut my_bytecode = my_bytecode;
///     let bytecode_root = compute_bytecode_root_with_configurables(my_bytecode, my_configurables);
///     assert(bytecode_root != ZERO_B256);
/// }
/// ```
pub fn compute_bytecode_root_with_configurables(
    ref mut bytecode: Vec<u8>,
    configurables: Vec<(u64, Vec<u8>)>,
) -> b256 {
    let mut bytecode_slice = bytecode.into();
    _swap_configurables(bytecode_slice, configurables);
    _compute_bytecode_root(bytecode_slice)
}

/// Takes the bytecode of a predicate and computes the address of a predicate.
///
/// # Arguments
///
/// * `bytecode`: [Vec<u8>] - The bytecode of a predicate.
///
/// # Returns
///
/// * [Address] - The address of the predicate.
///
/// # Examples
///
/// ```sway
/// use std::constants::ZERO_B256;
/// use bytecode::compute_predicate_address;
///
/// fn foo(my_bytecode: Vec<u8>) {
///     let predicate_address = compute_predicate_address(my_bytecode);
///     assert(predicate_address != Address::from(ZERO_B256));
/// }
/// ```
pub fn compute_predicate_address(bytecode: Vec<u8>) -> Address {
    let bytecode_root = _compute_bytecode_root(bytecode.into());
    _generate_predicate_address(bytecode_root)
}

/// Takes the bytecode of a predicate and configurables and computes the address of a predicate.
///
/// # Arguments
///
/// * `bytecode`: [Vec<u8>] - The bytecode of a predicate.
/// * `configurables`: [Vec<(u64, Vec<u8>)] - The configurable values to swap.
///
/// # Returns
///
/// * [Address] - The address of the predicate.
///
/// # Examples
///
/// ```sway
/// use std::constants::ZERO_B256;
/// use bytecode::compute_predicate_address;
///
/// fn foo(my_bytecode: Vec<u8>, my_configurables: Vec<(u64, Vec<u8>)>) {
///     let mut my_bytecode = my_bytecode;
///     let predicate_address = compute_predicate_address(my_bytecode, my_configurables);
///     assert(predicate_address != Address::from(ZERO_B256));
/// }
/// ```
pub fn compute_predicate_address_with_configurables(
    ref mut bytecode: Vec<u8>,
    configurables: Vec<(u64, Vec<u8>)>,
) -> Address {
    let mut bytecode_slice = bytecode.into();
    _swap_configurables(bytecode_slice, configurables);
    let bytecode_root = _compute_bytecode_root(bytecode_slice);
    _generate_predicate_address(bytecode_root)
}

/// Takes the bytecode root of predicate generates the address of a predicate.
///
/// # Arguments
///
/// * `bytecode_root`: [b256] - The bytecode root of a predicate.
///
/// # Returns
///
/// * [Address] - The address of the predicate.
///
/// # Examples
///
/// ```sway
/// use std::constants::ZERO_B256;
/// use bytecode::generate_predicate_address;
///
/// fn foo(predicate_bytecode_root: b256) {
///     let predicate_address = generate_predicate_address(predicate_bytecode_root);
///     assert(predicate_address != Address::from(ZERO_B256));
/// }
/// ```
pub fn generate_predicate_address(bytecode_root: b256) -> Address {
    _generate_predicate_address(bytecode_root)
}

/// Swaps out configurable values in a contract or predicate's bytecode.
///
/// # Arguments
///
/// * `bytecode`: [Vec<u8>] - The bytecode of a contract or predicate.
/// * `configurables`: [Vec<(u64, Vec<u8>)] - The configurable values to swap.
///
/// # Returns
///
/// * [Vec<u8>] - The resulting bytecode containing the new configurable values.
///
/// # Examples
///
/// ```sway
/// use bytecode::sway_configurables;
///
/// fn foo(my_bytecode: Vec<u8>, my_configurables: Vec<(u64, Vec<u8>)>) {
///     let mut my_bytecode = my_bytecode;
///     let resulting_bytecode = swap_configurables(my_bytecode, my_configurables);
///     assert(resulting_bytecode != my_bytecode);
/// }
/// ```
pub fn swap_configurables(
    ref mut bytecode: Vec<u8>, 
    configurables: Vec<(u64, Vec<u8>)>
) -> Vec<u8> {
    let mut bytecode_slice = bytecode.into();
    _swap_configurables(bytecode_slice, configurables);
    bytecode
}

/// Asserts that a contract's bytecode and the given bytecode match.
///
/// # Arguments
///
/// * `contract_id`: [ContractId] - The contract that the bytecode should match.
/// * `bytecode`: [Vec<u8>] - The bytecode of the contract.
///
/// # Reverts
///
/// * When the contract's bytecode root does not match the passed bytecode.
///
/// # Examples
///
/// ```sway
/// use bytecode::verify_contract_bytecode;
///
/// fn foo(my_contract_id: ContractId, my_bytecode: Vec<u8>) {
///     verify_contract_bytecode(my_contract_id, my_bytecode);
///     // This line will only be reached if the contract's bytecode root and the computed bytecode root match.
/// }
/// ```
pub fn verify_contract_bytecode(contract_id: ContractId, bytecode: Vec<u8>) {
    let root = bytecode_root(contract_id);
    let computed_root = _compute_bytecode_root(bytecode.into());

    assert(root == computed_root);
}

/// Asserts that a contract's bytecode and the given bytecode and configurable values match.
///
/// # Arguments
///
/// * `contract_id`: [ContractId] - The contract that the bytecode should match.
/// * `bytecode`: [Vec<u8>] - The bytecode of the contract.
/// * `configurables`: [Vec<(u6, Vec<u8>)>] - The configurable values to swap.
///
/// # Reverts
///
/// * When the contract's bytecode root does not match the passed bytecode.
///
/// # Examples
///
/// ```sway
/// use bytecode::verify_contract_bytecode_with_configurables;
///
/// fn foo(my_contract_id: ContractId, my_bytecode: Vec<u8>, my_configurables: Vec<(u64, Vec<u8>)>) {
///     let mut my_bytecode = my_bytecode;
///     verify_contract_bytecode_with_configurables(my_contract_id, my_bytecode, my_configurables);
///     // This line will only be reached if the contract's bytecode root and the computed bytecode root match.
/// }
/// ```
pub fn verify_contract_bytecode_with_configurables(
    contract_id: ContractId,
    ref mut bytecode: Vec<u8>,
    configurables: Vec<(u64, Vec<u8>)>,
) {
    let root = bytecode_root(contract_id);
    let mut bytecode_slice = bytecode.into();
    _swap_configurables(bytecode_slice, configurables);
    let computed_root = _compute_bytecode_root(bytecode_slice);

    assert(root == computed_root);
}

/// Asserts that a predicates's address from some bytecode and the given address match.
///
/// # Arguments
///
/// * `predicate_id`: [Address] - The predicate address that the bytecode should match.
/// * `bytecode`: [Vec<u8>] - The bytecode of the predicate.
///
/// # Reverts
///
/// * When the predicate's address does not match the passed address.
///
/// # Examples
///
/// ```sway
/// use bytecode::verify_predicate_address;
///
/// fn foo(my_predicate_id: Address, my_bytecode: Vec<u8>) {
///     verify_predicate_address(my_predicate_id, my_bytecode);
///     // This line will only be reached if the predicates's address and the computed address match.
/// }
/// ```
pub fn verify_predicate_address(predicate_id: Address, bytecode: Vec<u8>) {
    let bytecode_root = _compute_bytecode_root(bytecode.into());
    let generated_address = _generate_predicate_address(bytecode_root);

    assert(generated_address == predicate_id);
}

/// Asserts that a predicates's address from some bytecode and configurables and the given address match.
///
/// # Arguments
///
/// * `predicate_id`: [Address] - The predicate address that the bytecode should match.
/// * `bytecode`: [Vec<u8>] - The bytecode of the predicate.
/// * `configurables`: [Vec<(u64, Vec<u8>)>] - The configurable values to swap.
///
/// # Reverts
///
/// * When the predicate's address does not match the passed address.
///
/// # Examples
///
/// ```sway
/// use bytecode::verify_predicate_address_with_configurables;
///
/// fn foo(my_predicate_id: Address, my_bytecode: Vec<u8>, my_configurables: Vec<(u64, Vec<u8>)>) {
///     let mut my_bytecode = my_bytecode;
///     verify_predicate_address_with_configurables(my_predicate_id, my_bytecode, my_configurables);
///     // This line will only be reached if the predicates's address and the computed address match.
/// }
/// ```
pub fn verify_predicate_address_with_configurables(
    predicate_id: Address,
    ref mut bytecode: Vec<u8>,
    configurables: Vec<(u64, Vec<u8>)>,
) {
    let mut bytecode_slice = bytecode.into();
    _swap_configurables(bytecode_slice, configurables);
    let bytecode_root = _compute_bytecode_root(bytecode_slice);
    let generated_address = _generate_predicate_address(bytecode_root);

    assert(generated_address == predicate_id);
}
