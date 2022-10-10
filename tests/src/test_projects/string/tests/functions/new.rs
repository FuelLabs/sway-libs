use crate::string::tests::utils::{
    abi_calls::new,
    test_helpers::setup,
};

mod success {

    use super::*;

    #[tokio::test]
    async fn creates_new_string() {
        let instance = setup().await;

        new(&instance).await;
    }
}
