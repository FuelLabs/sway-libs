use fuels::{contract::contract::CallResponse, prelude::*};

// Load abi from json
abigen!(
    TestContract,
    "test_projects/storagemapvec/out/debug/storagemapvec-abi.json"
);

pub mod abi_calls {
    use super::*;

    pub fn push(instance: TestContract, key: u64, value: u64) {
        instance.methods().push()
    }
}

pub mod test_helpers {

    use super::*;

    pub async fn setup() -> TestContract {
        
        let wallet = launch_provider_and_get_wallet().await;

        let contract_id = Contract::deploy(
            "./test_projects/nft_extensions/out/debug/nft_extensions_test.bin",
            &wallet,
            TxParameters::default(),
            StorageConfiguration::default(),
        )
        .await
        .unwrap();

        let instance = TestContract::new(contract_id, wallet);

        instance
    }
}
