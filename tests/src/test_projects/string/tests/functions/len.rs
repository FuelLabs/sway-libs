use crate::string::tests::utils::{
    abi_calls::{len},
    test_helpers::setup,
};

mod success {

    use super::*;

    #[tokio::test]
    async fn returns_string_length() {
        let instance = setup().await;

        len(&instance).await;
    }
}
