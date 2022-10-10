use crate::string::tests::utils::{
    abi_calls::remove,
    test_helpers::setup,
};

mod success {

    use super::*;

    #[tokio::test]
    async fn removes_at_index() {
        let instance = setup().await;

        remove(&instance).await;
    }
}
