use crate::string::tests::utils::{abi_calls::swap, test_helpers::setup};

mod success {

    use super::*;

    #[tokio::test]
    async fn swaps() {
        let instance = setup().await;

        swap(&instance).await;
    }
}
