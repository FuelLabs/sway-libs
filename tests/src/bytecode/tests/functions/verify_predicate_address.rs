use crate::bytecode::tests::utils::{
    abi_calls::verify_predicate_address,
    test_helpers::{
        predicate_bytecode, setup_predicate_from_file, simple_contract_bytecode,
        test_contract_instance,
    },
};

mod success {

    use super::*;

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
            predicate_instance.address().into(),
        )
        .await;
    }
}

mod revert {

    use super::*;

    #[tokio::test]
    #[should_panic]
    async fn when_bytecode_does_not_match() {
        let (test_contract_instance, wallet) = test_contract_instance().await;

        // Get the bytecode for the predicate
        let file_bytecode = simple_contract_bytecode();

        // Create an instance of the predicate
        let predicate_instance = setup_predicate_from_file(wallet.clone()).await;

        verify_predicate_address(
            &test_contract_instance,
            file_bytecode,
            predicate_instance.address().into(),
        )
        .await;
    }
}
