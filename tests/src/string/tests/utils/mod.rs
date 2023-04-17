use fuels::{
    prelude::{
        abigen, launch_custom_provider_and_get_wallets, Contract, LoadConfiguration, TxParameters,
        WalletUnlocked, WalletsConfig,
    },
    programs::call_response::FuelCallResponse,
};

// Load abi from json
abigen!(Contract(
    name = "StringTestLib",
    abi = "src/string/out/debug/string_test-abi.json"
));

pub mod abi_calls {

    use super::*;

    pub async fn append(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_append().call().await.unwrap()
    }

    pub async fn as_vec(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_as_vec().call().await.unwrap()
    }

    pub async fn capacity(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_capacity().call().await.unwrap()
    }

    pub async fn clear(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_clear().call().await.unwrap()
    }

    pub async fn from(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_from().call().await.unwrap()
    }

    pub async fn from_raw_slice(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract
            .methods()
            .test_from_raw_slice()
            .call()
            .await
            .unwrap()
    }

    pub async fn from_utf8(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_from_utf8().call().await.unwrap()
    }

    pub async fn insert(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_insert().call().await.unwrap()
    }

    pub async fn into(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_into().call().await.unwrap()
    }

    pub async fn into_raw_slice(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract
            .methods()
            .test_into_raw_slice()
            .call()
            .await
            .unwrap()
    }

    pub async fn is_empty(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_is_empty().call().await.unwrap()
    }

    pub async fn len(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_len().call().await.unwrap()
    }

    pub async fn new(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_new().call().await.unwrap()
    }

    pub async fn nth(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_nth().call().await.unwrap()
    }

    pub async fn pop(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_pop().call().await.unwrap()
    }

    pub async fn push(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_push().call().await.unwrap()
    }

    pub async fn set(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_set().call().await.unwrap()
    }

    pub async fn split_at(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_split_at().call().await.unwrap()
    }

    pub async fn swap(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_swap().call().await.unwrap()
    }

    pub async fn remove(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract.methods().test_remove().call().await.unwrap()
    }

    pub async fn with_capacity(contract: &StringTestLib<WalletUnlocked>) -> FuelCallResponse<()> {
        contract
            .methods()
            .test_with_capacity()
            .call()
            .await
            .unwrap()
    }
}

pub mod test_helpers {

    use super::*;

    pub async fn setup() -> StringTestLib<WalletUnlocked> {
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

        let id = Contract::load_from(
            "src/string/out/debug/string_test.bin",
            LoadConfiguration::default(),
        )
        .unwrap()
        .deploy(&wallet, TxParameters::default())
        .await
        .unwrap();

        let instance = StringTestLib::new(id.clone(), wallet);

        instance
    }
}
