use crate::bytecode::tests::utils::{
    abi_calls::compute_predicate_address,
    test_helpers::{predicate_bytecode, setup_predicate_from_file, test_contract_instance},
};

mod success {

    use super::*;

    #[tokio::test]
    async fn compute_predicate_address_from_bytecode() {
        let (test_contract_instance, wallet) = test_contract_instance().await;

        // Get the bytecode for the predicate
        let file_bytecode = predicate_bytecode();

        // Call the contract and compute the address
        let result_address =
            compute_predicate_address(&test_contract_instance, file_bytecode).await;

        // Create an instance of the predicate
        let predicate_instance = setup_predicate_from_file(wallet.clone()).await;

        // Assert that the roots are the same.
        assert_eq!(result_address, predicate_instance.address().into());
    }
}

mod revert {

    use super::*;

    #[tokio::test]
    #[should_panic]
    async fn when_bytecode_is_empty() {
        let (test_contract_instance, _wallet) = test_contract_instance().await;

        let empty_bytecode: Vec<u8> = Vec::new();

        // Call the contract and compute the address
        let result_address =
            compute_predicate_address(&test_contract_instance, empty_bytecode).await;
    }
}
