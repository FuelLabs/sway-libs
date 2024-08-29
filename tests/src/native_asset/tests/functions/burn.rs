use crate::native_asset::tests::utils::{
    interface::{burn, mint, total_assets, total_supply},
    setup::{defaults, get_wallet_balance, setup, TotalSupplyEvent},
};
use fuels::types::Identity;

mod success {

    use super::*;

    #[tokio::test]
    async fn burn_assets() {
        let (owner_wallet, other_wallet, id, instance_1, instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, sub_id_1, _sub_id_2, _owner_identity, identity2) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let mint_amount_1 = 100;
        let burn_amount_1 = 25;

        assert!(mint_amount_1 >= burn_amount_1);

        mint(&instance_1, identity2, Some(sub_id_1), mint_amount_1).await;

        assert_eq!(
            get_wallet_balance(&other_wallet, &asset_id_1).await,
            mint_amount_1
        );
        assert_eq!(
            total_supply(&instance_1, asset_id_1).await,
            Some(mint_amount_1)
        );
        assert_eq!(total_assets(&instance_1).await, 1);

        let response = burn(&instance_2, asset_id_1, sub_id_1, burn_amount_1).await;

        assert_eq!(
            get_wallet_balance(&other_wallet, &asset_id_1).await,
            mint_amount_1 - burn_amount_1
        );
        assert_eq!(
            total_supply(&instance_1, asset_id_1).await,
            Some(mint_amount_1 - burn_amount_1)
        );
        assert_eq!(total_assets(&instance_1).await, 1);
        let log = response
            .decode_logs_with_type::<TotalSupplyEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            TotalSupplyEvent {
                asset: asset_id_1,
                supply: mint_amount_1 - burn_amount_1,
                sender: Identity::Address(other_wallet.address().into()),
            }
        );
    }

    #[tokio::test]
    async fn burn_twice() {
        let (owner_wallet, other_wallet, id, instance_1, instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, sub_id_1, _sub_id_2, _owner_identity, identity2) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let mint_amount_1 = 100;
        let burn_amount_1 = 25;
        let burn_amount_2 = 30;
        let burn_amount_3 = 3;

        assert!(mint_amount_1 >= burn_amount_1 + burn_amount_2 + burn_amount_3);

        mint(&instance_1, identity2, Some(sub_id_1), mint_amount_1).await;

        assert_eq!(
            get_wallet_balance(&other_wallet, &asset_id_1).await,
            mint_amount_1
        );
        assert_eq!(
            total_supply(&instance_1, asset_id_1).await,
            Some(mint_amount_1)
        );
        assert_eq!(total_assets(&instance_1).await, 1);

        let response = burn(&instance_2, asset_id_1, sub_id_1, burn_amount_1).await;
        assert_eq!(
            get_wallet_balance(&other_wallet, &asset_id_1).await,
            mint_amount_1 - burn_amount_1
        );
        assert_eq!(
            total_supply(&instance_1, asset_id_1).await,
            Some(mint_amount_1 - burn_amount_1)
        );
        assert_eq!(total_assets(&instance_1).await, 1);
        let log = response
            .decode_logs_with_type::<TotalSupplyEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            TotalSupplyEvent {
                asset: asset_id_1,
                supply: mint_amount_1 - burn_amount_1,
                sender: Identity::Address(other_wallet.address().into()),
            }
        );

        let response = burn(&instance_2, asset_id_1, sub_id_1, burn_amount_2).await;
        assert_eq!(
            get_wallet_balance(&other_wallet, &asset_id_1).await,
            mint_amount_1 - burn_amount_1 - burn_amount_2
        );
        assert_eq!(
            total_supply(&instance_1, asset_id_1).await,
            Some(mint_amount_1 - burn_amount_1 - burn_amount_2)
        );
        assert_eq!(total_assets(&instance_1).await, 1);
        let log = response
            .decode_logs_with_type::<TotalSupplyEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            TotalSupplyEvent {
                asset: asset_id_1,
                supply: mint_amount_1 - burn_amount_1 - burn_amount_2,
                sender: Identity::Address(other_wallet.address().into()),
            }
        );

        let response = burn(&instance_2, asset_id_1, sub_id_1, burn_amount_3).await;
        assert_eq!(
            get_wallet_balance(&other_wallet, &asset_id_1).await,
            mint_amount_1 - burn_amount_1 - burn_amount_2 - burn_amount_3
        );
        assert_eq!(
            total_supply(&instance_1, asset_id_1).await,
            Some(mint_amount_1 - burn_amount_1 - burn_amount_2 - burn_amount_3)
        );
        assert_eq!(total_assets(&instance_1).await, 1);
        let log = response
            .decode_logs_with_type::<TotalSupplyEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            TotalSupplyEvent {
                asset: asset_id_1,
                supply: mint_amount_1 - burn_amount_1 - burn_amount_2 - burn_amount_3,
                sender: Identity::Address(other_wallet.address().into()),
            }
        );
    }

    #[tokio::test]
    async fn burns_multiple_assets() {
        let (owner_wallet, other_wallet, id, instance_1, instance_2) = setup().await;
        let (asset_id_1, asset_id_2, sub_id_1, sub_id_2, _owner_identity, identity2) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let mint_amount_1 = 100;
        let mint_amount_2 = 200;
        let burn_amount_1 = 25;
        let burn_amount_2 = 150;

        assert!(mint_amount_1 >= burn_amount_1);
        assert!(mint_amount_2 >= burn_amount_2);

        mint(
            &instance_1,
            identity2.clone(),
            Some(sub_id_1),
            mint_amount_1,
        )
        .await;
        mint(&instance_1, identity2, Some(sub_id_2), mint_amount_2).await;

        assert_eq!(
            get_wallet_balance(&other_wallet, &asset_id_1).await,
            mint_amount_1
        );
        assert_eq!(
            get_wallet_balance(&other_wallet, &asset_id_2).await,
            mint_amount_2
        );
        assert_eq!(
            total_supply(&instance_1, asset_id_1).await,
            Some(mint_amount_1)
        );
        assert_eq!(
            total_supply(&instance_1, asset_id_2).await,
            Some(mint_amount_2)
        );
        assert_eq!(total_assets(&instance_1).await, 2);

        let response = burn(&instance_2, asset_id_1, sub_id_1, burn_amount_1).await;

        assert_eq!(
            get_wallet_balance(&other_wallet, &asset_id_1).await,
            mint_amount_1 - burn_amount_1
        );
        assert_eq!(
            get_wallet_balance(&other_wallet, &asset_id_2).await,
            mint_amount_2
        );
        assert_eq!(
            total_supply(&instance_1, asset_id_1).await,
            Some(mint_amount_1 - burn_amount_1)
        );
        assert_eq!(
            total_supply(&instance_1, asset_id_2).await,
            Some(mint_amount_2)
        );
        assert_eq!(total_assets(&instance_1).await, 2);
        let log = response
            .decode_logs_with_type::<TotalSupplyEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            TotalSupplyEvent {
                asset: asset_id_1,
                supply: mint_amount_1 - burn_amount_1,
                sender: Identity::Address(other_wallet.address().into()),
            }
        );

        let response = burn(&instance_2, asset_id_2, sub_id_2, burn_amount_2).await;

        assert_eq!(
            get_wallet_balance(&other_wallet, &asset_id_1).await,
            mint_amount_1 - burn_amount_1
        );
        assert_eq!(
            get_wallet_balance(&other_wallet, &asset_id_2).await,
            mint_amount_2 - burn_amount_2
        );
        assert_eq!(
            total_supply(&instance_1, asset_id_1).await,
            Some(mint_amount_1 - burn_amount_1)
        );
        assert_eq!(
            total_supply(&instance_1, asset_id_2).await,
            Some(mint_amount_2 - burn_amount_2)
        );
        assert_eq!(total_assets(&instance_1).await, 2);
        let log = response
            .decode_logs_with_type::<TotalSupplyEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            TotalSupplyEvent {
                asset: asset_id_2,
                supply: mint_amount_2 - burn_amount_2,
                sender: Identity::Address(other_wallet.address().into()),
            }
        );
    }

    #[tokio::test]
    async fn burn_to_zero() {
        let (owner_wallet, other_wallet, id, instance_1, instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, sub_id_1, _sub_id_2, _owner_identity, identity2) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let mint_amount_1 = 100;
        let burn_amount_1 = 100;

        assert!(mint_amount_1 == burn_amount_1);

        mint(&instance_1, identity2, Some(sub_id_1), mint_amount_1).await;

        assert_eq!(
            get_wallet_balance(&other_wallet, &asset_id_1).await,
            mint_amount_1
        );
        assert_eq!(
            total_supply(&instance_1, asset_id_1).await,
            Some(mint_amount_1)
        );
        assert_eq!(total_assets(&instance_1).await, 1);

        let response = burn(&instance_2, asset_id_1, sub_id_1, burn_amount_1).await;

        assert_eq!(get_wallet_balance(&other_wallet, &asset_id_1).await, 0);
        assert_eq!(total_supply(&instance_1, asset_id_1).await, Some(0));
        assert_eq!(total_assets(&instance_1).await, 1);
        let log = response
            .decode_logs_with_type::<TotalSupplyEvent>()
            .unwrap();
        let event = log.first().unwrap();
        assert_eq!(
            *event,
            TotalSupplyEvent {
                asset: asset_id_1,
                supply: 0,
                sender: Identity::Address(other_wallet.address().into()),
            }
        );
    }
}

