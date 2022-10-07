use crate::string::tests::utils::{
    abi_calls::{nth},
    test_helpers::setup,
};

mod success {

    use super::*;

    #[tokio::test]
    async fn returns_nth_index() {
        let instance = setup().await;

        nth(&instance).await;
    }
}
