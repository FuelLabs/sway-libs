use crate::nft_extensions::tests::utils::{
    abi_calls::{meta_data, mint, set_meta_data},
    test_helpers::setup,
    NFTMetaData,
};
use fuels::prelude::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn gets_meta_data() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        let minter = Identity::Address(owner1.wallet.address().into());
        mint(1, &owner1.contract, minter.clone()).await;

        assert_eq!(meta_data(&owner1.contract, 0).await, None);

        let nft_meta_data = NFTMetaData { value: 1 };
        set_meta_data(&owner1.contract, Some(nft_meta_data.clone()), 0).await;

        assert_eq!(meta_data(&owner1.contract, 0).await, Some(nft_meta_data.clone()));
    }

    #[tokio::test]
    async fn get_meta_data_on_token_that_doesnt_exist() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        assert_eq!(meta_data(&owner1.contract, 0).await, None);
    }
}
