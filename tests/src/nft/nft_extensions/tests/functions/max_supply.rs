use crate::nft::nft_extensions::tests::utils::{
    abi_calls::{max_supply, set_max_supply},
    test_helpers::setup,
};

mod success {

    use super::*;

    #[tokio::test]
    async fn gets_max_supply() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        assert_eq!(max_supply(&owner1.contract).await, None);
    }

    #[tokio::test]
    async fn gets_max_supply_after_update() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        let supply = 10;
        assert_eq!(max_supply(&owner1.contract).await, None);

        set_max_supply(&owner1.contract, Some(supply)).await;

        assert_eq!(max_supply(&owner1.contract).await, Some(supply));
    }
}
