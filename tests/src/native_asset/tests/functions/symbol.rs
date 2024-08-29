use crate::native_asset::tests::utils::{
    interface::{set_symbol, symbol},
    setup::{defaults, get_asset_id, setup},
};
use fuels::types::Bytes32;

mod success {

    use super::*;

    #[tokio::test]
    async fn get_none_symbol() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet, other_wallet.clone());

        assert_eq!(symbol(&instance_1, asset_id_1).await, None);
    }

    #[tokio::test]
    async fn get_one_asset_symbol() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet, other_wallet.clone());
        let symbol_1 = String::from("FA1");

        assert_eq!(symbol(&instance_1, asset_id_1).await, None);


        set_symbol(&instance_1, asset_id_1, Some(symbol_1.clone())).await;
        assert_eq!(
            symbol(&instance_1, asset_id_1).await,
            Some(symbol_1)
        );
    }

    #[tokio::test]
    async fn get_multiple_assets_symbols() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet, other_wallet.clone());
        let symbol_1 = String::from("FA1");
        let symbol_2 = String::from("FA2");
        let symbol_3 = String::from("FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1");
        let symbol_4 = String::from("F");
        let symbol_5 = String::from("FA1");
        let asset_id_3 = get_asset_id(Bytes32::from([3u8; 32]), id);
        let asset_id_4 = get_asset_id(Bytes32::from([4u8; 32]), id);
        let asset_id_5 = get_asset_id(Bytes32::from([5u8; 32]), id);

        assert_eq!(symbol(&instance_1, asset_id_1).await, None);
        assert_eq!(symbol(&instance_1, asset_id_2).await, None);
        assert_eq!(symbol(&instance_1, asset_id_3).await, None);
        assert_eq!(symbol(&instance_1, asset_id_4).await, None);
        assert_eq!(symbol(&instance_1, asset_id_5).await, None);

        set_symbol(&instance_1, asset_id_1, Some(symbol_1.clone())).await;
        set_symbol(&instance_1, asset_id_2, Some(symbol_2.clone())).await;
        set_symbol(&instance_1, asset_id_3, Some(symbol_3.clone())).await;
        set_symbol(&instance_1, asset_id_4, Some(symbol_4.clone())).await;
        set_symbol(&instance_1, asset_id_5, Some(symbol_5.clone())).await;

        assert_eq!(
            symbol(&instance_1, asset_id_1).await,
            Some(symbol_1)
        );
        assert_eq!(
            symbol(&instance_1, asset_id_2).await,
            Some(symbol_2)
        );
        assert_eq!(
            symbol(&instance_1, asset_id_3).await,
            Some(symbol_3)
        );
        assert_eq!(
            symbol(&instance_1, asset_id_4).await,
            Some(symbol_4)
        );
        assert_eq!(
            symbol(&instance_1, asset_id_5).await,
            Some(symbol_5)
        );
    }
}
