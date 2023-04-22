use fuels::prelude::{
    abigen, launch_provider_and_get_wallet, Contract, LoadConfiguration, StorageConfiguration,
    TxParameters, WalletUnlocked,
};

// Load abi from json
abigen!(Contract(
    name = "TestContract",
    abi = "src/storagemapvec/out/debug/storagemapvec_test-abi.json"
));

pub mod abi_calls {
    use super::*;

    pub async fn push(instance: &TestContract<WalletUnlocked>, key: u64, value: u64) {
        instance.methods().push(key, value).call().await.unwrap();
    }

    pub async fn pop(instance: &TestContract<WalletUnlocked>, key: u64) -> Option<u64> {
        instance.methods().pop(key).call().await.unwrap().value
    }

    pub async fn get(instance: &TestContract<WalletUnlocked>, key: u64, index: u64) -> Option<u64> {
        instance
            .methods()
            .get(key, index)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn len(instance: &TestContract<WalletUnlocked>, key: u64) -> u64 {
        instance.methods().len(key).call().await.unwrap().value
    }

    pub async fn is_empty(instance: &TestContract<WalletUnlocked>, key: u64) -> bool {
        instance.methods().is_empty(key).call().await.unwrap().value
    }

    pub async fn clear(instance: &TestContract<WalletUnlocked>, key: u64) {
        instance.methods().clear(key).call().await.unwrap();
    }

    pub async fn to_vec_as_tup(
        instance: &TestContract<WalletUnlocked>,
        key: u64,
    ) -> (u64, u64, u64) {
        instance
            .methods()
            .to_vec_as_tup(key)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn swap(instance: &TestContract<WalletUnlocked>, key: u64, index1: u64, index2: u64) {
        instance
            .methods()
            .swap(key, index1, index2)
            .call()
            .await
            .unwrap();
    }

    pub async fn swap_remove(instance: &TestContract<WalletUnlocked>, key: u64, index: u64) -> u64 {
        instance
            .methods()
            .swap_remove(key, index)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn remove(instance: &TestContract<WalletUnlocked>, key: u64, index: u64) -> u64 {
        instance
            .methods()
            .remove(key, index)
            .call()
            .await
            .unwrap()
            .value
    }

    // pub async fn insert(instance: &TestContract, key: u64, index: u64, value: u64) {
    //     instance
    //         .methods()
    //         .insert(key, index, value)
    //         .call()
    //         .await
    //         .unwrap();
    // }
}

pub mod test_helpers {

    use super::*;

    pub async fn setup() -> TestContract<WalletUnlocked> {
        let wallet = launch_provider_and_get_wallet().await;

        let storage_configuration = StorageConfiguration::load_from(
            "src/storagemapvec/out/debug/storagemapvec_test-storage_slots.json",
        );
        let contract_id = Contract::load_from(
            "src/storagemapvec/out/debug/storagemapvec_test.bin",
            LoadConfiguration::default().set_storage_configuration(storage_configuration.unwrap()),
        )
        .unwrap()
        .deploy(&wallet, TxParameters::default())
        .await
        .unwrap();

        let instance = TestContract::new(contract_id, wallet);

        instance
    }
}
