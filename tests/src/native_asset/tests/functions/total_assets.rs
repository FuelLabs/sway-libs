use crate::native_asset::tests::utils::{
    interface::{mint, total_assets},
    setup::{defaults, setup},
};
use fuels::types::Bits256;

mod success {

    use super::*;

    #[tokio::test]
    async fn one_asset() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (_asset_id_1, _asset_id_2, sub_id_1, _sub_id_2, _identity1, identity2) =
            defaults(id, owner_wallet, other_wallet.clone());

        assert_eq!(total_assets(&instance_1).await, 0);

        mint(&instance_1, identity2, Some(sub_id_1), 100).await;
        assert_eq!(total_assets(&instance_1).await, 1);
    }

    #[tokio::test]
    async fn multiple_assets() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (_asset_id_1, _asset_id_2, sub_id_1, sub_id_2, _identity1, identity2) =
            defaults(id, owner_wallet, other_wallet.clone());

        assert_eq!(total_assets(&instance_1).await, 0);

        mint(&instance_1, identity2.clone(), Some(sub_id_1), 100).await;
        assert_eq!(total_assets(&instance_1).await, 1);

        mint(&instance_1, identity2.clone(), Some(sub_id_2), 200).await;
        assert_eq!(total_assets(&instance_1).await, 2);

        mint(&instance_1, identity2.clone(), Some(Bits256([3u8; 32])), 300).await;
        assert_eq!(total_assets(&instance_1).await, 3);

        mint(&instance_1, identity2.clone(), Some(Bits256([4u8; 32])), 400).await;
        assert_eq!(total_assets(&instance_1).await, 4);

        mint(&instance_1, identity2, Some(Bits256([5u8; 32])), 200).await;
        assert_eq!(total_assets(&instance_1).await, 5);
    }

    #[tokio::test]
    async fn only_increments_on_new_asset() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (_asset_id_1, _asset_id_2, sub_id_1, _sub_id_2, _identity1, identity2) =
            defaults(id, owner_wallet, other_wallet.clone());

        assert_eq!(total_assets(&instance_1).await, 0);

        mint(&instance_1, identity2.clone(), Some(sub_id_1), 100).await;
        assert_eq!(total_assets(&instance_1).await, 1);

        mint(&instance_1, identity2.clone(), Some(sub_id_1), 100).await;
        assert_eq!(total_assets(&instance_1).await, 1);

        mint(&instance_1, identity2.clone(), Some(sub_id_1), 100).await;
        assert_eq!(total_assets(&instance_1).await, 1);
    }
}
