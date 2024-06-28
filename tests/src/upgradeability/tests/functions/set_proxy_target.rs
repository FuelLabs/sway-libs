mod success {

    use crate::upgradeability::tests::utils::{
        abi_calls::{proxy_target, set_proxy_target},
        test_helpers::{setup, INITIAL_TARGET, SECOND_TARGET},
    };

    #[tokio::test]
    async fn sets_a_new_target() {
        let (_deployer, owner1, _owner2) = setup().await;

        assert_eq!(
            proxy_target(&owner1.contract).await.value,
            Some(INITIAL_TARGET)
        );

        set_proxy_target(&owner1.contract, SECOND_TARGET).await;

        assert_eq!(
            proxy_target(&owner1.contract).await.value,
            Some(SECOND_TARGET)
        );
    }
}
