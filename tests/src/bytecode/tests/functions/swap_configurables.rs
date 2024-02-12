use crate::bytecode::tests::utils::{
    abi_calls::{return_configurables, swap_configurables, test_function},
    test_helpers::{
        build_complex_configurables, build_simple_configurables, complex_contract_bytecode,
        complex_defaults, defaults, deploy_complex_contract_from_bytecode,
        deploy_simple_contract_from_bytecode, predicate_bytecode, setup_predicate_from_bytecode,
        simple_contract_bytecode, spend_predicate, test_contract_instance,
    },
};

mod success {

    use super::*;

    #[tokio::test]
    async fn swap_configurables_in_simple_contract() {
        let (test_contract_instance, wallet) = test_contract_instance().await;
        let (contract_offset, _predicate_offset, config_value) = defaults();

        // Get the bytecode for the contract
        let file_bytecode = simple_contract_bytecode();

        // Build the configurable changes
        let my_configurables = build_simple_configurables(contract_offset, config_value);

        // Call the contract to swap the configurables
        let result_bytecode = swap_configurables(
            &test_contract_instance,
            file_bytecode.clone(),
            my_configurables.clone(),
        )
        .await;

        // Verify the bytecode has the correct changes made for the configurables
        assert!(file_bytecode != result_bytecode);
        for iter in 0..7 {
            assert_eq!(
                result_bytecode
                    .get(my_configurables.get(0).unwrap().0 as usize + iter)
                    .unwrap(),
                my_configurables.get(0).unwrap().1.get(iter).unwrap()
            );
        }

        // Deploy the new simple contract with the bytecode that contains the changes
        let simple_contract_instance =
            deploy_simple_contract_from_bytecode(wallet, result_bytecode).await;

        // Assert that we get the exected value for the configurable from the deployed simple contract.
        let result_u64 = test_function(&simple_contract_instance).await;
        assert!(result_u64 == config_value as u64);
    }

    #[tokio::test]
    async fn swap_configurables_in_complex_contract() {
        let (test_contract_instance, wallet) = test_contract_instance().await;
        let (_contract_offset, _predicate_offset, config_value) = defaults();
        let (config_struct, config_enum) = complex_defaults();

        // Get the bytecode for the contract
        let file_bytecode = complex_contract_bytecode();

        // Build the configurable changes
        let my_configurables =
            build_complex_configurables(config_value, config_struct.clone(), config_enum.clone());

        // Call the contract to swap the configurables
        let result_bytecode = swap_configurables(
            &test_contract_instance,
            file_bytecode.clone(),
            my_configurables.clone(),
        )
        .await;

        // Verify the bytecode has the correct changes made for the configurables
        assert!(file_bytecode != result_bytecode);
        for config_iter in 0..my_configurables.len() {
            let (offset, configurable) = my_configurables.get(config_iter).unwrap();
            for iter in 0..configurable.len() {
                assert_eq!(
                    result_bytecode.get(*offset as usize + iter).unwrap(),
                    configurable.get(iter).unwrap()
                );
            }
        }

        // Deploy the new simple contract with the bytecode that contains the changes
        let complex_contract_instance =
            deploy_complex_contract_from_bytecode(wallet, result_bytecode).await;

        // Assert that we get the exected value for the configurable from the deployed simple contract.
        let (result_u64, result_struct, result_enum) =
            return_configurables(&complex_contract_instance).await;
        assert!(result_u64 == config_value as u64);
        assert_eq!(result_struct, config_struct);
        assert_eq!(result_enum, config_enum);
    }

    #[tokio::test]
    async fn swap_configurables_in_predicate() {
        let (test_contract_instance, wallet) = test_contract_instance().await;
        let (_contract_offset, predicate_offset, config_value) = defaults();

        // Get the bytecode for the predicate
        let file_bytecode = predicate_bytecode();

        // Build the configurable changes
        let my_configurables = build_simple_configurables(predicate_offset, config_value);

        // Call the contract to swap the configurables
        let result_bytecode = swap_configurables(
            &test_contract_instance,
            file_bytecode.clone(),
            my_configurables.clone(),
        )
        .await;

        // Verify the bytecode has the correct changes made for the configurables
        assert!(file_bytecode != result_bytecode);
        for iter in 0..7 {
            assert_eq!(
                result_bytecode
                    .get(my_configurables.get(0).unwrap().0 as usize + iter)
                    .unwrap(),
                my_configurables.get(0).unwrap().1.get(iter).unwrap()
            );
        }

        // Create the new simple predicate with the bytecode that contains the changes
        let predicate_instance =
            setup_predicate_from_bytecode(wallet.clone(), result_bytecode, config_value as u64)
                .await;

        // Assert that we can spend the predicate with the exected value for the configurable.
        spend_predicate(predicate_instance, wallet).await;
    }
}
