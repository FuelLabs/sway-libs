use crate::bytecode::tests::utils::{
    abi_calls::{verify_complex_contract_bytecode, verify_simple_contract_bytecode},
    test_helpers::{
        build_complex_configurables, build_simple_configurables, complex_contract_bytecode,
        complex_defaults, defaults, deploy_complex_contract_from_file,
        deploy_complex_contract_with_configurables_from_file, deploy_simple_contract_from_file,
        deploy_simple_contract_with_configurables_from_file, predicate_bytecode,
        simple_contract_bytecode, test_contract_instance,
    },
};

mod success {

    use super::*;

    #[tokio::test]
    async fn verify_bytecode_root_of_simple_contract_with_configurables() {
        let (test_contract_instance, wallet) = test_contract_instance().await;
        let (contract_offset, _predicate_offset, config_value) = defaults();

        // Get the bytecode for the contract
        let file_bytecode = simple_contract_bytecode();

        // Build the configurable changes
        let my_configurables = build_simple_configurables(contract_offset, config_value);

        // Deploy the new simple contract with the bytecode that contains the changes
        let (simple_contract_instance, id) = deploy_simple_contract_with_configurables_from_file(
            wallet.clone(),
            config_value as u64,
        )
        .await;

        verify_simple_contract_bytecode(
            &test_contract_instance,
            file_bytecode,
            Some(my_configurables),
            id,
            simple_contract_instance,
        )
        .await;
    }

    #[tokio::test]
    async fn verify_bytecode_root_of_complex_contract_with_configurables() {
        let (test_contract_instance, wallet) = test_contract_instance().await;
        let (_contract_offset, _predicate_offset, config_value) = defaults();
        let (config_struct, config_enum) = complex_defaults();

        // Get the bytecode for the contract
        let file_bytecode = complex_contract_bytecode();

        // Build the configurable changes
        let my_configurables =
            build_complex_configurables(config_value, config_struct.clone(), config_enum.clone());

        // Deploy the new contract with the bytecode that contains the changes
        let (complex_contract_instance, id) = deploy_complex_contract_with_configurables_from_file(
            wallet.clone(),
            config_value as u64,
            config_struct,
            config_enum,
        )
        .await;

        verify_complex_contract_bytecode(
            &test_contract_instance,
            file_bytecode,
            Some(my_configurables),
            id,
            complex_contract_instance,
        )
        .await;
    }

    #[tokio::test]
    async fn verify_bytecode_root_of_simple_contract() {
        let (test_contract_instance, wallet) = test_contract_instance().await;

        // Get the bytecode for the contract
        let file_bytecode = simple_contract_bytecode();

        // Deploy the new simple contract with the bytecode that contains the changes
        let (simple_contract_instance, id) = deploy_simple_contract_from_file(wallet.clone()).await;

        verify_simple_contract_bytecode(
            &test_contract_instance,
            file_bytecode,
            None,
            id,
            simple_contract_instance,
        )
        .await;
    }

    #[tokio::test]
    async fn verify_bytecode_root_of_complex_contract() {
        let (test_contract_instance, wallet) = test_contract_instance().await;

        // Get the bytecode for the contract
        let file_bytecode = complex_contract_bytecode();

        // Deploy the new contract with the bytecode that contains the changes
        let (complex_contract_instance, id) =
            deploy_complex_contract_from_file(wallet.clone()).await;

        verify_complex_contract_bytecode(
            &test_contract_instance,
            file_bytecode,
            None,
            id,
            complex_contract_instance,
        )
        .await;
    }
}

mod revert {

    use super::*;

    #[tokio::test]
    #[should_panic]
    async fn when_configurables_do_not_match() {
        let (test_contract_instance, wallet) = test_contract_instance().await;
        let (contract_offset, _predicate_offset, config_value) = defaults();

        // Get the bytecode for the contract
        let file_bytecode = simple_contract_bytecode();

        // Build the configurable changes
        let my_configurables = build_simple_configurables(contract_offset, config_value);

        // Deploy the new simple contract with the bytecode that contains the changes
        let (simple_contract_instance, id) = deploy_simple_contract_with_configurables_from_file(
            wallet.clone(),
            (config_value as u64) + 1,
        )
        .await;

        verify_simple_contract_bytecode(
            &test_contract_instance,
            file_bytecode,
            Some(my_configurables),
            id,
            simple_contract_instance,
        )
        .await;
    }

    #[tokio::test]
    #[should_panic]
    async fn when_bytecode_is_empty() {
        let (test_contract_instance, wallet) = test_contract_instance().await;

        let empty_bytecode: Vec<u8> = Vec::new();
        let my_configurables: Vec<(u64, Vec<u8>)> = Vec::new();

        // Deploy the new simple contract with the bytecode that contains the changes
        let (simple_contract_instance, id) =
            deploy_simple_contract_with_configurables_from_file(wallet.clone(), 0).await;

        // Call the contract and compute the bytecode root
        verify_simple_contract_bytecode(
            &test_contract_instance,
            empty_bytecode,
            Some(my_configurables),
            id,
            simple_contract_instance,
        )
        .await;
    }

    #[tokio::test]
    #[should_panic]
    async fn when_bytecode_does_not_match_and_no_configurables() {
        let (test_contract_instance, wallet) = test_contract_instance().await;

        // Get the bytecode for the contract
        let file_bytecode = predicate_bytecode();

        // Deploy the new simple contract with the bytecode that contains the changes
        let (simple_contract_instance, id) = deploy_simple_contract_from_file(wallet.clone()).await;

        verify_simple_contract_bytecode(
            &test_contract_instance,
            file_bytecode,
            None,
            id,
            simple_contract_instance,
        )
        .await;
    }

    #[tokio::test]
    #[should_panic]
    async fn when_bytecode_is_empty_and_no_configurables() {
        let (test_contract_instance, wallet) = test_contract_instance().await;

        let empty_bytecode: Vec<u8> = Vec::new();

        // Deploy the new simple contract with the bytecode that contains the changes
        let (simple_contract_instance, id) = deploy_simple_contract_from_file(wallet.clone()).await;

        verify_simple_contract_bytecode(
            &test_contract_instance,
            empty_bytecode,
            None,
            id,
            simple_contract_instance,
        )
        .await;
    }
}
