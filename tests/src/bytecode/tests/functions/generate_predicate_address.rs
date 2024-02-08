use crate::bytecode::tests::utils::{
    abi_calls::generate_predicate_address,
    test_helpers::{simple_predicate_bytecode_root_from_file, setup_predicate_from_file, test_contract_instance},
};

mod success {

    use super::*;

    #[tokio::test]
    async fn generate_address_from_root() {
        let (test_contract_instance, wallet) = test_contract_instance().await;

        // Get the bytecode root of the predicate from the file.
        let predicate_bytecode_root = simple_predicate_bytecode_root_from_file(wallet.clone()).await;

        // Create an instance of the predicate
        let predicate_instance = setup_predicate_from_file(wallet.clone()).await;

        // Generate the predicate address
        let generated_address = generate_predicate_address(&test_contract_instance, predicate_bytecode_root).await;

        // Assert that the roots are the same.
        assert_eq!(generated_address, predicate_instance.address().into());
    }
}
