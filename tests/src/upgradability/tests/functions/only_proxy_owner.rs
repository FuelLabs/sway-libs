use crate::upgradability::tests::utils::{
    abi_calls::{only_proxy_owner, set_proxy_owner},
    test_helpers::setup,
    State,
};

mod success {

    use super::*;

    #[tokio::test]
    async fn only_owner_may_call() {
        let (_deployer, owner1, _owner2) = setup().await;

        only_proxy_owner(&owner1.contract).await;
    }

    #[tokio::test]
    async fn only_owner_after_transfer() {
        let (_deployer, owner1, owner2) = setup().await;

        only_proxy_owner(&owner1.contract).await;

        set_proxy_owner(
            &owner1.contract,
            State::Initialized(owner2.wallet.address().into()),
        )
        .await;

        only_proxy_owner(&owner2.contract).await;
    }
}

mod reverts {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "NotOwner")]
    async fn when_not_owner() {
        let (_deployer, _owner1, owner2) = setup().await;

        only_proxy_owner(&owner2.contract).await;
    }

    #[tokio::test]
    #[should_panic(expected = "NotOwner")]
    async fn when_no_owner() {
        let (_deployer, owner1, _owner2) = setup().await;

        set_proxy_owner(&owner1.contract, State::Revoked).await;

        only_proxy_owner(&owner1.contract).await;
    }
}
