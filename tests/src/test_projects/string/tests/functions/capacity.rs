use crate::string::tests::utils::{
    abi_calls::capacity,
    test_helpers::setup,
};

mod success {

    use super::*;

    #[tokio::test]
    async fn get_capacity() {
        let instance = setup().await;

        capacity(&instance).await;
    }
}
