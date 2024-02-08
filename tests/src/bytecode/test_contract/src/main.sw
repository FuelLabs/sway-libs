contract;

use bytecode::{compute_bytecode_root, compute_bytecode_root_with_configurables, compute_predicate_address, compute_predicate_address_with_configurables, generate_predicate_address, swap_configurables, verify_contract_bytecode, verify_contract_bytecode_with_configurables, verify_predicate_address, verify_predicate_address_with_configurables};

abi TestBytecodeSolver {
    fn generate_predicate_address(bytecode_root: b256) -> Address;
    fn compute_predicate_address(bytecode: Vec<u8>) -> Address;
    fn compute_predicate_address_with_configurables(bytecode: Vec<u8>, configurables: Vec<(u64, Vec<u8>)>) -> Address;
    fn compute_bytecode_root(bytecode: Vec<u8>) -> b256;
    fn compute_bytecode_root_with_configurables(bytecode: Vec<u8>, configurables: Vec<(u64, Vec<u8>)>) -> b256;
    fn swap_configurables(bytecode: Vec<u8>, configurables: Vec<(u64, Vec<u8>)>) -> Vec<u8>;
    fn verify_contract_bytecode(contract_id: ContractId, bytecode: Vec<u8>);
    fn verify_contract_bytecode_with_configurables(contract_id: ContractId, bytecode: Vec<u8>, configurables: Vec<(u64, Vec<u8>)>);
    fn verify_predicate_address(predicate_id: Address, bytecode: Vec<u8>);
    fn verify_predicate_address_with_configurables(predicate_id: Address, bytecode: Vec<u8>, configurables: Vec<(u64, Vec<u8>)>);
}

impl TestBytecodeSolver for Contract {
    fn generate_predicate_address(bytecode_root: b256) -> Address {
        generate_predicate_address(bytecode_root)
    }
    fn compute_predicate_address(bytecode: Vec<u8>) -> Address {
        compute_predicate_address(bytecode)
    }

    fn compute_predicate_address_with_configurables(bytecode: Vec<u8>, configurables: Vec<(u64, Vec<u8>)>) -> Address {
        compute_predicate_address_with_configurables(bytecode, configurables)
    }

    fn compute_bytecode_root(bytecode: Vec<u8>) -> b256 {
        compute_bytecode_root(bytecode)
    }

    fn compute_bytecode_root_with_configurables(bytecode: Vec<u8>, configurables: Vec<(u64, Vec<u8>)>) -> b256 {
        compute_bytecode_root_with_configurables(bytecode, configurables)
    }

    fn swap_configurables(bytecode: Vec<u8>, configurables: Vec<(u64, Vec<u8>)>) -> Vec<u8> {
        swap_configurables(bytecode, configurables)
    }

    fn verify_contract_bytecode(contract_id: ContractId, bytecode: Vec<u8>) {
        verify_contract_bytecode(contract_id, bytecode);
    }

    fn verify_contract_bytecode_with_configurables(contract_id: ContractId, bytecode: Vec<u8>, configurables: Vec<(u64, Vec<u8>)>) {
        verify_contract_bytecode_with_configurables(contract_id, bytecode, configurables);
    }

    fn verify_predicate_address(predicate_id: Address, bytecode: Vec<u8>) {
        verify_predicate_address(predicate_id, bytecode);
    }

    fn verify_predicate_address_with_configurables(predicate_id: Address, bytecode: Vec<u8>, configurables: Vec<(u64, Vec<u8>)>) {
        verify_predicate_address_with_configurables(predicate_id, bytecode, configurables);
    }
}
