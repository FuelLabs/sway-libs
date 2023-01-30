use crate::string::tests::utils::{abi_calls::into, test_helpers::setup};

mod success {

    use super::*;

    #[tokio::test]
    async fn returns_bytes() {
        let instance = setup().await;

        into(&instance).await;
    }
}
