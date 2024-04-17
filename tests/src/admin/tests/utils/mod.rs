use fuels::{
    prelude::{
        abigen, launch_custom_provider_and_get_wallets, Contract, LoadConfiguration,
        StorageConfiguration, TxPolicies, WalletUnlocked, WalletsConfig,
    },
    programs::call_response::FuelCallResponse,
    types::Identity,
};

// Load abi from json
abigen!(Contract(
    name = "AdminLib",
    abi = "src/admin/out/release/admin_test-abi.json"
));

pub struct Metadata {
    pub contract: AdminLib<WalletUnlocked>,
    pub wallet: WalletUnlocked,
}

pub mod abi_calls {

    use super::*;

    pub async fn add_admin(
        contract: &AdminLib<WalletUnlocked>,
        new_admin: Identity,
    ) -> FuelCallResponse<()> {
        contract
            .methods()
            .add_admin(new_admin)
            .call()
            .await
            .unwrap()
    }

    pub async fn remove_admin(
        contract: &AdminLib<WalletUnlocked>,
        old_admin: Identity,
    ) -> FuelCallResponse<()> {
        contract
            .methods()
            .remove_admin(old_admin)
            .call()
            .await
            .unwrap()
    }

    pub async fn is_admin(contract: &AdminLib<WalletUnlocked>, admin: Identity) -> bool {
        contract
            .methods()
            .is_admin(admin)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn only_admin(contract: &AdminLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().only_admin().call().await.unwrap()
    }

    pub async fn only_owner_or_admin(contract: &AdminLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract
            .methods()
            .only_owner_or_admin()
            .call()
            .await
            .unwrap()
    }

    pub async fn set_ownership(
        contract: &AdminLib<WalletUnlocked>,
        new_owner: Identity,
    ) -> FuelCallResponse<()> {
        contract
            .methods()
            .set_ownership(new_owner)
            .call()
            .await
            .unwrap()
    }
}

pub mod test_helpers {

    use super::*;

    pub async fn setup() -> (Metadata, Metadata, Metadata, Metadata) {
        let num_wallets = 5;
        let coins_per_wallet = 1;
        let coin_amount = 1000000;
        let mut wallets = launch_custom_provider_and_get_wallets(
            WalletsConfig::new(Some(num_wallets), Some(coins_per_wallet), Some(coin_amount)),
            None,
            None,
        )
        .await
        .unwrap();

        // Get the wallets from that provider
        let wallet1 = wallets.pop().unwrap();
        let wallet2 = wallets.pop().unwrap();
        let wallet3 = wallets.pop().unwrap();
        let wallet4 = wallets.pop().unwrap();

        let storage_configuration = StorageConfiguration::default()
            .add_slot_overrides_from_file("src/admin/out/release/admin_test-storage_slots.json");
        let configuration =
            LoadConfiguration::default().with_storage_configuration(storage_configuration.unwrap());
        let id = Contract::load_from("src/admin/out/release/admin_test.bin", configuration)
            .unwrap()
            .deploy(&wallet1, TxPolicies::default())
            .await
            .unwrap();

        let deploy_wallet = Metadata {
            contract: AdminLib::new(id.clone(), wallet1.clone()),
            wallet: wallet1.clone(),
        };

        let owner = Metadata {
            contract: AdminLib::new(id.clone(), wallet2.clone()),
            wallet: wallet2.clone(),
        };

        let admin1 = Metadata {
            contract: AdminLib::new(id.clone(), wallet3.clone()),
            wallet: wallet3.clone(),
        };

        let admin2 = Metadata {
            contract: AdminLib::new(id.clone(), wallet4.clone()),
            wallet: wallet4.clone(),
        };

        (deploy_wallet, owner, admin1, admin2)
    }
}
