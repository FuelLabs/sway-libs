use crate::string::tests::utils::{
    abi_calls::{push},
    test_helpers::setup,
};

mod success {

    use super::*;

    #[tokio::test]
    async fn pushes_to_end_of_string() {
        let instance = setup().await;

        push(&instance).await;
    }
}
