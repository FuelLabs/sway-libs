use crate::string::tests::utils::{
    abi_calls::{is_empty},
    test_helpers::setup,
};

mod success {

    use super::*;

    #[tokio::test]
    async fn checks_if_empty() {
        let instance = setup().await;

        is_empty(&instance).await;
    }
}
