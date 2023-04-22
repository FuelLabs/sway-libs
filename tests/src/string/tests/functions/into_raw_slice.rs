use crate::string::tests::utils::{abi_calls::into_raw_slice, test_helpers::setup};

mod success {

    use super::*;

    #[tokio::test]
    async fn returns_raw_slice() {
        let instance = setup().await;

        into_raw_slice(&instance).await;
    }
}