mod revert {

    use super::*;
    use fuels::{
        prelude::{CallParameters, TxPolicies},
        types::AssetId,
    };

    #[tokio::test]
    #[should_panic(expected = "NotEnoughCoins")]
    async fn when_not_enough_coins_in_transaction() {
        let (owner_wallet, other_wallet, id, instance_1, instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, sub_id_1, _sub_id_2, _identity1, identity2) =
            defaults(id, owner_wallet, other_wallet.clone());
        let mint_amount = 100;
        let sent_burn_amount = 50;
        let claimed_burn_amount = 75;

        assert!(sent_burn_amount < claimed_burn_amount);

        mint(&instance_1, identity2, Some(sub_id_1), mint_amount).await;

        let call_params = CallParameters::new(sent_burn_amount, asset_id_1, 1_000_000);
        instance_2
            .methods()
            .burn(sub_id_1, claimed_burn_amount)
            .with_tx_policies(TxPolicies::default().with_script_gas_limit(2_000_000))
            .call_params(call_params)
            .unwrap()
            .call()
            .await
            .unwrap();
    }

    #[tokio::test]
    #[should_panic(expected = "NotEnoughCoins")]
    async fn when_greater_than_supply() {
        let (owner_wallet, other_wallet, id, instance_1, instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, sub_id_1, _sub_id_2, _identity1, identity2) =
            defaults(id, owner_wallet, other_wallet.clone());
        let mint_amount = 100;
        let sent_burn_amount = 100;
        let claimed_burn_amount = 150;

        assert!(mint_amount < claimed_burn_amount);

        mint(&instance_1, identity2, Some(sub_id_1), mint_amount).await;

        let call_params = CallParameters::new(sent_burn_amount, asset_id_1, 1_000_000);
        instance_2
            .methods()
            .burn(sub_id_1, claimed_burn_amount)
            .with_tx_policies(TxPolicies::default().with_script_gas_limit(2_000_000))
            .call_params(call_params)
            .unwrap()
            .call()
            .await
            .unwrap();
    }

