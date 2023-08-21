use crate::nft::nft_core::tests::utils::{
    abi_calls::{approved, balance_of, mint, owner_of, tokens_minted},
    test_helpers::setup,
};
use fuels::types::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn mints() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        assert_eq!(tokens_minted(&owner1.contract).await, 0);
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 0);
        assert_eq!(owner_of(&owner1.contract, 0).await, Option::None);

        mint(1, &owner1.contract, minter.clone()).await;

        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 1);
        assert_eq!(
            owner_of(&owner1.contract, 0).await,
            Option::Some(minter.clone())
        );
        assert_eq!(approved(&owner1.contract, 0).await, Option::None);
        assert_eq!(tokens_minted(&owner1.contract).await, 1);
    }

    #[tokio::test]
    async fn mints_multiple() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        assert_eq!(tokens_minted(&owner1.contract).await, 0);
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 0);
        assert_eq!(owner_of(&owner1.contract, 0).await, Option::None);
        assert_eq!(owner_of(&owner1.contract, 1).await, Option::None);
        assert_eq!(owner_of(&owner1.contract, 2).await, Option::None);
        assert_eq!(owner_of(&owner1.contract, 3).await, Option::None);

        mint(4, &owner1.contract, minter.clone()).await;

        assert_eq!(tokens_minted(&owner1.contract).await, 4);
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 4);
        assert_eq!(
            owner_of(&owner1.contract, 0).await,
            Option::Some(minter.clone())
        );
        assert_eq!(
            owner_of(&owner1.contract, 1).await,
            Option::Some(minter.clone())
        );
        assert_eq!(
            owner_of(&owner1.contract, 2).await,
            Option::Some(minter.clone())
        );
        assert_eq!(
            owner_of(&owner1.contract, 3).await,
            Option::Some(minter.clone())
        );
    }

    #[tokio::test]
    async fn mint_amount_is_zero() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 0);
        assert_eq!(tokens_minted(&owner1.contract).await, 0);
        assert_eq!(owner_of(&owner1.contract, 0).await, Option::None);

        mint(0, &owner1.contract, minter.clone()).await;

        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 0);
        assert_eq!(tokens_minted(&owner1.contract).await, 0);
        assert_eq!(owner_of(&owner1.contract, 0).await, Option::None);
    }
}
