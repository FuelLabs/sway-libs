use crate::nft_core::tests::utils::{
    abi_calls::{approve, balance_of, mint, owner_of, set_approval_for_all, transfer},
    test_helpers::setup,
};
use fuels::prelude::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn transfers() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        let to = Identity::Address(owner2.wallet.address().into());

        mint(1, &owner1.contract, minter.clone()).await;

        assert_eq!(
            owner_of(&owner1.contract, 0).await,
            Option::Some(minter.clone())
        );
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 1);
        assert_eq!(balance_of(&owner2.contract, to.clone()).await, 0);

        transfer(&owner1.contract, to.clone(), 0).await;

        assert_eq!(
            owner_of(&owner1.contract, 0).await,
            Option::Some(to.clone())
        );
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 0);
        assert_eq!(balance_of(&owner2.contract, to.clone()).await, 1);
    }

    #[tokio::test]
    async fn transfers_by_approval() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        let to = Identity::Address(owner2.wallet.address().into());
        let approved_identity = Option::Some(to.clone());

        mint(1, &owner1.contract, minter.clone()).await;

        approve(approved_identity.clone(), &owner1.contract, 0).await;

        assert_eq!(
            owner_of(&owner1.contract, 0).await,
            Option::Some(minter.clone())
        );
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 1);
        assert_eq!(balance_of(&owner2.contract, to.clone()).await, 0);

        transfer(&owner2.contract, to.clone(), 0).await;

        assert_eq!(
            owner_of(&owner1.contract, 0).await,
            Option::Some(to.clone())
        );
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 0);
        assert_eq!(balance_of(&owner2.contract, to.clone()).await, 1);
    }

    #[tokio::test]
    async fn transfers_by_operator() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        let operator = Identity::Address(owner2.wallet.address().into());

        mint(1, &owner1.contract, minter.clone()).await;

        set_approval_for_all(true, &owner1.contract, operator.clone()).await;

        assert_eq!(
            owner_of(&owner1.contract, 0).await,
            Option::Some(minter.clone())
        );
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 1);
        assert_eq!(balance_of(&owner2.contract, operator.clone()).await, 0);

        transfer(&owner2.contract, operator.clone(), 0).await;

        assert_eq!(
            owner_of(&owner1.contract, 0).await,
            Option::Some(operator.clone())
        );
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 0);
        assert_eq!(balance_of(&owner2.contract, operator.clone()).await, 1);
    }

    #[tokio::test]
    async fn transfers_multiple() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        let to = Identity::Address(owner2.wallet.address().into());

        mint(4, &owner1.contract, minter.clone()).await;

        assert_eq!(
            owner_of(&owner1.contract, 0).await,
            Option::Some(minter.clone())
        );
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 4);
        assert_eq!(balance_of(&owner2.contract, to.clone()).await, 0);

        transfer(&owner1.contract, to.clone(), 0).await;

        assert_eq!(
            owner_of(&owner1.contract, 0).await,
            Option::Some(to.clone())
        );
        assert_eq!(
            owner_of(&owner1.contract, 1).await,
            Option::Some(minter.clone())
        );
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 3);
        assert_eq!(balance_of(&owner2.contract, to.clone()).await, 1);

        transfer(&owner1.contract, to.clone(), 1).await;

        assert_eq!(
            owner_of(&owner1.contract, 1).await,
            Option::Some(to.clone())
        );
        assert_eq!(
            owner_of(&owner1.contract, 2).await,
            Option::Some(minter.clone())
        );
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 2);
        assert_eq!(balance_of(&owner2.contract, to.clone()).await, 2);

        transfer(&owner1.contract, to.clone(), 2).await;

        assert_eq!(
            owner_of(&owner1.contract, 2).await,
            Option::Some(to.clone())
        );
        assert_eq!(
            owner_of(&owner1.contract, 3).await,
            Option::Some(minter.clone())
        );
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 1);
        assert_eq!(balance_of(&owner2.contract, to.clone()).await, 3);

        transfer(&owner1.contract, to.clone(), 3).await;

        assert_eq!(
            owner_of(&owner1.contract, 3).await,
            Option::Some(to.clone())
        );
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 0);
        assert_eq!(balance_of(&owner2.contract, to.clone()).await, 4);
    }
}

mod reverts {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "Revert(42)")]
    async fn when_token_does_not_exist() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let to = Identity::Address(owner2.wallet.address().into());
        transfer(&owner1.contract, to.clone(), 0).await;
    }

    #[tokio::test]
    #[should_panic(expected = "Revert(42)")]
    async fn when_sender_is_not_owner_or_approved() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        mint(1, &owner1.contract, minter.clone()).await;

        let to = Identity::Address(owner2.wallet.address().into());
        transfer(&owner2.contract, to.clone(), 0).await;
    }
}
