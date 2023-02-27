use crate::string::tests::utils::{abi_calls::append, test_helpers::setup};

mod success {

    use super::*;

    #[tokio::test]
    async fn appends() {
        let instance = setup().await;

        append(&instance).await;
    }
}
