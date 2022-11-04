use crate::nft_extensions::tests::utils::{
    abi_calls::{balance_of, burn, mint, owner_of, tokens_minted},
    test_helpers::setup,
};
use fuels::prelude::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn burns() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        mint(1, &owner1.contract, minter.clone()).await;

        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 1);
        assert_eq!(
            owner_of(&owner1.contract, 0).await,
            Some(minter.clone())
        );
        assert_eq!(tokens_minted(&owner1.contract).await, 1);

        burn(&owner1.contract, 0).await;

        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 0);
        assert_eq!(owner_of(&owner1.contract, 0).await, None);
        assert_eq!(tokens_minted(&owner1.contract).await, 1);
    }
}

mod revert {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "Revert(18446744073709486080)")]
    async fn when_token_does_not_exist() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        burn(&owner1.contract, 0).await;
    }

    #[tokio::test]
    #[should_panic(expected = "Revert(18446744073709486080)")]
    async fn when_sender_not_owner() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        mint(1, &owner1.contract, minter.clone()).await;

        burn(&owner2.contract, 0).await;
    }
}
