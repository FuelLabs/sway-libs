use crate::nft_core::tests::utils::{
    abi_calls::{approve, approved, mint},
    test_helpers::setup,
};
use fuels::{prelude::Identity, signers::Signer};

mod success {

    use super::*;

    #[tokio::test]
    async fn gets_approval() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        mint(1, &owner1.contract, minter.clone()).await;

        let approved_identity = Option::Some(Identity::Address(owner2.wallet.address().into()));
        approve(approved_identity.clone(), &owner1.contract, 0).await;

        assert_eq!(approved(&owner1.contract, 0).await, approved_identity);
    }

    #[tokio::test]
    async fn gets_approval_multiple() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        mint(3, &owner1.contract, minter.clone()).await;

        let approved_identity = Option::Some(Identity::Address(owner2.wallet.address().into()));
        approve(approved_identity.clone(), &owner1.contract, 0).await;
        approve(approved_identity.clone(), &owner1.contract, 1).await;
        approve(approved_identity.clone(), &owner1.contract, 2).await;

        assert_eq!(approved(&owner1.contract, 0).await, approved_identity);
        assert_eq!(approved(&owner1.contract, 1).await, approved_identity);
        assert_eq!(approved(&owner1.contract, 2).await, approved_identity);
    }

    #[tokio::test]
    async fn gets_approval_for_none() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        mint(1, &owner1.contract, minter.clone()).await;

        assert_eq!(approved(&owner1.contract, 0).await, Option::None);
    }
}

mod reverts {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "Revert(42)")]
    async fn when_token_does_not_exist() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        approved(&owner1.contract, 0).await;
    }
}
