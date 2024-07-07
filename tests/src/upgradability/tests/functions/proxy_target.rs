mod success {

    use crate::upgradability::tests::utils::{
        abi_calls::{proxy_target, set_proxy_target},
        test_helpers::{setup, SECOND_TARGET},
    };
    use fuels::types::ContractId;

    #[tokio::test]
    async fn returns_initialized_target() {
        let (_deployer, owner1, _owner2) = setup().await;

        assert_eq!(
            proxy_target(&owner1.contract).await.value,
            Some(ContractId::zeroed())
        );
    }

    #[tokio::test]
    async fn returns_target_on_state_change() {
        let (_deployer, owner1, _owner2) = setup().await;

        set_proxy_target(&owner1.contract, SECOND_TARGET).await;

        assert_eq!(
            proxy_target(&owner1.contract).await.value,
            Some(SECOND_TARGET)
        );
    }
}
