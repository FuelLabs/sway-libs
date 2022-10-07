use crate::string::tests::utils::{
    abi_calls::{insert},
    test_helpers::setup,
};

mod success {

    use super::*;

    #[tokio::test]
    async fn inserts_bytes_into_string() {
        let instance = setup().await;

        insert(&instance).await;
    }
}
