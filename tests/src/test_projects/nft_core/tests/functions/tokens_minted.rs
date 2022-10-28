use crate::nft_core::tests::utils::{
    abi_calls::{mint, tokens_minted},
    test_helpers::setup,
};
use fuels::prelude::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn gets_tokens_minted() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        assert_eq!(tokens_minted(&owner1.contract).await, 0);

        let minter = Identity::Address(owner1.wallet.address().into());
        mint(1, &owner1.contract, minter.clone()).await;

        assert_eq!(tokens_minted(&owner1.contract).await, 1);
    }

    #[tokio::test]
    async fn gets_tokens_minted_multiple() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        assert_eq!(tokens_minted(&owner1.contract).await, 0);

        let minter = Identity::Address(owner1.wallet.address().into());
        mint(1, &owner1.contract, minter.clone()).await;
        assert_eq!(tokens_minted(&owner1.contract).await, 1);

        mint(1, &owner1.contract, minter.clone()).await;
        assert_eq!(tokens_minted(&owner1.contract).await, 2);

        mint(2, &owner1.contract, minter.clone()).await;
        assert_eq!(tokens_minted(&owner1.contract).await, 4);
    }
}
