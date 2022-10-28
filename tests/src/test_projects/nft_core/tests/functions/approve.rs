use crate::nft_core::tests::utils::{
    abi_calls::{approve, approved, mint,balance_of},
    test_helpers::setup,
};
use fuels::{prelude::Identity, signers::Signer};

mod success {

    use super::*;

    #[tokio::test]
    async fn approves() {
        let (_deploy_wallet, owner1, owner2) = setup().await;
        let minter = Identity::Address(owner1.wallet.address().into());

        mint(1, &owner1.contract, minter.clone()).await;

        let approved_identity = Option::Some(Identity::Address(owner2.wallet.address().into()));
        approve(approved_identity.clone(), &owner1.contract, 0).await;

        assert_eq!(approved(&owner1.contract, 0).await, approved_identity);
    }

    #[tokio::test]
    async fn approves_mutliple() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        mint(4, &owner1.contract, minter.clone()).await;

        let approved_identity = Option::Some(Identity::Address(owner2.wallet.address().into()));
        approve(approved_identity.clone(), &owner1.contract, 0).await;
        assert_eq!(approved(&owner1.contract, 0).await, approved_identity);

        let approved_identity = Option::Some(Identity::Address(owner2.wallet.address().into()));
        approve(approved_identity.clone(), &owner1.contract, 1).await;
        assert_eq!(approved(&owner1.contract, 1).await, approved_identity);

        let approved_identity = Option::Some(Identity::Address(owner2.wallet.address().into()));
        approve(approved_identity.clone(), &owner1.contract, 2).await;
        assert_eq!(approved(&owner1.contract, 2).await, approved_identity);

        let approved_identity = Option::Some(Identity::Address(owner2.wallet.address().into()));
        approve(approved_identity.clone(), &owner1.contract, 3).await;
        assert_eq!(approved(&owner1.contract, 3).await, approved_identity);
    }
}

mod reverts {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "Revert(42)")]
    async fn panics_when_token_does_not_exist() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let approved_identity = Option::Some(Identity::Address(owner2.wallet.address().into()));
        approve(approved_identity.clone(), &owner1.contract, 0).await;
    }

    #[tokio::test]
    #[should_panic(expected = "Revert(42)")]
    async fn panics_when_sender_is_not_owner() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        mint(1, &owner1.contract, minter.clone()).await;

        let approved_identity = Option::Some(Identity::Address(owner2.wallet.address().into()));
        approve(approved_identity.clone(), &owner2.contract, 0).await;
    }
}
