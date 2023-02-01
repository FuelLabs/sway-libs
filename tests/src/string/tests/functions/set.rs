use crate::string::tests::utils::{abi_calls::set, test_helpers::setup};

mod success {

    use super::*;

    #[tokio::test]
    async fn sets() {
        let instance = setup().await;

        set(&instance).await;
    }
}