    #[tokio::test]
    #[should_panic(expected = "NotEnoughCoins")]
    async fn when_invalid_sub_id() {
        let (owner_wallet, other_wallet, id, instance_1, instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, sub_id_1, sub_id_2, _identity1, identity2) =
            defaults(id, owner_wallet, other_wallet.clone());
        let mint_amount = 100;
        let sent_burn_amount = 50;
        let claimed_burn_amount = 50;

        assert!(sent_burn_amount == claimed_burn_amount);

        mint(&instance_1, identity2, Some(sub_id_1), mint_amount).await;

        let call_params = CallParameters::new(sent_burn_amount, asset_id_1, 1_000_000);
        instance_2
            .methods()
            .burn(sub_id_2, claimed_burn_amount)
            .with_tx_policies(TxPolicies::default().with_script_gas_limit(2_000_000))
            .call_params(call_params)
            .unwrap()
            .call()
            .await
            .unwrap();
    }

    #[tokio::test]
    #[should_panic(expected = "NotEnoughCoins")]
    async fn when_invalid_asset() {
        let (owner_wallet, other_wallet, id, instance_1, instance_2) = setup().await;
        let (_asset_id_1, _asset_id_2, sub_id_1, _sub_id_2, _identity1, identity2) =
            defaults(id, owner_wallet, other_wallet.clone());
        let mint_amount = 100;
        let sent_burn_amount = 50;
        let claimed_burn_amount = 50;

        assert!(sent_burn_amount == claimed_burn_amount);

        mint(&instance_1, identity2, Some(sub_id_1), mint_amount).await;

        let call_params = CallParameters::new(sent_burn_amount, AssetId::zeroed(), 1_000_000);
        instance_2
            .methods()
            .burn(sub_id_1, claimed_burn_amount)
            .with_tx_policies(TxPolicies::default().with_script_gas_limit(2_000_000))
            .call_params(call_params)
            .unwrap()
            .call()
            .await
            .unwrap();
    }

    #[tokio::test]
    #[should_panic(expected = "ZeroAmount")]
    async fn when_burn_zero() {
        let (owner_wallet, other_wallet, id, instance_1, instance_2) = setup().await;
        let (asset_id_1, _asset_id_2, sub_id_1, _sub_id_2, _owner_identity, identity2) =
            defaults(id, owner_wallet.clone(), other_wallet.clone());
        let mint_amount_1 = 100;
        let burn_amount_1 = 0;

        assert!(burn_amount_1 == 0);

        mint(&instance_1, identity2, Some(sub_id_1), mint_amount_1).await;

        burn(&instance_2, asset_id_1, sub_id_1, burn_amount_1).await;
    }
}
