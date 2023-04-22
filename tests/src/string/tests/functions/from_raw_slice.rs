use crate::string::tests::utils::{abi_calls::from_raw_slice, test_helpers::setup};

mod success {

    use super::*;

    #[tokio::test]
    async fn converts_from_raw_slice() {
        let instance = setup().await;

        from_raw_slice(&instance).await;
    }
}
