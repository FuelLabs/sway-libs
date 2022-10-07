use crate::string::tests::utils::{
    abi_calls::{with_capacity},
    test_helpers::setup,
};

mod success {

    use super::*;

    #[tokio::test]
    async fn creates_new_string_with_capacity() {
        let instance = setup().await;

        with_capacity(&instance).await;
    }
}
