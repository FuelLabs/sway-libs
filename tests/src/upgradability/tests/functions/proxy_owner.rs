mod success {

    use crate::upgradability::tests::utils::{
        abi_calls::{proxy_owner, set_proxy_owner},
        test_helpers::setup,
        State,
    };

    #[tokio::test]
    async fn returns_initialized_owner() {
        let (_deployer, owner1, _owner2) = setup().await;

        assert_eq!(
            proxy_owner(&owner1.contract).await.value,
            State::Initialized(owner1.wallet.address().into())
        );
    }

    #[tokio::test]
    async fn returns_owner_on_state_change() {
        let (_deployer, owner1, _owner2) = setup().await;

        set_proxy_owner(&owner1.contract, State::Revoked).await;

        assert_eq!(proxy_owner(&owner1.contract).await.value, State::Revoked);
    }
}
