use crate::ownership::tests::utils::{
    abi_calls::{only_owner, set_ownership, transfer_ownership},
    test_helpers::setup,
};
use fuels::types::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn only_owner_may_call() {
        let (_deployer, owner1, _owner2) = setup().await;

        let owner1_identity = Identity::Address(owner1.wallet.address().into());
        set_ownership(&owner1.contract, owner1_identity.clone()).await;

        only_owner(&owner1.contract).await;
    }

    #[tokio::test]
    async fn only_owner_after_transfer() {
        let (_deployer, owner1, owner2) = setup().await;

        let owner1_identity = Identity::Address(owner1.wallet.address().into());
        let owner2_identity = Identity::Address(owner2.wallet.address().into());
        set_ownership(&owner1.contract, owner1_identity.clone()).await;

        only_owner(&owner1.contract).await;

        transfer_ownership(&owner1.contract, owner2_identity.clone()).await;

        only_owner(&owner2.contract).await;
    }
}

mod reverts {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "NotOwner")]
    async fn when_not_owner() {
        let (_deployer, owner1, owner2) = setup().await;

        let owner1_identity = Identity::Address(owner1.wallet.address().into());
        set_ownership(&owner1.contract, owner1_identity.clone()).await;

        only_owner(&owner2.contract).await;
    }

    #[tokio::test]
    #[should_panic(expected = "NotOwner")]
    async fn when_no_owner() {
        let (_deployer, owner1, _owner2) = setup().await;

        only_owner(&owner1.contract).await;
    }
}
