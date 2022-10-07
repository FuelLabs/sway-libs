use crate::string::tests::utils::{
    abi_calls::{from_utf8},
    test_helpers::setup,
};

mod success {

    use super::*;

    #[tokio::test]
    async fn converts_from_utf8_vec() {
        let instance = setup().await;

        from_utf8(&instance).await;
    }
}