use crate::string::tests::utils::{abi_calls::from_bytes, test_helpers::setup};

mod success {

    use super::*;

    #[tokio::test]
    async fn converts_from_bytes() {
        let instance = setup().await;

        from_bytes(&instance).await;
    }
}
