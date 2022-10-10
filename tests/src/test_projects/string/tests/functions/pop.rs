use crate::string::tests::utils::{
    abi_calls::pop,
    test_helpers::setup,
};

mod success {

    use super::*;

    #[tokio::test]
    async fn pops_end_of_string() {
        let instance = setup().await;

        pop(&instance).await;
    }
}
