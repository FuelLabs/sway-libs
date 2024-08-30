use crate::bytecode::tests::utils::{
    abi_calls::compute_bytecode_root,
    test_helpers::{
        complex_contract_bytecode, complex_contract_bytecode_root_from_file, predicate_bytecode,
        simple_contract_bytecode, simple_contract_bytecode_root_from_file,
        simple_predicate_bytecode_root_from_file, test_contract_instance,
    },
};

mod success {

    use super::*;

    #[tokio::test]
    async fn compute_bytecode_root_of_simple_contract() {
        let (test_contract_instance, _wallet) = test_contract_instance().await;

        // Get the bytecode for the contract
        let file_bytecode = simple_contract_bytecode();

        // Get the bytecode root from the file
        let file_bytecode_root = simple_contract_bytecode_root_from_file().await;

        // Call the contract and compute the bytecode root
        let result_bytecode_root =
            compute_bytecode_root(&test_contract_instance, file_bytecode).await;

        assert_eq!(result_bytecode_root, file_bytecode_root);
    }

    #[tokio::test]
    async fn compute_bytecode_root_of_complex_contract() {
        let (test_contract_instance, _wallet) = test_contract_instance().await;

        // Get the bytecode for the contract
        let file_bytecode = complex_contract_bytecode();

        // Get the bytecode root from the file
        let file_bytecode_root = complex_contract_bytecode_root_from_file().await;

        // Call the contract and compute the bytecode root
        let result_bytecode_root =
            compute_bytecode_root(&test_contract_instance, file_bytecode).await;

        assert_eq!(result_bytecode_root, file_bytecode_root);
    }

    #[tokio::test]
    async fn compute_bytecode_root_of_predicate() {
        let (test_contract_instance, wallet) = test_contract_instance().await;

        // Get the bytecode for the predicate
        let file_bytecode = predicate_bytecode();

        // Call the contract and compute the bytecode root
        let result_bytecode_root =
            compute_bytecode_root(&test_contract_instance, file_bytecode).await;

        // Get the bytecode root of the predicate from the file.
        let predicate_bytecode_root =
            simple_predicate_bytecode_root_from_file(wallet.clone()).await;

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

        // Call the contract and compute the bytecode root
        let _result_bytecode_root =
            compute_bytecode_root(&test_contract_instance, empty_bytecode).await;
    }
}
