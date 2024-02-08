use crate::bytecode::tests::utils::{
    abi_calls::verify_contract_bytecode,
    test_helpers::{
        contract_bytecode, deploy_simple_contract_from_file, predicate_bytecode,
        test_contract_instance,
    },
};

mod success {

    use super::*;

    #[tokio::test]
    async fn verify_bytecode_root_of_contract() {
        let (test_contract_instance, wallet) = test_contract_instance().await;

        // Get the bytecode for the contract
        let file_bytecode = contract_bytecode();

        // Deploy the new simple contract with the bytecode that contains the changes
        let (simple_contract_instance, id) = deploy_simple_contract_from_file(wallet.clone()).await;

        verify_contract_bytecode(
            &test_contract_instance,
            file_bytecode,
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
    async fn when_bytecode_does_not_match() {
        let (test_contract_instance, wallet) = test_contract_instance().await;

        // Get the bytecode for the contract
        let file_bytecode = predicate_bytecode();

        // Deploy the new simple contract with the bytecode that contains the changes
        let (simple_contract_instance, id) = deploy_simple_contract_from_file(wallet.clone()).await;

        verify_contract_bytecode(
            &test_contract_instance,
            file_bytecode,
            id,
            simple_contract_instance,
        )
        .await;
    }
}
