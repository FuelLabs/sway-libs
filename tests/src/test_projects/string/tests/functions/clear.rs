use crate::string::tests::utils::{
    abi_calls::{clear},
    test_helpers::setup,
};

mod success {

    use super::*;

    #[tokio::test]
    async fn clears_bytes() {
        let instance = setup().await;

        clear(&instance).await;
    }
}
