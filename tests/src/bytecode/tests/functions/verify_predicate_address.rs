use crate::bytecode::tests::utils::{
    abi_calls::verify_predicate_address,
    test_helpers::{
        build_simple_configurables, defaults, predicate_bytecode, setup_predicate_from_file,
        setup_predicate_from_file_with_configurable, simple_contract_bytecode,
        test_contract_instance,
    },
};

mod success {

    use super::*;

    #[tokio::test]
    async fn verify_predicate_address_with_configurables_from_bytecode() {
        let (test_contract_instance, wallet) = test_contract_instance().await;
        let (_contract_offset, predicate_offset, config_value) = defaults();

        // Get the bytecode for the predicate
        let file_bytecode = predicate_bytecode();

        // Build the configurable changes
        let my_configurables = build_simple_configurables(predicate_offset, config_value);

        // Create an instance of the predicate
        let predicate_instance =
            setup_predicate_from_file_with_configurable(wallet.clone(), config_value as u64).await;

        verify_predicate_address(
            &test_contract_instance,
            file_bytecode,
            Some(my_configurables),
            predicate_instance.address().into(),
        )
        .await;
    }

    #[tokio::test]
    async fn verify_predicate_address_from_bytecode() {
        let (test_contract_instance, wallet) = test_contract_instance().await;

        // Get the bytecode for the predicate
        let file_bytecode = predicate_bytecode();

        // Create an instance of the predicate
        let predicate_instance = setup_predicate_from_file(wallet.clone()).await;

        verify_predicate_address(
            &test_contract_instance,
            file_bytecode,
            None,
            predicate_instance.address().into(),
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
        let (_contract_offset, predicate_offset, config_value) = defaults();

        // Get the bytecode for the predicate
        let file_bytecode = predicate_bytecode();

        // Build the configurable changes
        let my_configurables = build_simple_configurables(predicate_offset, config_value);

        // Create an instance of the predicate
        let predicate_instance =
            setup_predicate_from_file_with_configurable(wallet.clone(), (config_value as u64) + 1)
                .await;

        verify_predicate_address(
            &test_contract_instance,
            file_bytecode,
            Some(my_configurables),
            predicate_instance.address().into(),
        )
        .await;
    }

    #[tokio::test]
    #[should_panic]
    async fn when_bytecode_is_empty() {
        let (test_contract_instance, wallet) = test_contract_instance().await;

        let empty_bytecode: Vec<u8> = Vec::new();
        let my_configurables: Vec<(u64, Vec<u8>)> = Vec::new();

        // Create an instance of the predicate
        let predicate_instance =
            setup_predicate_from_file_with_configurable(wallet.clone(), 0).await;

        verify_predicate_address(
            &test_contract_instance,
            empty_bytecode,
            Some(my_configurables),
            predicate_instance.address().into(),
        )
        .await;
    }

    #[tokio::test]
    #[should_panic]
    async fn when_bytecode_does_not_match_and_no_configurables() {
        let (test_contract_instance, wallet) = test_contract_instance().await;

        // Get the bytecode for the predicate
        let file_bytecode = simple_contract_bytecode();

        // Create an instance of the predicate
        let predicate_instance = setup_predicate_from_file(wallet.clone()).await;

        verify_predicate_address(
            &test_contract_instance,
            file_bytecode,
            None,
            predicate_instance.address().into(),
        )
        .await;
    }

    #[tokio::test]
    #[should_panic]
    async fn when_bytecode_is_empty_and_no_configurables() {
        let (test_contract_instance, wallet) = test_contract_instance().await;

        let empty_bytecode: Vec<u8> = Vec::new();

        // Create an instance of the predicate
        let predicate_instance = setup_predicate_from_file(wallet.clone()).await;

        verify_predicate_address(
            &test_contract_instance,
            empty_bytecode,
            None,
            predicate_instance.address().into(),
        )
        .await;
    }
}
