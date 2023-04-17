use fuels::{
    prelude::{
        abigen, launch_custom_provider_and_get_wallets, Contract, StorageConfiguration,
        TxParameters, WalletsConfig,
    },
    programs::call_response::FuelCallResponse,
};

// Load abi from json
abigen!(Contract(
    name = "StorageStringTest",
    abi = "src/storage_string/out/debug/storage_string_test-abi.json"
));

pub mod abi_calls {

    use super::*;

    pub async fn clear_string(contract: &StorageStringTest) -> bool {
        contract.methods().clear_string().call().await.unwrap().value
    }

    pub async fn get_string(contract: &StorageStringTest) -> String {
        contract.methods().get_string().call().await.unwrap().value
    }

    pub async fn store_string(string: String, contract: &StorageStringTest) -> FuelCallResponse<()> {
        contract.methods().store_string(string).call().await.unwrap()
    }

    pub async fn stored_len(contract: &StorageStringTest) -> bool {
        contract.methods().stored_len().call().await.unwrap().value
    }
}

pub mod test_helpers {

    use super::*;

    pub async fn setup() -> StorageStringTest {
        // Launch a local network and deploy the contract
        let mut wallets = launch_custom_provider_and_get_wallets(
            WalletsConfig::new(
                Some(1),             /* Single wallet */
                Some(1),             /* Single coin (UTXO) */
                Some(1_000_000_000), /* Amount per coin */
            ),
            None,
            None,
        )
        .await;
        let wallet = wallets.pop().unwrap();

        let id = Contract::deploy(
            "src/storage_string/out/debug/storage_string_test.bin",
            &wallet,
            TxParameters::default(),
            StorageConfiguration::with_storage_path(Some("src/storage_string/out/debug/storage_string_test-storage_slots.json".to_string())),
        )
        .await
        .unwrap();

        let instance = StorageStringTest::new(id.clone(), wallet);

        instance
    }
}
