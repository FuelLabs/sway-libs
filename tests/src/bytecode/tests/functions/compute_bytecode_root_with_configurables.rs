use crate::bytecode::tests::utils::{
    abi_calls::compute_bytecode_root_with_configurables,
    test_helpers::{
        build_complex_configurables, build_simple_configurables, complex_contract_bytecode,
        complex_contract_bytecode_root_with_configurables_from_file, complex_defaults, defaults,
        predicate_bytecode, simple_contract_bytecode,
        simple_contract_bytecode_root_with_configurables_from_file,
        simple_predicate_bytecode_root_with_configurables_from_file, test_contract_instance,
    },
};

mod success {

    use super::*;

    #[tokio::test]
    async fn compute_bytecode_root_with_configurables_of_simple_contract() {
        let (test_contract_instance, _wallet) = test_contract_instance().await;
        let (contract_offset, _predicate_offset, config_value) = defaults();

        // Get the bytecode for the contract
        let file_bytecode = simple_contract_bytecode();

        // Build the configurable changes
        let my_configurables = build_simple_configurables(contract_offset, config_value);

        // Get the bytecode root from the file
        let file_bytecode_root =
            simple_contract_bytecode_root_with_configurables_from_file(config_value as u64).await;

        // Call the contract and compute the bytecode root
        let result_bytecode_root = compute_bytecode_root_with_configurables(
            &test_contract_instance,
            file_bytecode,
            my_configurables,
        )
        .await;

        assert_eq!(result_bytecode_root, file_bytecode_root);
    }

    #[tokio::test]
    async fn compute_bytecode_root_with_configurables_of_complex_contract() {
        let (test_contract_instance, _wallet) = test_contract_instance().await;
        let (_contract_offset, _predicate_offset, config_value) = defaults();
        let (config_struct, config_enum) = complex_defaults();

        // Get the bytecode for the contract
        let file_bytecode = complex_contract_bytecode();

        // Build the configurable changes
        let my_configurables =
            build_complex_configurables(config_value, config_struct.clone(), config_enum.clone());

        // Get the bytecode root from the file
        let file_bytecode_root = complex_contract_bytecode_root_with_configurables_from_file(
            config_value as u64,
            config_struct,
            config_enum,
        )
        .await;

        // Call the contract and compute the bytecode root
        let result_bytecode_root = compute_bytecode_root_with_configurables(
            &test_contract_instance,
            file_bytecode,
            my_configurables,
        )
        .await;

        assert_eq!(result_bytecode_root, file_bytecode_root);
    }

    #[tokio::test]
    async fn compute_bytecode_root_with_configurables_of_predicate() {
        let (test_contract_instance, wallet) = test_contract_instance().await;
        let (_contract_offset, predicate_offset, config_value) = defaults();

        // Get the bytecode for the predicate
        let file_bytecode = predicate_bytecode();

        // Build the configurable changes
        let my_configurables = build_simple_configurables(predicate_offset, config_value);

        // Call the contract and compute the bytecode root
        let result_bytecode_root = compute_bytecode_root_with_configurables(
            &test_contract_instance,
            file_bytecode,
            my_configurables,
        )
        .await;

        // Get the bytecode root of the predicate from the file.
        let predicate_bytecode_root = simple_predicate_bytecode_root_with_configurables_from_file(
            wallet.clone(),
            config_value as u64,
        )
        .await;

        // Assert that the roots are the same.
        assert_eq!(result_bytecode_root, predicate_bytecode_root);
    }
}

mod revert {

    use super::*;

    #[tokio::test]
    #[should_panic]
    async fn when_bytecode_is_empty() {
        let (test_contract_instance, _wallet) = test_contract_instance().await;

        let empty_bytecode: Vec<u8> = Vec::new();
        let my_configurables: Vec<(u64, Vec<u8>)> = Vec::new();

        // Call the contract and compute the bytecode root
        let result_bytecode_root = compute_bytecode_root_with_configurables(
            &test_contract_instance,
            empty_bytecode,
            my_configurables,
        )
        .await;
    }
}
