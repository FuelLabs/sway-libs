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
    name = "OwnershipLib",
    abi = "src/ownership/out/release/ownership_test-abi.json"
));

pub struct Metadata {
    pub contract: OwnershipLib<WalletUnlocked>,
    pub wallet: WalletUnlocked,
}

pub mod abi_calls {

    use super::*;

    pub async fn only_owner(contract: &OwnershipLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().only_owner().call().await.unwrap()
    }

    pub async fn owner(contract: &OwnershipLib<WalletUnlocked>) -> State {
        contract.methods().owner().call().await.unwrap().value
    }

    pub async fn renounce_ownership(
        contract: &OwnershipLib<WalletUnlocked>,
    ) -> FuelCallResponse<()> {
        contract
            .methods()
            .renounce_ownership()
            .call()
            .await
            .unwrap()
    }

    pub async fn set_ownership(
        contract: &OwnershipLib<WalletUnlocked>,
        new_owner: Identity,
    ) -> FuelCallResponse<()> {
        contract
            .methods()
            .set_ownership(new_owner)
            .call()
            .await
            .unwrap()
    }

    pub async fn transfer_ownership(
        contract: &OwnershipLib<WalletUnlocked>,
        new_owner: Identity,
    ) -> FuelCallResponse<()> {
        contract
            .methods()
            .transfer_ownership(new_owner)
            .call()
            .await
            .unwrap()
    }
}

pub mod test_helpers {

    use super::*;

    pub async fn setup() -> (Metadata, Metadata, Metadata) {
        let num_wallets = 4;
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

        let storage_configuration = StorageConfiguration::default().add_slot_overrides_from_file(
            "src/ownership/out/release/ownership_test-storage_slots.json",
        );
        let configuration =
            LoadConfiguration::default().with_storage_configuration(storage_configuration.unwrap());
        let id = Contract::load_from(
            "src/ownership/out/release/ownership_test.bin",
            configuration,
        )
        .unwrap()
        .deploy(&wallet1, TxPolicies::default())
        .await
        .unwrap();

        let deploy_wallet = Metadata {
            contract: OwnershipLib::new(id.clone(), wallet1.clone()),
            wallet: wallet1.clone(),
        };

        let owner1 = Metadata {
            contract: OwnershipLib::new(id.clone(), wallet2.clone()),
            wallet: wallet2.clone(),
        };

        let owner2 = Metadata {
            contract: OwnershipLib::new(id.clone(), wallet3.clone()),
            wallet: wallet3.clone(),
        };

        (deploy_wallet, owner1, owner2)
    }
}
