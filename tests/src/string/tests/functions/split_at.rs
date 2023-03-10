use crate::string::tests::utils::{abi_calls::split_at, test_helpers::setup};

mod success {

    use super::*;

    #[tokio::test]
    async fn splits() {
        let instance = setup().await;

        split_at(&instance).await;
    }
}
