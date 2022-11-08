use crate::string::tests::utils::{abi_calls::as_bytes, test_helpers::setup};

mod success {

    use super::*;

    #[tokio::test]
    async fn returns_bytes() {
        let instance = setup().await;

        as_bytes(&instance).await;
    }
}
