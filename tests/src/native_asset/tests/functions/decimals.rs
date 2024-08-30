use crate::native_asset::tests::utils::{
    interface::{decimals, set_decimals},
    setup::{defaults, get_asset_id, setup},
};
use fuels::types::Bytes32;

mod success {

    use super::*;

    #[tokio::test]
    async fn one_asset() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet, other_wallet.clone());
        let decimals_1 = 9u8;

        assert_eq!(decimals(&instance_1, asset_id_1).await, None);

        set_decimals(&instance_1, asset_id_1, decimals_1).await;
        assert_eq!(decimals(&instance_1, asset_id_1).await, Some(decimals_1));
    }

    #[tokio::test]
    async fn multiple_assets() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet, other_wallet.clone());
        let decimals_1 = 9u8;
        let decimals_2 = u8::MIN;
        let decimals_3 = u8::MAX;
        let decimals_4 = 16u8;
        let decimals_5 = 9u8;
        let asset_id_3 = get_asset_id(Bytes32::from([3u8; 32]), id);
        let asset_id_4 = get_asset_id(Bytes32::from([4u8; 32]), id);
        let asset_id_5 = get_asset_id(Bytes32::from([5u8; 32]), id);

        assert_eq!(decimals(&instance_1, asset_id_1).await, None);
        assert_eq!(decimals(&instance_1, asset_id_2).await, None);
        assert_eq!(decimals(&instance_1, asset_id_3).await, None);
        assert_eq!(decimals(&instance_1, asset_id_4).await, None);
        assert_eq!(decimals(&instance_1, asset_id_5).await, None);

        set_decimals(&instance_1, asset_id_1, decimals_1).await;
        set_decimals(&instance_1, asset_id_2, decimals_2).await;
        set_decimals(&instance_1, asset_id_3, decimals_3).await;
        set_decimals(&instance_1, asset_id_4, decimals_4).await;
        set_decimals(&instance_1, asset_id_5, decimals_5).await;

        assert_eq!(decimals(&instance_1, asset_id_1).await, Some(decimals_1));
        assert_eq!(decimals(&instance_1, asset_id_2).await, Some(decimals_2));
        assert_eq!(decimals(&instance_1, asset_id_3).await, Some(decimals_3));
        assert_eq!(decimals(&instance_1, asset_id_4).await, Some(decimals_4));
        assert_eq!(decimals(&instance_1, asset_id_5).await, Some(decimals_5));
    }
}
