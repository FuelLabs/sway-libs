library;

// TODO: Make this private when https://github.com/FuelLabs/sway/issues/5765 is resolved.
pub mod utils;

use std::external::bytecode_root;
use ::bytecode::utils::{_compute_bytecode_root, _predicate_address_from_root, _swap_configurables};

pub type BytecodeRoot = b256;
pub type ContractConfigurables = Vec<(u64, Vec<u8>)>;

/// Takes the bytecode of a contract or predicate and configurables and computes the bytecode root.
///
/// # Arguments
///
/// * `bytecode`: [Vec<u8>] - The bytecode of a contract or predicate.
/// * `configurables`: [Option<ContractConfigurables>] - `Some` configurable values to swap or `None`.
///
/// # Returns
///
/// * [b256] - The bytecode root of the contract or predicate.
///
/// # Reverts
///
/// * When the bytecode is empty.
///
/// # Examples
///
/// ```sway
/// use sway_libs::bytecode::{compute_bytecode_root, BytecodeRoot, ContractConfigurables};
///
/// fn foo(my_bytecode: Vec<u8>, my_configurables: Option<ContractConfigurables>) {
///     let mut my_bytecode = my_bytecode;
///     let bytecode_root: BytecodeRoot = compute_bytecode_root(my_bytecode, my_configurables);
///     assert(bytecode_root != b256::zero());
/// }
/// ```
pub fn compute_bytecode_root(
    ref mut bytecode: Vec<u8>,
    configurables: Option<ContractConfigurables>,
) -> BytecodeRoot {
    match configurables {
        Some(configurables) => {
            let mut bytecode_slice = bytecode.as_raw_slice();
            _swap_configurables(bytecode_slice, configurables);
            _compute_bytecode_root(bytecode_slice)
        },
        None => {
            _compute_bytecode_root(bytecode.as_raw_slice())
        }
    }
}

/// Takes the bytecode of a predicate and configurables and computes the address of a predicate.
///
/// # Arguments
///
/// * `bytecode`: [Vec<u8>] - The bytecode of a predicate.
/// * `configurables`: [Option<ContractConfigurables>] - The configurable values to swap.
///
/// # Returns
///
/// * [Address] - The address of the predicate.
///
/// # Reverts
///
/// * When the bytecode is empty.
///
/// # Examples
///
/// ```sway
/// use sway_libs::bytecode::{compute_predicate_address, ContractConfigurables};
///
/// fn foo(my_bytecode: Vec<u8>, my_configurables: Option<ContractConfigurables>) {
///     let mut my_bytecode = my_bytecode;
///     let predicate_address: Address = compute_predicate_address(my_bytecode, my_configurables);
///     assert(predicate_address != Address::zero());
/// }
/// ```
pub fn compute_predicate_address(
    ref mut bytecode: Vec<u8>,
    configurables: Option<ContractConfigurables>,
) -> Address {
    match configurables {
        Some(configurables) => {
            let mut bytecode_slice = bytecode.as_raw_slice();
            _swap_configurables(bytecode_slice, configurables);
            let bytecode_root = _compute_bytecode_root(bytecode_slice);
            _predicate_address_from_root(bytecode_root)
        },
        None => {
            let bytecode_root = _compute_bytecode_root(bytecode.as_raw_slice());
            _predicate_address_from_root(bytecode_root)
        }
    }
}

/// Takes the bytecode root of a predicate and generates the address of the predicate.
///
/// # Arguments
///
/// * `bytecode_root`: [BytecodeRoot] - The bytecode root of a predicate.
///
/// # Returns
///
/// * [Address] - The address of the predicate.
///
/// # Examples
///
/// ```sway
/// use sway_libs::bytecode::{predicate_address_from_root, BytecodeRoot};
///
/// fn foo(predicate_bytecode_root: BytecodeRoot) {
///     let predicate_address: Address = predicate_address_from_root(predicate_bytecode_root);
///     assert(predicate_address != Address::zero());
/// }
/// ```
pub fn predicate_address_from_root(bytecode_root: BytecodeRoot) -> Address {
    _predicate_address_from_root(bytecode_root)
}

