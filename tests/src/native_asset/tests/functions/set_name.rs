use crate::native_asset::tests::utils::{
    interface::{name, set_name},
    setup::{defaults, get_asset_id, setup, SetNameEvent},
};
use fuels::types::{Bytes32, Identity};

mod success {

    use super::*;

    #[tokio::test]
    async fn sets_one_asset() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let name_1 = String::from("Fuel Asset 1");

        assert_eq!(name(&instance_1, asset_id_1).await, None);

        let response = set_name(&instance_1, asset_id_1, Some(name_1.clone())).await;
        assert_eq!(
            name(&instance_1, asset_id_1).await,
            Some(name_1.clone())
        );
        let log = response
            .decode_logs_with_type::<SetNameEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetNameEvent {
                asset: asset_id_1,
                name: Some(name_1),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );
    }

    #[tokio::test]
    async fn sets_none() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let name_1 = String::from("Fuel Asset 1");

        set_name(&instance_1, asset_id_1, Some(name_1.clone())).await;
        assert_eq!(
            name(&instance_1, asset_id_1).await,
            Some(name_1.clone())
        );

        let response = set_name(&instance_1, asset_id_1, None).await;
        assert_eq!(name(&instance_1, asset_id_1).await, None);
        let log = response
            .decode_logs_with_type::<SetNameEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetNameEvent {
                asset: asset_id_1,
                name: None,
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );
    }

    #[tokio::test]
    async fn sets_name_twice() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let name_1 = String::from("Fuel Asset 1");
        let name_2 = String::from("Fuel Asset 2");

        let response = set_name(&instance_1, asset_id_1, Some(name_1.clone())).await;
        assert_eq!(
            name(&instance_1, asset_id_1).await,
            Some(name_1.clone())
        );
        let log = response
            .decode_logs_with_type::<SetNameEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetNameEvent {
                asset: asset_id_1,
                name: Some(name_1),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );

        let response = set_name(&instance_1, asset_id_1, Some(name_2.clone())).await;
        assert_eq!(
            name(&instance_1, asset_id_1).await,
            Some(name_2.clone())
        );
        let log = response
            .decode_logs_with_type::<SetNameEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetNameEvent {
                asset: asset_id_1,
                name: Some(name_2),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );
    }

    #[tokio::test]
    async fn sets_multiple_assets() {
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
        let response = set_name(&instance_1, asset_id_1, Some(name_1.clone())).await;
        assert_eq!(
            name(&instance_1, asset_id_1).await,
            Some(name_1.clone())
        );
        let log = response
            .decode_logs_with_type::<SetNameEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetNameEvent {
                asset: asset_id_1,
                name: Some(name_1),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );

        assert_eq!(name(&instance_1, asset_id_2).await, None);
        let response = set_name(&instance_1, asset_id_2, Some(name_2.clone())).await;
        assert_eq!(
            name(&instance_1, asset_id_2).await,
            Some(name_2.clone())
        );
        let log = response
            .decode_logs_with_type::<SetNameEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetNameEvent {
                asset: asset_id_2,
                name: Some(name_2),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );

        assert_eq!(name(&instance_1, asset_id_3).await, None);
        let response = set_name(&instance_1, asset_id_3, Some(name_3.clone())).await;
        assert_eq!(
            name(&instance_1, asset_id_3).await,
            Some(name_3.clone())
        );
        let log = response
            .decode_logs_with_type::<SetNameEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetNameEvent {
                asset: asset_id_3,
                name: Some(name_3),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );

        assert_eq!(name(&instance_1, asset_id_4).await, None);
        let response = set_name(&instance_1, asset_id_4, Some(name_4.clone())).await;
        assert_eq!(
            name(&instance_1, asset_id_4).await,
            Some(name_4.clone())
        );
        let log = response
            .decode_logs_with_type::<SetNameEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetNameEvent {
                asset: asset_id_4,
                name: Some(name_4),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );

        assert_eq!(name(&instance_1, asset_id_5).await, None);
        let response = set_name(&instance_1, asset_id_5, Some(name_5.clone())).await;
        assert_eq!(
            name(&instance_1, asset_id_5).await,
            Some(name_5.clone())
        );
        let log = response
            .decode_logs_with_type::<SetNameEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetNameEvent {
                asset: asset_id_5,
                name: Some(name_5),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );
    }

    #[tokio::test]
    async fn does_not_overwrite_other_assets() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let name_1 = String::from("Fuel Asset 1");
        let name_2 = String::from("Fuel Asset 2");
        
        assert_eq!(name(&instance_1, asset_id_1).await, None);
        let response = set_name(&instance_1, asset_id_1, Some(name_1.clone())).await;
        assert_eq!(
            name(&instance_1, asset_id_1).await,
            Some(name_1.clone())
        );
        let log = response
            .decode_logs_with_type::<SetNameEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetNameEvent {
                asset: asset_id_1,
                name: Some(name_1.clone()),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );

        assert_eq!(name(&instance_1, asset_id_2).await, None);
        let response = set_name(&instance_1, asset_id_2, Some(name_2.clone())).await;
        let log = response
            .decode_logs_with_type::<SetNameEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            SetNameEvent {
                asset: asset_id_2,
                name: Some(name_2.clone()),
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );

        assert_eq!(
            name(&instance_1, asset_id_1).await,
            Some(name_1)
        );
        assert_eq!(
            name(&instance_1, asset_id_2).await,
            Some(name_2)
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
        let name_1 = String::from("");

        set_name(&instance_1, asset_id_1, Some(name_1)).await;
    }
}
