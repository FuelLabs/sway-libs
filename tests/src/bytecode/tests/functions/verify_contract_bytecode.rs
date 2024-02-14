use crate::bytecode::tests::utils::{
    abi_calls::{verify_complex_contract_bytecode, verify_simple_contract_bytecode},
    test_helpers::{
        complex_contract_bytecode, deploy_complex_contract_from_file,
        deploy_simple_contract_from_file, predicate_bytecode, simple_contract_bytecode,
        test_contract_instance,
    },
};

mod success {

    use super::*;

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
    async fn when_bytecode_does_not_match() {
        let (test_contract_instance, wallet) = test_contract_instance().await;

        // Get the bytecode for the contract
        let file_bytecode = predicate_bytecode();

        // Deploy the new simple contract with the bytecode that contains the changes
        let (simple_contract_instance, id) = deploy_simple_contract_from_file(wallet.clone()).await;

        verify_simple_contract_bytecode(
            &test_contract_instance,
            file_bytecode,
            id,
            simple_contract_instance,
        )
        .await;
    }
}
