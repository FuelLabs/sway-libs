use crate::string::tests::utils::{abi_calls::join, test_helpers::setup};

mod success {

    use super::*;

    #[tokio::test]
    async fn joins() {
        let instance = setup().await;

        join(&instance).await;
    }
}
