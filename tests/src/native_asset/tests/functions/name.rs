use crate::native_asset::tests::utils::{
    interface::{name, set_name},
    setup::{defaults, get_asset_id, setup},
};
use fuels::types::Bytes32;

mod success {

    use super::*;

    #[tokio::test]
    async fn get_none_asset_name() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());

        assert_eq!(name(&instance_1, asset_id_1).await, None);
    }

    #[tokio::test]
    async fn get_one_asset_name() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let name_1 = String::from("Fuel Asset 1");

        assert_eq!(name(&instance_1, asset_id_1).await, None);

        set_name(&instance_1, asset_id_1, Some(name_1.clone())).await;
        assert_eq!(name(&instance_1, asset_id_1).await, Some(name_1));
    }

    #[tokio::test]
    async fn get_multiple_assets_name() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let name_1 = String::from("Fuel Asset 1");
        let name_2 = String::from("Fuel Asset 2");
        let name_3 = String::from("Fuel Asset 3 Fuel Asset 3 Fuel Asset 3 Fuel Asset 3 Fuel Asset 3 Fuel Asset 3 Fuel Asset 3 Fuel Asset 3 Fuel Asset 3 Fuel Asset 3 Fuel Asset 3 Fuel Asset 3 Fuel Asset 3 Fuel Asset 3 Fuel Asset 3");
        let name_4 = String::from("4");
        let name_5 = String::from("Fuel Asset 1");
        let asset_id_3 = get_asset_id(Bytes32::from([3u8; 32]), id);
        let asset_id_4 = get_asset_id(Bytes32::from([4u8; 32]), id);
        let asset_id_5 = get_asset_id(Bytes32::from([5u8; 32]), id);

        assert_eq!(name(&instance_1, asset_id_1).await, None);
        assert_eq!(name(&instance_1, asset_id_2).await, None);
        assert_eq!(name(&instance_1, asset_id_3).await, None);
        assert_eq!(name(&instance_1, asset_id_4).await, None);
        assert_eq!(name(&instance_1, asset_id_5).await, None);

        set_name(&instance_1, asset_id_1, Some(name_1.clone())).await;
        set_name(&instance_1, asset_id_2, Some(name_2.clone())).await;
        set_name(&instance_1, asset_id_3, Some(name_3.clone())).await;
        set_name(&instance_1, asset_id_4, Some(name_4.clone())).await;
        set_name(&instance_1, asset_id_5, Some(name_5.clone())).await;

        assert_eq!(name(&instance_1, asset_id_1).await, Some(name_1));
        assert_eq!(name(&instance_1, asset_id_2).await, Some(name_2));
        assert_eq!(name(&instance_1, asset_id_3).await, Some(name_3));
        assert_eq!(name(&instance_1, asset_id_4).await, Some(name_4));
        assert_eq!(name(&instance_1, asset_id_5).await, Some(name_5));
    }
}
