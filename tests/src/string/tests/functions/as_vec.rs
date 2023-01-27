use crate::string::tests::utils::{abi_calls::as_vec, test_helpers::setup};

mod success {

    use super::*;

    #[tokio::test]
    async fn returns_vec() {
        let instance = setup().await;

        as_vec(&instance).await;
    }
}
