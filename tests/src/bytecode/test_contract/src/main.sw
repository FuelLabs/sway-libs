contract;

use bytecode::{
    compute_bytecode_root,
    compute_predicate_address,
    predicate_address_from_root,
    swap_configurables,
    verify_contract_bytecode,
    verify_predicate_address,
};

use std::alloc::alloc_bytes;

abi TestBytecodeSolver {
    fn predicate_address_from_root(bytecode_root: b256) -> Address;
    fn compute_predicate_address(
        bytecode: Vec<u8>,
        configurables: Option<Vec<(u64, Vec<u8>)>>,
    ) -> Address;
    fn compute_bytecode_root(
        bytecode: Vec<u8>,
        configurables: Option<Vec<(u64, Vec<u8>)>>,
    ) -> b256;
    fn swap_configurables(bytecode: Vec<u8>, configurables: Vec<(u64, Vec<u8>)>) -> Vec<u8>;
    fn verify_contract_bytecode(
        contract_id: ContractId,
        bytecode: Vec<u8>,
        configurables: Option<Vec<(u64, Vec<u8>)>>,
    );
    fn verify_predicate_address(
        predicate_id: Address,
        bytecode: Vec<u8>,
        configurables: Option<Vec<(u64, Vec<u8>)>>,
    );
}

impl TestBytecodeSolver for Contract {
    fn predicate_address_from_root(bytecode_root: b256) -> Address {
        predicate_address_from_root(bytecode_root)
    }

    fn compute_predicate_address(
        bytecode: Vec<u8>,
        configurables: Option<Vec<(u64, Vec<u8>)>>,
    ) -> Address {
        // Copy the bytecode to a newly allocated memory to avoid memory ownership error.
        let mut bytecode_slice = raw_slice::from_parts::<u8>(alloc_bytes(bytecode.len()), bytecode.len());
        bytecode
            .ptr()
            .copy_bytes_to(bytecode_slice.ptr(), bytecode.len());
        let mut bytecode_vec = Vec::from(bytecode_slice);
        compute_predicate_address(bytecode_vec, configurables)
    }

    fn compute_bytecode_root(
        bytecode: Vec<u8>,
        configurables: Option<Vec<(u64, Vec<u8>)>>,
    ) -> b256 {
        // Copy the bytecode to a newly allocated memory to avoid memory ownership error.
        let mut bytecode_slice = raw_slice::from_parts::<u8>(alloc_bytes(bytecode.len()), bytecode.len());
        bytecode
            .ptr()
            .copy_bytes_to(bytecode_slice.ptr(), bytecode.len());
        let mut bytecode_vec = Vec::from(bytecode_slice);
        compute_bytecode_root(bytecode_vec, configurables)
    }

    fn swap_configurables(bytecode: Vec<u8>, configurables: Vec<(u64, Vec<u8>)>) -> Vec<u8> {
        // Copy the bytecode to a newly allocated memory to avoid memory ownership error.
        let mut bytecode_slice = raw_slice::from_parts::<u8>(alloc_bytes(bytecode.len()), bytecode.len());
        bytecode
            .ptr()
            .copy_bytes_to(bytecode_slice.ptr(), bytecode.len());
        let mut bytecode_vec = Vec::from(bytecode_slice);
        swap_configurables(bytecode_vec, configurables)
    }

    fn verify_contract_bytecode(
        contract_id: ContractId,
        bytecode: Vec<u8>,
        configurables: Option<Vec<(u64, Vec<u8>)>>,
    ) {
        // Copy the bytecode to a newly allocated memory to avoid memory ownership error.
        let mut bytecode_slice = raw_slice::from_parts::<u8>(alloc_bytes(bytecode.len()), bytecode.len());
        bytecode
            .ptr()
            .copy_bytes_to(bytecode_slice.ptr(), bytecode.len());
        let mut bytecode_vec = Vec::from(bytecode_slice);
        verify_contract_bytecode(contract_id, bytecode_vec, configurables);
    }

    fn verify_predicate_address(
        predicate_id: Address,
        bytecode: Vec<u8>,
        configurables: Option<Vec<(u64, Vec<u8>)>>,
    ) {
        // Copy the bytecode to a newly allocated memory to avoid memory ownership error.
        let mut bytecode_slice = raw_slice::from_parts::<u8>(alloc_bytes(bytecode.len()), bytecode.len());
        bytecode
            .ptr()
            .copy_bytes_to(bytecode_slice.ptr(), bytecode.len());
        let mut bytecode_vec = Vec::from(bytecode_slice);
        verify_predicate_address(predicate_id, bytecode_vec, configurables);
    }
}
