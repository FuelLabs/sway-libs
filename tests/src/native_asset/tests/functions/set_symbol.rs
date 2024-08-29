use crate::native_asset::tests::utils::{
    interface::{set_symbol, symbol},
    setup::{defaults, get_asset_id, setup, SetSymbolEvent},
};
use fuels::types::{Bytes32, Identity};

mod success {

    use super::*;

    #[tokio::test]
    async fn sets_one_asset() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let symbol_1 = String::from("FA1");

        assert_eq!(symbol(&instance_1, asset_id_1).await, None);

        let response = set_symbol(&instance_1, asset_id_1, Some(symbol_1.clone())).await;
        assert_eq!(
            symbol(&instance_1, asset_id_1).await,
            Some(symbol_1.clone())
        );
        let log = response
            .decode_logs_with_type::<SetSymbolEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetSymbolEvent {
                asset: asset_id_1,
                symbol: Some(symbol_1),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );
    }

    #[tokio::test]
    async fn sets_none() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let symbol_1 = String::from("FA1");

        set_symbol(&instance_1, asset_id_1, Some(symbol_1.clone())).await;
        assert_eq!(
            symbol(&instance_1, asset_id_1).await,
            Some(symbol_1.clone())
        );

        let response = set_symbol(&instance_1, asset_id_1, None).await;
        assert_eq!(symbol(&instance_1, asset_id_1).await, None);
        let log = response
            .decode_logs_with_type::<SetSymbolEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetSymbolEvent {
                asset: asset_id_1,
                symbol: None,
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );
    }

    #[tokio::test]
    async fn sets_symbol_twice() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let symbol_1 = String::from("FA1");
        let symbol_2 = String::from("FA2");


        let response = set_symbol(&instance_1, asset_id_1, Some(symbol_1.clone())).await;
        assert_eq!(
            symbol(&instance_1, asset_id_1).await,
            Some(symbol_1.clone())
        );
        let log = response
            .decode_logs_with_type::<SetSymbolEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetSymbolEvent {
                asset: asset_id_1,
                symbol: Some(symbol_1),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );

        let response = set_symbol(&instance_1, asset_id_1, Some(symbol_2.clone())).await;
        assert_eq!(
            symbol(&instance_1, asset_id_1).await,
            Some(symbol_2.clone())
        );
        let log = response
            .decode_logs_with_type::<SetSymbolEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetSymbolEvent {
                asset: asset_id_1,
                symbol: Some(symbol_2),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );
    }

    #[tokio::test]
    async fn sets_multiple_assets() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let symbol_1 = String::from("FA1");
        let symbol_2 = String::from("FA2");
        let symbol_3 = String::from("FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1FA1");
        let symbol_4 = String::from("F");
        let symbol_5 = String::from("FA1");
        let asset_id_3 = get_asset_id(Bytes32::from([3u8; 32]), id);
        let asset_id_4 = get_asset_id(Bytes32::from([4u8; 32]), id);
        let asset_id_5 = get_asset_id(Bytes32::from([5u8; 32]), id);

        assert_eq!(symbol(&instance_1, asset_id_1).await, None);
        let response = set_symbol(&instance_1, asset_id_1, Some(symbol_1.clone())).await;
        assert_eq!(
            symbol(&instance_1, asset_id_1).await,
            Some(symbol_1.clone())
        );
        let log = response
            .decode_logs_with_type::<SetSymbolEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetSymbolEvent {
                asset: asset_id_1,
                symbol: Some(symbol_1),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );

        assert_eq!(symbol(&instance_1, asset_id_2).await, None);
        let response = set_symbol(&instance_1, asset_id_2, Some(symbol_2.clone())).await;
        assert_eq!(
            symbol(&instance_1, asset_id_2).await,
            Some(symbol_2.clone())
        );
        let log = response
            .decode_logs_with_type::<SetSymbolEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetSymbolEvent {
                asset: asset_id_2,
                symbol: Some(symbol_2),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );

        assert_eq!(symbol(&instance_1, asset_id_3).await, None);
        let response = set_symbol(&instance_1, asset_id_3, Some(symbol_3.clone())).await;
        assert_eq!(
            symbol(&instance_1, asset_id_3).await,
            Some(symbol_3.clone())
        );
        let log = response
            .decode_logs_with_type::<SetSymbolEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetSymbolEvent {
                asset: asset_id_3,
                symbol: Some(symbol_3),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );

        assert_eq!(symbol(&instance_1, asset_id_4).await, None);
        let response = set_symbol(&instance_1, asset_id_4, Some(symbol_4.clone())).await;
        assert_eq!(
            symbol(&instance_1, asset_id_4).await,
            Some(symbol_4.clone())
        );
        let log = response
            .decode_logs_with_type::<SetSymbolEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetSymbolEvent {
                asset: asset_id_4,
                symbol: Some(symbol_4),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );

        assert_eq!(symbol(&instance_1, asset_id_5).await, None);
        let response = set_symbol(&instance_1, asset_id_5, Some(symbol_5.clone())).await;
        assert_eq!(
            symbol(&instance_1, asset_id_5).await,
            Some(symbol_5.clone())
        );
        let log = response
            .decode_logs_with_type::<SetSymbolEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetSymbolEvent {
                asset: asset_id_5,
                symbol: Some(symbol_5),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );
    }

    #[tokio::test]
    async fn does_not_overwrite_other_assets() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let symbol_1 = String::from("FA1");
        let symbol_2 = String::from("FA2");

        assert_eq!(symbol(&instance_1, asset_id_1).await, None);
        let response = set_symbol(&instance_1, asset_id_1, Some(symbol_1.clone())).await;
        assert_eq!(
            symbol(&instance_1, asset_id_1).await,
            Some(symbol_1.clone())
        );
        let log = response
            .decode_logs_with_type::<SetSymbolEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetSymbolEvent {
                asset: asset_id_1,
                symbol: Some(symbol_1.clone()),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );

        assert_eq!(symbol(&instance_1, asset_id_2).await, None);
        let response = set_symbol(&instance_1, asset_id_2, Some(symbol_2.clone())).await;
        let log = response
            .decode_logs_with_type::<SetSymbolEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetSymbolEvent {
                asset: asset_id_2,
                symbol: Some(symbol_2.clone()),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );

        assert_eq!(
            symbol(&instance_1, asset_id_1).await,
            Some(symbol_1)
        );
        assert_eq!(
            symbol(&instance_1, asset_id_2).await,
            Some(symbol_2)
        );
    }
}

mod revert {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "EmptyString")]
    async fn when_empty_string() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet, other_wallet);
        let symbol_1 = String::from("");

        set_symbol(&instance_1, asset_id_1, Some(symbol_1)).await;
    }
}