/// Swaps out configurable values in a contract or predicate's bytecode.
///
/// # Arguments
///
/// * `bytecode`: [Vec<u8>] - The bytecode of a contract or predicate.
/// * `configurables`: [ContractConfigurables] - The configurable values to swap.
///
/// # Returns
///
/// * [Vec<u8>] - The resulting bytecode containing the new configurable values.
///
/// # Examples
///
/// ```sway
/// use sway_libs::bytecode::{sway_configurables, ContractConfigurables};
///
/// fn foo(my_bytecode: Vec<u8>, my_configurables: ContractConfigurables) {
///     let mut my_bytecode = my_bytecode;
///     let resulting_bytecode = swap_configurables(my_bytecode, my_configurables);
///     assert(resulting_bytecode != my_bytecode);
/// }
/// ```
pub fn swap_configurables(
    ref mut bytecode: Vec<u8>,
    configurables: ContractConfigurables,
) -> Vec<u8> {
    let mut bytecode_slice = bytecode.as_raw_slice();
    _swap_configurables(bytecode_slice, configurables);
    bytecode
}

/// Asserts that a contract's bytecode and the given bytecode and configurable values match.
///
/// # Arguments
///
/// * `contract_id`: [ContractId] - The contract that the bytecode should match.
/// * `bytecode`: [Vec<u8>] - The bytecode of the contract.
/// * `configurables`: [Option<ContractConfigurables>] - The configurable values to swap.
///
/// # Reverts
///
/// * When the bytecode is empty.
/// * When the contract's bytecode root does not match the passed bytecode.
///
/// # Examples
///
/// ```sway
/// use sway_libs::bytecode::{verify_contract_bytecode, ContractConfigurables};
///
/// fn foo(my_contract_id: ContractId, my_bytecode: Vec<u8>, my_configurables: Option<ContractConfigurables>) {
///     let mut my_bytecode = my_bytecode;
///     verify_contract_bytecode(my_contract_id, my_bytecode, my_configurables);
///     // This line will only be reached if the contract's bytecode root and the computed bytecode root match.
/// }
/// ```
pub fn verify_contract_bytecode(
    contract_id: ContractId,
    ref mut bytecode: Vec<u8>,
    configurables: Option<ContractConfigurables>,
) {
    match configurables {
        Some(configurables) => {
            let root = bytecode_root(contract_id);
            let mut bytecode_slice = bytecode.as_raw_slice();
            _swap_configurables(bytecode_slice, configurables);
            let computed_root = _compute_bytecode_root(bytecode_slice);

            assert(root == computed_root);
        },
        None => {
            let root = bytecode_root(contract_id);
            let computed_root = _compute_bytecode_root(bytecode.as_raw_slice());

            assert(root == computed_root);
        }
    }
}

/// Asserts that a predicates's address from some bytecode and configurables and the given address match.
///
/// # Arguments
///
/// * `predicate_id`: [Address] - The predicate address that the bytecode should match.
/// * `bytecode`: [Vec<u8>] - The bytecode of the predicate.
/// * `configurables`: [Option<ContractConfigurables>] - The configurable values to swap.
///
/// # Reverts
///
/// * When the bytecode is empty.
/// * When the predicate's address does not match the passed address.
///
/// # Examples
///
/// ```sway
/// use sway_libs::bytecode::verify_predicate_address;
///
/// fn foo(my_predicate_id: Address, my_bytecode: Vec<u8>, my_configurables: Option<ContractConfigurables>) {
///     let mut my_bytecode = my_bytecode;
///     verify_predicate_address(my_predicate_id, my_bytecode, my_configurables);
///     // This line will only be reached if the predicates's address and the computed address match.
/// }
/// ```
pub fn verify_predicate_address(
    predicate_id: Address,
    ref mut bytecode: Vec<u8>,
    configurables: Option<ContractConfigurables>,
) {
    match configurables {
        Some(configurables) => {
            let mut bytecode_slice = bytecode.as_raw_slice();
            _swap_configurables(bytecode_slice, configurables);
            let bytecode_root = _compute_bytecode_root(bytecode_slice);
            let generated_address = _predicate_address_from_root(bytecode_root);

            assert(generated_address == predicate_id);
        },
        None => {
            let bytecode_root = _compute_bytecode_root(bytecode.as_raw_slice());
            let generated_address = _predicate_address_from_root(bytecode_root);

            assert(generated_address == predicate_id);
        }
    }
}
