use crate::nft_core::tests::utils::{
    abi_calls::{balance_of, mint},
    test_helpers::setup,
};
use fuels::{prelude::Identity, signers::Signer};

mod success {

    use super::*;

    #[tokio::test]
    async fn gets_balance_of_owned() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 0);

        mint(1, &owner1.contract, minter.clone()).await;

        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 1);
    }

    #[tokio::test]
    async fn gets_balance_of_multiple_owned() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 0);
        
        mint(4, &owner1.contract, minter.clone()).await;

        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 4);
    }

    #[tokio::test]
    async fn gets_balance_none_owned() {
        let (_deploy_wallet, owner1, owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        let not_minter = Identity::Address(owner2.wallet.address().into());
        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 0);
        assert_eq!(balance_of(&owner1.contract, not_minter.clone()).await, 0);

        mint(1, &owner1.contract, minter.clone()).await;

        assert_eq!(balance_of(&owner1.contract, minter.clone()).await, 1);
        assert_eq!(balance_of(&owner1.contract, not_minter.clone()).await, 0);
    }
}
