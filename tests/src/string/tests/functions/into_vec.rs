use crate::string::tests::utils::{abi_calls::into_vec, test_helpers::setup};

mod success {

    use super::*;

    #[tokio::test]
    async fn returns_vec() {
        let instance = setup().await;

        into_vec(&instance).await;
    }
}
