use crate::native_asset::tests::utils::{
    interface::{mint, total_assets, total_supply},
    setup::{defaults, get_asset_id, get_wallet_balance, setup, TotalSupplyEvent},
};
use fuels::types::{Bytes32, Identity};

mod success {

    use super::*;

    #[tokio::test]
    async fn mints_assets() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, sub_id_1, _sub_id_2, _identity1, identity2) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let mint_amount = 100;

        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_1).await, 0);
        assert_eq!(total_supply(&instance_1, asset_id_1).await, None);
        assert_eq!(total_assets(&instance_1).await, 0);

        let response = mint(&instance_1, identity2, Some(sub_id_1), mint_amount).await;

        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_1).await, mint_amount);
        assert_eq!(total_supply(&instance_1, asset_id_1).await, Some(mint_amount));
        assert_eq!(total_assets(&instance_1).await, 1);
        let log = response
            .decode_logs_with_type::<TotalSupplyEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            TotalSupplyEvent {
                asset: asset_id_1,
                supply: mint_amount,
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );
    }

    #[tokio::test]
    async fn mints_twice() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, sub_id_1, _sub_id_2, _identity1, identity2) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let mint_amount_1 = 100;
        let mint_amount_2 = 200;

        let response = mint(&instance_1, identity2, Some(sub_id_1), mint_amount_1).await;

        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_1).await, mint_amount_1);
        assert_eq!(total_supply(&instance_1, asset_id_1).await, Some(mint_amount_1));
        assert_eq!(total_assets(&instance_1).await, 1);
        let log = response
            .decode_logs_with_type::<TotalSupplyEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            TotalSupplyEvent {
                asset: asset_id_1,
                supply: mint_amount_1,
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );

        let response = mint(&instance_1, identity2, Some(sub_id_1), mint_amount_2).await;
        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_1).await, mint_amount_1 + mint_amount_2);
        assert_eq!(total_supply(&instance_1, asset_id_1).await, Some(mint_amount_1 + mint_amount_2));
        assert_eq!(total_assets(&instance_1).await, 1);
        let log = response
            .decode_logs_with_type::<TotalSupplyEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            TotalSupplyEvent {
                asset: asset_id_1,
                supply: mint_amount_1 + mint_amount_2,
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );
    }

    #[tokio::test]
    async fn mints_max() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, sub_id_1, _sub_id_2, _identity1, identity2) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let mint_amount = u64::MAX;

        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_1).await, 0);
        assert_eq!(total_supply(&instance_1, asset_id_1).await, None);
        assert_eq!(total_assets(&instance_1).await, 0);

        let response = mint(&instance_1, identity2, Some(sub_id_1), mint_amount).await;

        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_1).await, mint_amount);
        assert_eq!(total_supply(&instance_1, asset_id_1).await, Some(mint_amount));
        assert_eq!(total_assets(&instance_1).await, 1);
        let log = response
            .decode_logs_with_type::<TotalSupplyEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            TotalSupplyEvent {
                asset: asset_id_1,
                supply: mint_amount,
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );
    }

    #[tokio::test]
    async fn mints_sub_id_none_assets() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (_asset_id_1, _asset_id_2, _sub_id_1, _sub_id_2, _identity1, identity2) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let mint_amount = 100;
        let asset_id = get_asset_id(Bytes32::zeroed(), id);

        assert_eq!(get_wallet_balance(&other_wallet, &asset_id).await, 0);
        assert_eq!(total_supply(&instance_1, asset_id).await, None);
        assert_eq!(total_assets(&instance_1).await, 0);

        let response = mint(&instance_1, identity2, None, mint_amount).await;

        assert_eq!(get_wallet_balance(&other_wallet, &asset_id).await, mint_amount);
        assert_eq!(total_supply(&instance_1, asset_id).await, Some(mint_amount));
        assert_eq!(total_assets(&instance_1).await, 1);
        let log = response
            .decode_logs_with_type::<TotalSupplyEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            TotalSupplyEvent {
                asset: asset_id,
                supply: mint_amount,
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );
    }

    #[tokio::test]
    async fn mints_multiple_assets() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (asset_id_1, asset_id_2, sub_id_1, sub_id_2, _identity1, identity2) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let mint_amount_1 = 100;
        let mint_amount_2 = 200;

        let response = mint(&instance_1, identity2.clone(), Some(sub_id_1), mint_amount_1).await;

        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_1).await, mint_amount_1);
        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_2).await, 0);
        assert_eq!(total_supply(&instance_1, asset_id_1).await, Some(mint_amount_1));
        assert_eq!(total_supply(&instance_1, asset_id_2).await, None);
        assert_eq!(total_assets(&instance_1).await, 1);
        let log = response
            .decode_logs_with_type::<TotalSupplyEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            TotalSupplyEvent {
                asset: asset_id_1,
                supply: mint_amount_1,
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );

        let response = mint(&instance_1, identity2, Some(sub_id_2), mint_amount_2).await;

        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_1).await, mint_amount_1);
        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_2).await, mint_amount_2);
        assert_eq!(total_supply(&instance_1, asset_id_1).await, Some(mint_amount_1));
        assert_eq!(total_supply(&instance_1, asset_id_2).await, Some(mint_amount_2));
        assert_eq!(total_assets(&instance_1).await, 2);
        let log = response
            .decode_logs_with_type::<TotalSupplyEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            TotalSupplyEvent {
                asset: asset_id_2,
                supply: mint_amount_2,
                sender: Identity::Address(owner_wallet.address().into()),
            }
        );
    }
}

mod revert {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "ZeroAmount")]
    async fn mints_zero() {
        let (owner_wallet, other_wallet, id, instance_1, _instance_2) = setup().await;
        let (_asset_id_1, _asset_id_2, sub_id_1, _sub_id_2, _identity1, identity2) =
            defaults(id, owner_wallet, other_wallet);
        let mint_amount = 0;

        mint(&instance_1, identity2, Some(sub_id_1), mint_amount).await;
    }
}
