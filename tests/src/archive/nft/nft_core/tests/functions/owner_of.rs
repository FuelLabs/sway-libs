use crate::nft::nft_core::tests::utils::{
    abi_calls::{mint, owner_of},
    test_helpers::setup,
};
use fuels::types::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn gets_owner_of() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        assert_eq!(owner_of(&owner1.contract, 0).await, Option::None);

        mint(1, &owner1.contract, minter.clone()).await;

        assert_eq!(
            owner_of(&owner1.contract, 0).await,
            Option::Some(minter.clone())
        );
    }

    #[tokio::test]
    async fn gets_owner_of_multiple() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let minter1 = Identity::Address(owner1.wallet.address().into());
        let minter2 = Identity::Address(owner2.wallet.address().into());
        assert_eq!(owner_of(&owner1.contract, 0).await, Option::None);
        assert_eq!(owner_of(&owner1.contract, 1).await, Option::None);

        mint(1, &owner1.contract, minter1.clone()).await;
        mint(1, &owner1.contract, minter2.clone()).await;

        assert_eq!(
            owner_of(&owner1.contract, 0).await,
            Option::Some(minter1.clone())
        );
        assert_eq!(
            owner_of(&owner1.contract, 1).await,
            Option::Some(minter2.clone())
        );
    }

    #[tokio::test]
    async fn gets_owner_of_none() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        assert_eq!(owner_of(&owner1.contract, 0).await, Option::None);
    }
}
