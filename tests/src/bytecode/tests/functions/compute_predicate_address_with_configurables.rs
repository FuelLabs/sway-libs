use crate::bytecode::tests::utils::{
    abi_calls::compute_predicate_address_with_configurables,
    test_helpers::{
        build_configurables, defaults, predicate_bytecode,
        setup_predicate_from_file_with_configurable, test_contract_instance,
    },
};

mod success {

    use super::*;

    #[tokio::test]
    async fn compute_predicate_address_with_configurables_from_bytecode() {
        let (test_contract_instance, wallet) = test_contract_instance().await;
        let (_contract_offset, predicate_offset, config_value) = defaults();

        // Get the bytecode for the predicate
        let file_bytecode = predicate_bytecode();

        // Build the configurable changes
        let my_configurables = build_configurables(predicate_offset, config_value);

        // Call the contract and compute the address
        let result_address = compute_predicate_address_with_configurables(
            &test_contract_instance,
            file_bytecode,
            my_configurables,
        )
        .await;

        // Create an instance of the predicate
        let predicate_instance =
            setup_predicate_from_file_with_configurable(wallet.clone(), config_value as u64).await;

        // Assert that the roots are the same.
        assert_eq!(result_address, predicate_instance.address().into());
    }
}
