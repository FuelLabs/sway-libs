contract;

use sway_libs::bytecode::{
    compute_bytecode_root,
    compute_bytecode_root_with_configurables,
    compute_predicate_address,
    compute_predicate_address_with_configurables,
    predicate_address_from_root,
    swap_configurables,
    verify_contract_bytecode,
    verify_contract_bytecode_with_configurables,
    verify_predicate_address,
    verify_predicate_address_with_configurables,
};

use std::alloc::alloc_bytes;

abi TestBytecodeSolver {
    fn predicate_address_from_root(bytecode_root: b256) -> Address;
    fn compute_predicate_address(bytecode: Vec<u8>) -> Address;
    fn compute_predicate_address_with_configurables(
        bytecode: Vec<u8>,
        configurables: Vec<(u64, Vec<u8>)>,
    ) -> Address;
    fn compute_bytecode_root(bytecode: Vec<u8>) -> b256;
    fn compute_bytecode_root_with_configurables(
        bytecode: Vec<u8>,
        configurables: Vec<(u64, Vec<u8>)>,
    ) -> b256;
    fn swap_configurables(bytecode: Vec<u8>, configurables: Vec<(u64, Vec<u8>)>) -> Vec<u8>;
    fn verify_contract_bytecode(contract_id: ContractId, bytecode: Vec<u8>);
    fn verify_contract_bytecode_with_configurables(
        contract_id: ContractId,
        bytecode: Vec<u8>,
        configurables: Vec<(u64, Vec<u8>)>,
    );
    fn verify_predicate_address(predicate_id: Address, bytecode: Vec<u8>);
    fn verify_predicate_address_with_configurables(
        predicate_id: Address,
        bytecode: Vec<u8>,
        configurables: Vec<(u64, Vec<u8>)>,
    );
}

impl TestBytecodeSolver for Contract {
    fn predicate_address_from_root(bytecode_root: b256) -> Address {
        predicate_address_from_root(bytecode_root)
    }
    fn compute_predicate_address(bytecode: Vec<u8>) -> Address {
        compute_predicate_address(bytecode)
    }

    fn compute_predicate_address_with_configurables(
        bytecode: Vec<u8>,
        configurables: Vec<(u64, Vec<u8>)>,
    ) -> Address {
        // Copy the bytecode to a newly allocated memory to avoid memory ownership error.
        let mut bytecode_slice = raw_slice::from_parts::<u8>(alloc_bytes(bytecode.len()), bytecode.len());
        bytecode
            .buf
            .ptr
            .copy_bytes_to(bytecode_slice.ptr(), bytecode.len());
        let mut bytecode_vec = Vec::from(bytecode_slice);
        compute_predicate_address_with_configurables(bytecode_vec, configurables)
    }

    fn compute_bytecode_root(bytecode: Vec<u8>) -> b256 {
        compute_bytecode_root(bytecode)
    }

    fn compute_bytecode_root_with_configurables(
        bytecode: Vec<u8>,
        configurables: Vec<(u64, Vec<u8>)>,
    ) -> b256 {
        // Copy the bytecode to a newly allocated memory to avoid memory ownership error.
        let mut bytecode_slice = raw_slice::from_parts::<u8>(alloc_bytes(bytecode.len()), bytecode.len());
        bytecode
            .buf
            .ptr
            .copy_bytes_to(bytecode_slice.ptr(), bytecode.len());
        let mut bytecode_vec = Vec::from(bytecode_slice);
        compute_bytecode_root_with_configurables(bytecode_vec, configurables)
    }

    fn swap_configurables(bytecode: Vec<u8>, configurables: Vec<(u64, Vec<u8>)>) -> Vec<u8> {
        // Copy the bytecode to a newly allocated memory to avoid memory ownership error.
        let mut bytecode_slice = raw_slice::from_parts::<u8>(alloc_bytes(bytecode.len()), bytecode.len());
        bytecode
            .buf
            .ptr
            .copy_bytes_to(bytecode_slice.ptr(), bytecode.len());
        let mut bytecode_vec = Vec::from(bytecode_slice);
        swap_configurables(bytecode_vec, configurables)
    }

    fn verify_contract_bytecode(contract_id: ContractId, bytecode: Vec<u8>) {
        verify_contract_bytecode(contract_id, bytecode);
    }

    fn verify_contract_bytecode_with_configurables(
        contract_id: ContractId,
        bytecode: Vec<u8>,
        configurables: Vec<(u64, Vec<u8>)>,
    ) {
        // Copy the bytecode to a newly allocated memory to avoid memory ownership error.
        let mut bytecode_slice = raw_slice::from_parts::<u8>(alloc_bytes(bytecode.len()), bytecode.len());
        bytecode
            .buf
            .ptr
            .copy_bytes_to(bytecode_slice.ptr(), bytecode.len());
        let mut bytecode_vec = Vec::from(bytecode_slice);
        verify_contract_bytecode_with_configurables(contract_id, bytecode_vec, configurables);
    }

    fn verify_predicate_address(predicate_id: Address, bytecode: Vec<u8>) {
        verify_predicate_address(predicate_id, bytecode);
    }

    fn verify_predicate_address_with_configurables(
        predicate_id: Address,
        bytecode: Vec<u8>,
        configurables: Vec<(u64, Vec<u8>)>,
    ) {
        // Copy the bytecode to a newly allocated memory to avoid memory ownership error.
        let mut bytecode_slice = raw_slice::from_parts::<u8>(alloc_bytes(bytecode.len()), bytecode.len());
        bytecode
            .buf
            .ptr
            .copy_bytes_to(bytecode_slice.ptr(), bytecode.len());
        let mut bytecode_vec = Vec::from(bytecode_slice);
        verify_predicate_address_with_configurables(predicate_id, bytecode_vec, configurables);
    }
}
