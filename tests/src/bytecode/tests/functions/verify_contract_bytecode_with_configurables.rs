use crate::bytecode::tests::utils::{
    abi_calls::verify_contract_bytecode_with_configurables,
    test_helpers::{
        build_configurables, contract_bytecode, defaults,
        deploy_simple_contract_with_configurables_from_file, test_contract_instance,
    },
};

mod success {

    use super::*;

    #[tokio::test]
    async fn verify_bytecode_root_of_contract() {
        let (test_contract_instance, wallet) = test_contract_instance().await;
        let (contract_offset, _predicate_offset, config_value) = defaults();

        // Get the bytecode for the contract
        let file_bytecode = contract_bytecode();

        // Build the configurable changes
        let my_configurables = build_configurables(contract_offset, config_value);

        // Deploy the new simple contract with the bytecode that contains the changes
        let (simple_contract_instance, id) = deploy_simple_contract_with_configurables_from_file(
            wallet.clone(),
            config_value as u64,
        )
        .await;

        verify_contract_bytecode_with_configurables(
            &test_contract_instance,
            file_bytecode,
            my_configurables,
            id,
            simple_contract_instance,
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
        let file_bytecode = contract_bytecode();

        // Build the configurable changes
        let my_configurables = build_configurables(contract_offset, config_value);

        // Deploy the new simple contract with the bytecode that contains the changes
        let (simple_contract_instance, id) = deploy_simple_contract_with_configurables_from_file(
            wallet.clone(),
            (config_value as u64) + 1,
        )
        .await;

        verify_contract_bytecode_with_configurables(
            &test_contract_instance,
            file_bytecode,
            my_configurables,
            id,
            simple_contract_instance,
        )
        .await;
    }
}
