use fuels::{
    prelude::{
        abigen, launch_custom_provider_and_get_wallets, Contract, ContractId, LoadConfiguration,
        StorageConfiguration, TxPolicies, WalletUnlocked, WalletsConfig,
    },
    programs::call_response::FuelCallResponse,
};

// Load abi from json
abigen!(Contract(
    name = "UpgradabilityLib",
    abi = "src/upgradability/out/release/upgradability_test-abi.json"
));

pub struct Metadata {
    pub contract: UpgradabilityLib<WalletUnlocked>,
    pub wallet: WalletUnlocked,
}

pub mod abi_calls {

    use super::*;

    pub async fn set_proxy_target(
        contract: &UpgradabilityLib<WalletUnlocked>,
        new_target: ContractId,
    ) -> FuelCallResponse<()> {
        contract
            .methods()
            .set_proxy_target(new_target)
            .call()
            .await
            .unwrap()
    }

    pub async fn proxy_target(
        contract: &UpgradabilityLib<WalletUnlocked>,
    ) -> FuelCallResponse<Option<ContractId>> {
        contract.methods().proxy_target().call().await.unwrap()
    }

    pub async fn proxy_owner(
        contract: &UpgradabilityLib<WalletUnlocked>,
    ) -> FuelCallResponse<State> {
        contract.methods().proxy_owner().call().await.unwrap()
    }

    pub async fn only_proxy_owner(
        contract: &UpgradabilityLib<WalletUnlocked>,
    ) -> FuelCallResponse<()> {
        contract.methods().only_proxy_owner().call().await.unwrap()
    }

    pub async fn set_proxy_owner(
        contract: &UpgradabilityLib<WalletUnlocked>,
        new_proxy_owner: State,
    ) -> FuelCallResponse<()> {
        contract
            .methods()
            .set_proxy_owner(new_proxy_owner)
            .call()
            .await
            .unwrap()
    }

    pub async fn initialize_proxy(
        contract: &UpgradabilityLib<WalletUnlocked>,
    ) -> FuelCallResponse<()> {
        contract.methods().initialize_proxy().call().await.unwrap()
    }
}

pub mod test_helpers {

    use super::*;
    use abi_calls::initialize_proxy;

    pub const INITIAL_TARGET: ContractId = ContractId::zeroed();
    pub const SECOND_TARGET: ContractId = ContractId::new([1u8; 32]);

    pub async fn setup() -> (Metadata, Metadata, Metadata) {
        let num_wallets = 3;
        let coins_per_wallet = 1;
        let coin_amount = 1_000_000;
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

        let storage_configuration = StorageConfiguration::default()
            .add_slot_overrides_from_file(
                "src/upgradability/out/release/upgradability_test-storage_slots.json",
            )
            .unwrap();

        let configurables = UpgradabilityLibConfigurables::default()
            .with_INITIAL_TARGET(Some(INITIAL_TARGET))
            .unwrap()
            .with_INITIAL_OWNER(State::Initialized(wallet2.address().into()))
            .unwrap();

        let configuration = LoadConfiguration::default()
            .with_storage_configuration(storage_configuration)
            .with_configurables(configurables);

        let id = Contract::load_from(
            "src/upgradability/out/release/upgradability_test.bin",
            configuration,
        )
        .unwrap()
        .deploy(&wallet1, TxPolicies::default())
        .await
        .unwrap();

        let deploy_wallet = Metadata {
            contract: UpgradabilityLib::new(id.clone(), wallet1.clone()),
            wallet: wallet1.clone(),
        };

        let owner1 = Metadata {
            contract: UpgradabilityLib::new(id.clone(), wallet2.clone()),
            wallet: wallet2.clone(),
        };

        let owner2 = Metadata {
            contract: UpgradabilityLib::new(id.clone(), wallet3.clone()),
            wallet: wallet3.clone(),
        };

        initialize_proxy(&deploy_wallet.contract).await;

        (deploy_wallet, owner1, owner2)
    }
}
