use crate::native_asset::tests::utils::{
    interface::{mint, total_assets, total_supply},
    setup::{defaults, get_wallet_balance, setup},
};

mod success {

    use super::*;

    #[tokio::test]
    async fn mints_assets() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, sub_id_1, _sub_id_2, _identity1, identity2) =
            defaults(id, owner_wallet, other_wallet.clone());

        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_1).await, 0);
        assert_eq!(total_supply(&instance_1, asset_id_1).await, None);
        assert_eq!(total_assets(&instance_1).await, 0);

        mint(&instance_1, identity2, sub_id_1, 100).await;

        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_1).await, 100);
        assert_eq!(total_supply(&instance_1, asset_id_1).await, Some(100));
        assert_eq!(total_assets(&instance_1).await, 1);
    }

    #[tokio::test]
    async fn mints_multiple_assets() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, asset_id_2, sub_id_1, sub_id_2, _identity1, identity2) =
            defaults(id, owner_wallet, other_wallet.clone());

        mint(&instance_1, identity2.clone(), sub_id_1, 100).await;

        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_1).await, 100);
        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_2).await, 0);
        assert_eq!(total_supply(&instance_1, asset_id_1).await, Some(100));
        assert_eq!(total_supply(&instance_1, asset_id_2).await, None);
        assert_eq!(total_assets(&instance_1).await, 1);

        mint(&instance_1, identity2, sub_id_2, 200).await;

        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_1).await, 100);
        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_2).await, 200);
        assert_eq!(total_supply(&instance_1, asset_id_1).await, Some(100));
        assert_eq!(total_supply(&instance_1, asset_id_2).await, Some(200));
        assert_eq!(total_assets(&instance_1).await, 2);
    }
}
