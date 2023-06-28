use crate::string::tests::utils::{abi_calls::into_bytes, test_helpers::setup};

mod success {

    use super::*;

    #[tokio::test]
    async fn returns_bytes() {
        let instance = setup().await;

        into_bytes(&instance).await;
    }
}
