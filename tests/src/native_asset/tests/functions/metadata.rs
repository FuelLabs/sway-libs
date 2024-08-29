use crate::native_asset::tests::utils::{
    interface::{metadata, set_metadata},
    setup::{defaults, get_asset_id, setup, Metadata},
};
use fuels::types::{Bits256, Bytes, Bytes32};

mod success {

    use super::*;

    #[tokio::test]
    async fn gets_none_set() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet, other_wallet.clone());
        let key = String::from("key1");

        assert_eq!(metadata(&instance_1, asset_id_1, key.clone()).await, None);
    }

    #[tokio::test]
    async fn gets_one_asset() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet, other_wallet.clone());
        let metadata1 = Metadata::String(String::from("Fuel NFT Metadata"));
        let key = String::from("key1");

        assert_eq!(metadata(&instance_1, asset_id_1, key.clone()).await, None);

        set_metadata(&instance_1, asset_id_1, key.clone(), Some(metadata1.clone())).await;
        assert_eq!(
            metadata(&instance_1, asset_id_1, key).await,
            Some(metadata1)
        );
    }

    #[tokio::test]
    async fn gets_multiple_assets() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet, other_wallet.clone());
        let metadata1 = Metadata::String(String::from("Fuel NFT Metadata 1"));
        let metadata2 = Metadata::String(String::from("Fuel NFT Metadata 2"));
        let metadata3 = Metadata::String(String::from("Fuel NFT Metadata 3"));
        let asset_id_3 = get_asset_id(Bytes32::from([3u8; 32]), id);
        let key = String::from("key1");

        assert_eq!(metadata(&instance_1, asset_id_1, key.clone()).await, None);
        assert_eq!(metadata(&instance_1, asset_id_2, key.clone()).await, None);
        assert_eq!(metadata(&instance_1, asset_id_3, key.clone()).await, None);
        
        set_metadata(&instance_1, asset_id_1, key.clone(), Some(metadata1.clone())).await;
        set_metadata(&instance_1, asset_id_2, key.clone(), Some(metadata2.clone())).await;
        set_metadata(&instance_1, asset_id_3, key.clone(), Some(metadata3.clone())).await;

        assert_eq!(
            metadata(&instance_1, asset_id_1, key.clone()).await,
            Some(metadata1)
        );
        assert_eq!(
            metadata(&instance_1, asset_id_2, key.clone()).await,
            Some(metadata2)
        );
        assert_eq!(
            metadata(&instance_1, asset_id_3, key).await,
            Some(metadata3)
        );
    }

    #[tokio::test]
    async fn gets_multiple_types() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, _other_identity) =
            defaults(id, owner_wallet, other_wallet.clone());
        let metadata1 = Metadata::String(String::from("Fuel NFT Metadata 1"));
        let metadata2 = Metadata::Int(1);
        let metadata3 = Metadata::Bytes(
            Bytes::from_hex_str("0101010101010101010101010101010101010101010101010101010101010101")
                .expect("failed to convert to bytes"),
        );
        let metadata4 = Metadata::B256(Bits256([1u8; 32]));
        let key1 = String::from("key1");
        let key2 = String::from("key2");
        let key3 = String::from("key3");
        let key4 = String::from("key4");

        assert_eq!(metadata(&instance_1, asset_id_1, key1.clone()).await, None);
        assert_eq!(metadata(&instance_1, asset_id_1, key2.clone()).await, None);
        assert_eq!(metadata(&instance_1, asset_id_1, key3.clone()).await, None);
        assert_eq!(metadata(&instance_1, asset_id_1, key4.clone()).await, None);

        set_metadata(&instance_1, asset_id_1, key1.clone(), Some(metadata1.clone())).await;
        set_metadata(&instance_1, asset_id_1, key2.clone(), Some(metadata2.clone())).await;
        set_metadata(&instance_1, asset_id_1, key3.clone(), Some(metadata3.clone())).await;
        set_metadata(&instance_1, asset_id_1, key4.clone(), Some(metadata4.clone())).await;

        assert_eq!(
            metadata(&instance_1, asset_id_1, key1.clone()).await,
            Some(metadata1)
        );
        assert_eq!(
            metadata(&instance_1, asset_id_1, key2.clone()).await,
            Some(metadata2)
        );
        assert_eq!(
            metadata(&instance_1, asset_id_1, key3).await,
            Some(metadata3)
        );
        assert_eq!(
            metadata(&instance_1, asset_id_1, key4).await,
            Some(metadata4)
        );
    }
}
