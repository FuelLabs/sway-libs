use crate::nft_extensions::tests::utils::{
    abi_calls::{max_supply, set_max_supply},
    test_helpers::setup,
};

mod success {

    use super::*;

    #[tokio::test]
    async fn sets_max_supply() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        let supply = 10;
        assert_eq!(max_supply(&owner1.contract).await, Option::None);

        set_max_supply(&owner1.contract, Option::Some(supply)).await;

        assert_eq!(max_supply(&owner1.contract).await, Option::Some(supply));
    }
}

mod revert {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "Revert(42)")]
    async fn when_max_supply_already_set() {
        let (_deploy_wallet, owner1, _owner2) = setup().await;

        let supply = 10;
        set_max_supply(&owner1.contract, Option::Some(supply)).await;
        set_max_supply(&owner1.contract, Option::Some(supply)).await;
    }
}
