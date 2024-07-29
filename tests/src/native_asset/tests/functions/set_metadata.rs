use crate::native_asset::tests::utils::{
    interface::{metadata, set_metadata},
    setup::{defaults, get_asset_id, setup, Metadata, SetMetadataEvent},
};
use fuels::types::{Bytes, Bytes32, Identity};

mod success {

    use super::*;

    #[tokio::test]
    async fn sets_one_asset() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let metadata1 = Metadata::String(String::from("Fuel NFT Metadata"));
        let key = String::from("key1");

        assert_eq!(metadata(&instance_1, asset_id_1, key.clone()).await, None);

        let response = set_metadata(&instance_1, asset_id_1, key.clone(), metadata1.clone()).await;
        assert_eq!(
            metadata(&instance_1, asset_id_1, key.clone()).await,
            Some(metadata1.clone())
        );

        let log = response
            .decode_logs_with_type::<SetMetadataEvent>()
            .unwrap();
        let event = log.first().unwrap();

        assert_eq!(
            *event,
            SetMetadataEvent {
                asset: asset_id_1,
                sender: Identity::Address(owner_wallet.address().into()),
                metadata: metadata1,
                key: key
            }
        );
    }

    #[tokio::test]
    async fn sets_multiple_assets() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let metadata1 = Metadata::String(String::from("Fuel NFT Metadata 1"));
        let metadata2 = Metadata::String(String::from("Fuel NFT Metadata 2"));
        let metadata3 = Metadata::String(String::from("Fuel NFT Metadata 3"));
        let key = String::from("key1");

        assert_eq!(metadata(&instance_1, asset_id_1, key.clone()).await, None);
        let response = set_metadata(&instance_1, asset_id_1, key.clone(), metadata1.clone()).await;
        assert_eq!(
            metadata(&instance_1, asset_id_1, key.clone()).await,
            Some(metadata1.clone())
        );

        let log = response
            .decode_logs_with_type::<SetMetadataEvent>()
            .unwrap();
        let event = log.first().unwrap();

        assert_eq!(
            *event,
            SetMetadataEvent {
                asset: asset_id_1,
                sender: Identity::Address(owner_wallet.address().into()),
                metadata: metadata1,
                key: key.clone()
            }
        );

        assert_eq!(metadata(&instance_1, asset_id_2, key.clone()).await, None);
        let response = set_metadata(&instance_1, asset_id_2, key.clone(), metadata2.clone()).await;
        assert_eq!(
            metadata(&instance_1, asset_id_2, key.clone()).await,
            Some(metadata2.clone())
        );

        let log = response
            .decode_logs_with_type::<SetMetadataEvent>()
            .unwrap();
        let event = log.first().unwrap();

        assert_eq!(
            *event,
            SetMetadataEvent {
                asset: asset_id_2,
                sender: Identity::Address(owner_wallet.address().into()),
                metadata: metadata2,
                key: key.clone()
            }
        );

        let asset_id_3 = get_asset_id(Bytes32::from([3u8; 32]), id);
        assert_eq!(metadata(&instance_1, asset_id_3, key.clone()).await, None);
        let response = set_metadata(&instance_1, asset_id_3, key.clone(), metadata3.clone()).await;
        assert_eq!(
            metadata(&instance_1, asset_id_3, key.clone()).await,
            Some(metadata3.clone())
        );

        let log = response
            .decode_logs_with_type::<SetMetadataEvent>()
            .unwrap();
        let event = log.first().unwrap();

        assert_eq!(
            *event,
            SetMetadataEvent {
                asset: asset_id_3,
                sender: Identity::Address(owner_wallet.address().into()),
                metadata: metadata3,
                key: key
            }
        );
    }

    #[tokio::test]
    async fn does_not_overwrite_other_names() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let metadata1 = Metadata::String(String::from("Fuel NFT Metadata 1"));
        let metadata2 = Metadata::String(String::from("Fuel NFT Metadata 2"));
        let metadata3 = Metadata::String(String::from("Fuel NFT Metadata 3"));
        let key = String::from("key1");

        assert_eq!(metadata(&instance_1, asset_id_1, key.clone()).await, None);
        let response = set_metadata(&instance_1, asset_id_1, key.clone(), metadata1.clone()).await;
        assert_eq!(
            metadata(&instance_1, asset_id_1.clone(), key.clone()).await,
            Some(metadata1.clone())
        );

        let log = response
            .decode_logs_with_type::<SetMetadataEvent>()
            .unwrap();
        let event = log.first().unwrap();

        assert_eq!(
            *event,
            SetMetadataEvent {
                asset: asset_id_1,
                sender: Identity::Address(owner_wallet.address().into()),
                metadata: metadata1.clone(),
                key: key.clone()
            }
        );

        assert_eq!(metadata(&instance_1, asset_id_2, key.clone()).await, None);
        let response = set_metadata(&instance_1, asset_id_2, key.clone(), metadata2.clone()).await;

        assert_eq!(
            metadata(&instance_1, asset_id_1, key.clone()).await,
            Some(metadata1.clone())
        );
        assert_eq!(
            metadata(&instance_1, asset_id_2, key.clone()).await,
            Some(metadata2.clone())
        );

        let log = response
            .decode_logs_with_type::<SetMetadataEvent>()
            .unwrap();
        let event = log.first().unwrap();

        assert_eq!(
            *event,
            SetMetadataEvent {
                asset: asset_id_2,
                sender: Identity::Address(owner_wallet.address().into()),
                metadata: metadata2.clone(),
                key: key.clone()
            }
        );

        let asset_id_3 = get_asset_id(Bytes32::from([3u8; 32]), id);
        assert_eq!(metadata(&instance_1, asset_id_3, key.clone()).await, None);
        let response = set_metadata(&instance_1, asset_id_3, key.clone(), metadata3.clone()).await;

        assert_eq!(
            metadata(&instance_1, asset_id_1, key.clone()).await,
            Some(metadata1)
        );
        assert_eq!(
            metadata(&instance_1, asset_id_2, key.clone()).await,
            Some(metadata2)
        );
        assert_eq!(
            metadata(&instance_1, asset_id_3, key.clone()).await,
            Some(metadata3.clone())
        );

        let log = response
            .decode_logs_with_type::<SetMetadataEvent>()
            .unwrap();
        let event = log.first().unwrap();

        assert_eq!(
            *event,
            SetMetadataEvent {
                asset: asset_id_3,
                sender: Identity::Address(owner_wallet.address().into()),
                metadata: metadata3,
                key: key
            }
        );
    }

    #[tokio::test]
    async fn sets_multiple_types() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let metadata1 = Metadata::String(String::from("Fuel NFT Metadata 1"));
        let metadata2 = Metadata::Int(1);
        let metadata3 = Metadata::Bytes(
            Bytes::from_hex_str("0101010101010101010101010101010101010101010101010101010101010101")
                .expect("failed to convert to bytes"),
        );
        let key1 = String::from("key1");
        let key2 = String::from("key2");
        let key3 = String::from("key3");

        assert_eq!(metadata(&instance_1, asset_id_1, key1.clone()).await, None);
        let response = set_metadata(&instance_1, asset_id_1, key1.clone(), metadata1.clone()).await;
        assert_eq!(
            metadata(&instance_1, asset_id_1, key1.clone()).await,
            Some(metadata1.clone())
        );

        let log = response
            .decode_logs_with_type::<SetMetadataEvent>()
            .unwrap();
        let event = log.first().unwrap();

        assert_eq!(
            *event,
            SetMetadataEvent {
                asset: asset_id_1,
                sender: Identity::Address(owner_wallet.address().into()),
                metadata: metadata1.clone(),
                key: key1.clone()
            }
        );

        assert_eq!(metadata(&instance_1, asset_id_1, key2.clone()).await, None);
        let response = set_metadata(&instance_1, asset_id_1, key2.clone(), metadata2.clone()).await;
        assert_eq!(
            metadata(&instance_1, asset_id_1, key2.clone()).await,
            Some(metadata2.clone())
        );
        assert_eq!(
            metadata(&instance_1, asset_id_1, key1.clone()).await,
            Some(metadata1.clone())
        );

        let log = response
            .decode_logs_with_type::<SetMetadataEvent>()
            .unwrap();
        let event = log.first().unwrap();

        assert_eq!(
            *event,
            SetMetadataEvent {
                asset: asset_id_1,
                sender: Identity::Address(owner_wallet.address().into()),
                metadata: metadata2.clone(),
                key: key2.clone()
            }
        );

        assert_eq!(metadata(&instance_1, asset_id_1, key3.clone()).await, None);
        let response = set_metadata(&instance_1, asset_id_1, key3.clone(), metadata3.clone()).await;
        assert_eq!(
            metadata(&instance_1, asset_id_1, key3.clone()).await,
            Some(metadata3.clone())
        );
        assert_eq!(
            metadata(&instance_1, asset_id_1, key2.clone()).await,
            Some(metadata2)
        );
        assert_eq!(
            metadata(&instance_1, asset_id_1, key1.clone()).await,
            Some(metadata1)
        );

        let log = response
            .decode_logs_with_type::<SetMetadataEvent>()
            .unwrap();
        let event = log.first().unwrap();

        assert_eq!(
            *event,
            SetMetadataEvent {
                asset: asset_id_1,
                sender: Identity::Address(owner_wallet.address().into()),
                metadata: metadata3,
                key: key3
            }
        );
    }
}
