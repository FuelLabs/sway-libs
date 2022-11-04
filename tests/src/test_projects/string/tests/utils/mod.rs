use fuels::{contract::contract::CallResponse, prelude::*};

// Load abi from json
abigen!(
    StringTestLib,
    "test_projects/string/out/debug/string-abi.json"
);

pub mod abi_calls {

    use super::*;

    pub async fn as_bytes(contract: &StringTestLib) -> CallResponse<()> {
        contract.methods().test_as_bytes().call().await.unwrap()
    }

    pub async fn capacity(contract: &StringTestLib) -> CallResponse<()> {
        contract.methods().test_capacity().call().await.unwrap()
    }

    pub async fn clear(contract: &StringTestLib) -> CallResponse<()> {
        contract.methods().test_clear().call().await.unwrap()
    }

    pub async fn from_utf8(contract: &StringTestLib) -> CallResponse<()> {
        contract.methods().test_from_utf8().call().await.unwrap()
    }

    pub async fn insert(contract: &StringTestLib) -> CallResponse<()> {
        contract.methods().test_insert().call().await.unwrap()
    }

    pub async fn is_empty(contract: &StringTestLib) -> CallResponse<()> {
        contract.methods().test_is_empty().call().await.unwrap()
    }

    pub async fn len(contract: &StringTestLib) -> CallResponse<()> {
        contract.methods().test_len().call().await.unwrap()
    }

    pub async fn new(contract: &StringTestLib) -> CallResponse<()> {
        contract.methods().test_new().call().await.unwrap()
    }

    pub async fn nth(contract: &StringTestLib) -> CallResponse<()> {
        contract.methods().test_nth().call().await.unwrap()
    }

    pub async fn pop(contract: &StringTestLib) -> CallResponse<()> {
        contract.methods().test_pop().call().await.unwrap()
    }

    pub async fn push(contract: &StringTestLib) -> CallResponse<()> {
        contract.methods().test_push().call().await.unwrap()
    }

    pub async fn remove(contract: &StringTestLib) -> CallResponse<()> {
        contract.methods().test_remove().call().await.unwrap()
    }

    pub async fn with_capacity(contract: &StringTestLib) -> CallResponse<()> {
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

    pub async fn setup() -> StringTestLib {
        // Launch a local network and deploy the contract
        let mut wallets = launch_custom_provider_and_get_wallets(
            WalletsConfig::new(
                Some(1),             /* Single wallet */
                Some(1),             /* Single coin (UTXO) */
                Some(1_000_000_000), /* Amount per coin */
            ),
            None,
        )
        .await;
        let wallet = wallets.pop().unwrap();

        let id = Contract::deploy(
            "test_projects/string/out/debug/string.bin",
            &wallet,
            TxParameters::default(),
            StorageConfiguration::default(),
        )
        .await
        .unwrap();

        let instance = StringTestLib::new(id.clone(), wallet);

        instance
    }
}
