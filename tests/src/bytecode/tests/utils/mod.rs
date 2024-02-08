use fuels::{
    accounts::predicate::Predicate, prelude::*, programs::call_response::FuelCallResponse,
    tx::StorageSlot, types::Bits256,
};
use rand::prelude::{Rng, SeedableRng, StdRng};
use std::fs;

// Load abi from json
abigen!(
    Contract(
        name = "SimpleContract",
        abi = "src/bytecode/test_artifacts/simple_contract/out/debug/simple_contract-abi.json"
    ),
    Contract(
        name = "BytecodeTestContract",
        abi = "src/bytecode/test_contract/out/debug/bytecode_test-abi.json"
    ),
    Predicate(
        name = "SimplePredicate",
        abi = "src/bytecode/test_artifacts/simple_predicate/out/debug/simple_predicate-abi.json"
    ),
);

const CONTRACT_BYTECODE_PATH: &str =
    "src/bytecode/test_artifacts/simple_contract/out/debug/simple_contract.bin";
const PREDICATE_BYTECODE_PATH: &str =
    "src/bytecode/test_artifacts/simple_predicate/out/debug/simple_predicate.bin";
const DEFAULT_PREDICATE_BALANCE: u64 = 512;

pub mod abi_calls {

    use super::*;

    pub async fn generate_predicate_address(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode_root: Bits256,
    ) -> Address {
        contract
            .methods()
            .generate_predicate_address(bytecode_root)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn compute_predicate_address(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode: Vec<u8>,
    ) -> Address {
        contract
            .methods()
            .compute_predicate_address(bytecode)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn compute_predicate_address_with_configurables(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode: Vec<u8>,
        configurables: Vec<(u64, Vec<u8>)>,
    ) -> Address {
        contract
            .methods()
            .compute_predicate_address_with_configurables(bytecode, configurables)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn compute_bytecode_root(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode: Vec<u8>,
    ) -> Bits256 {
        contract
            .methods()
            .compute_bytecode_root(bytecode)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn compute_bytecode_root_with_configurables(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode: Vec<u8>,
        configurables: Vec<(u64, Vec<u8>)>,
    ) -> Bits256 {
        contract
            .methods()
            .compute_bytecode_root_with_configurables(bytecode, configurables)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn swap_configurables(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode: Vec<u8>,
        configurables: Vec<(u64, Vec<u8>)>,
    ) -> Vec<u8> {
        contract
            .methods()
            .swap_configurables(bytecode, configurables)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn test_function(contract: &SimpleContract<WalletUnlocked>) -> u64 {
        contract
            .methods()
            .test_function()
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn verify_contract_bytecode(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode: Vec<u8>,
        contract_id: ContractId,
        simple_contract_instance: SimpleContract<WalletUnlocked>,
    ) -> FuelCallResponse<()> {
        contract
            .methods()
            .verify_contract_bytecode(contract_id, bytecode)
            .with_contracts(&[&simple_contract_instance])
            .call()
            .await
            .unwrap()
    }

    pub async fn verify_contract_bytecode_with_configurables(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode: Vec<u8>,
        configurables: Vec<(u64, Vec<u8>)>,
        contract_id: ContractId,
        simple_contract_instance: SimpleContract<WalletUnlocked>,
    ) -> FuelCallResponse<()> {
        contract
            .methods()
            .verify_contract_bytecode_with_configurables(contract_id, bytecode, configurables)
            .with_contracts(&[&simple_contract_instance])
            .call()
            .await
            .unwrap()
    }

    pub async fn verify_predicate_address(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode: Vec<u8>,
        predicate_id: Address,
    ) -> FuelCallResponse<()> {
        contract
            .methods()
            .verify_predicate_address(predicate_id, bytecode)
            .call()
            .await
            .unwrap()
    }

    pub async fn verify_predicate_address_with_configurables(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode: Vec<u8>,
        configurables: Vec<(u64, Vec<u8>)>,
        predicate_id: Address,
    ) -> FuelCallResponse<()> {
        contract
            .methods()
            .verify_predicate_address_with_configurables(predicate_id, bytecode, configurables)
            .call()
            .await
            .unwrap()
    }
}

pub mod test_helpers {

    use super::*;

    pub fn defaults() -> (u64, u64, u8) {
        let contract_offset = 68;
        let predicate_offset = 188;
        let config_value = 119;

        (contract_offset, predicate_offset, config_value)
    }

    /// Helper function to deploy the simple contract
    pub async fn test_contract_instance() -> (BytecodeTestContract<WalletUnlocked>, WalletUnlocked)
    {
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
        .await
        .unwrap();
        let wallet = wallets.pop().unwrap();

        let id = Contract::load_from(
            "src/bytecode/test_contract/out/debug/bytecode_test.bin",
            LoadConfiguration::default(),
        )
        .unwrap()
        .deploy(&wallet, TxPolicies::default())
        .await
        .unwrap();

        let instance = BytecodeTestContract::new(id.clone(), wallet.clone());

        (instance, wallet)
    }

    /// Helper function to deploy the simple contract from bytecode
    pub async fn deploy_simple_contract_from_bytecode(
        wallet: WalletUnlocked,
        bytecode: Vec<u8>,
    ) -> SimpleContract<WalletUnlocked> {
        let rng = &mut StdRng::seed_from_u64(2322u64);
        let salt: [u8; 32] = rng.gen();
        let storage_vec = Vec::<StorageSlot>::new();
        let result_id = Contract::new(bytecode, salt.into(), storage_vec)
            .deploy(&wallet, TxPolicies::default())
            .await
            .unwrap();
        SimpleContract::new(result_id.clone(), wallet.clone())
    }

    /// Helper function to deploy the simple contract from file
    pub async fn deploy_simple_contract_from_file(
        wallet: WalletUnlocked,
    ) -> (SimpleContract<WalletUnlocked>, ContractId) {
        let id = Contract::load_from(CONTRACT_BYTECODE_PATH, LoadConfiguration::default())
            .unwrap()
            .deploy(&wallet, TxPolicies::default())
            .await
            .unwrap();

        let instance = SimpleContract::new(id.clone(), wallet.clone());

        (instance, id.into())
    }

    /// Helper function to deploy the simple contract from file
    pub async fn deploy_simple_contract_with_configurables_from_file(
        wallet: WalletUnlocked,
        config_value: u64,
    ) -> (SimpleContract<WalletUnlocked>, ContractId) {
        let configurables = SimpleContractConfigurables::new().with_VALUE(config_value);

        let id = Contract::load_from(
            CONTRACT_BYTECODE_PATH,
            LoadConfiguration::default().with_configurables(configurables.clone()),
        )
        .unwrap()
        .deploy(&wallet, TxPolicies::default())
        .await
        .unwrap();

        let instance = SimpleContract::new(id.clone(), wallet.clone());

        (instance, id.into())
    }

    /// Helper function to deploy the simple contract from a file
    pub async fn simple_contract_bytecode_root_from_file() -> Bits256 {
        // Fetch the bytecode root
        let root = Contract::load_from(CONTRACT_BYTECODE_PATH, LoadConfiguration::default())
            .unwrap()
            .code_root();

        Bits256(*root)
    }

    /// Helper function to deploy the simple contract from a file
    pub async fn simple_contract_bytecode_root_with_configurables_from_file(
        config_value: u64,
    ) -> Bits256 {
        let configurables = SimpleContractConfigurables::new().with_VALUE(config_value);

        // Fetch the bytecode root
        let root = Contract::load_from(
            CONTRACT_BYTECODE_PATH,
            LoadConfiguration::default().with_configurables(configurables),
        )
        .unwrap()
        .code_root();

        Bits256(*root)
    }

    pub async fn setup_predicate_from_bytecode(
        wallet: WalletUnlocked,
        bytecode: Vec<u8>,
        config_value: u64,
    ) -> Predicate {
        let provider = wallet.try_provider().unwrap();
        let predicate_data = SimplePredicateEncoder::encode_data(config_value);
        let result_instance = Predicate::from_code(bytecode)
            .with_provider(provider.clone())
            .with_data(predicate_data);

        // Fund predicate
        wallet
            .transfer(
                result_instance.address(),
                DEFAULT_PREDICATE_BALANCE,
                BASE_ASSET_ID,
                TxPolicies::default(),
            )
            .await
            .unwrap();

        let predicate_balance = result_instance
            .get_asset_balance(&BASE_ASSET_ID)
            .await
            .unwrap();
        assert_eq!(predicate_balance, DEFAULT_PREDICATE_BALANCE);

        result_instance
    }

    pub async fn setup_predicate_from_file(wallet: WalletUnlocked) -> Predicate {
        let provider = wallet.try_provider().unwrap();
        let result_instance = Predicate::load_from(PREDICATE_BYTECODE_PATH)
            .unwrap()
            .with_provider(provider.clone());

        // Fund predicate
        wallet
            .transfer(
                result_instance.address(),
                DEFAULT_PREDICATE_BALANCE,
                BASE_ASSET_ID,
                TxPolicies::default(),
            )
            .await
            .unwrap();

        let predicate_balance = result_instance
            .get_asset_balance(&BASE_ASSET_ID)
            .await
            .unwrap();
        assert_eq!(predicate_balance, DEFAULT_PREDICATE_BALANCE);

        result_instance
    }

    pub async fn setup_predicate_from_file_with_configurable(
        wallet: WalletUnlocked,
        config_value: u64,
    ) -> Predicate {
        let provider = wallet.try_provider().unwrap();
        let predicate_data = SimplePredicateEncoder::encode_data(config_value);
        let configurables = SimplePredicateConfigurables::new().with_VALUE(config_value);
        let result_instance = Predicate::load_from(PREDICATE_BYTECODE_PATH)
            .unwrap()
            .with_provider(provider.clone())
            .with_configurables(configurables)
            .with_data(predicate_data);

        // Fund predicate
        wallet
            .transfer(
                result_instance.address(),
                DEFAULT_PREDICATE_BALANCE,
                BASE_ASSET_ID,
                TxPolicies::default(),
            )
            .await
            .unwrap();

        let predicate_balance = result_instance
            .get_asset_balance(&BASE_ASSET_ID)
            .await
            .unwrap();
        assert_eq!(predicate_balance, DEFAULT_PREDICATE_BALANCE);

        result_instance
    }

    pub async fn simple_predicate_bytecode_root_from_file(wallet: WalletUnlocked) -> Bits256 {
        let predicate_bytecode = predicate_bytecode();

        let provider: &Provider = wallet.try_provider().unwrap();
        let result_instance =
            Predicate::from_code(predicate_bytecode).with_provider(provider.clone());

        Bits256(*fuel_tx::Contract::root_from_code(result_instance.code()))
    }

    pub async fn simple_predicate_bytecode_root_with_configurables_from_file(
        wallet: WalletUnlocked,
        config_value: u64,
    ) -> Bits256 {
        let predicate_bytecode = predicate_bytecode();

        let provider = wallet.try_provider().unwrap();
        let predicate_data = SimplePredicateEncoder::encode_data(config_value);
        let configurables = SimplePredicateConfigurables::new().with_VALUE(config_value);
        let result_instance = Predicate::from_code(predicate_bytecode)
            .with_configurables(configurables)
            .with_provider(provider.clone())
            .with_data(predicate_data);

        Bits256(*fuel_tx::Contract::root_from_code(result_instance.code()))
    }

    pub async fn spend_predicate(predicate_instance: Predicate, wallet: WalletUnlocked) {
        predicate_instance
            .transfer(wallet.address(), 1, BASE_ASSET_ID, TxPolicies::default())
            .await
            .unwrap();
    }

    /// Helper function to generate the configurable changes needed. Hardcoded 119u64 for now
    pub fn build_configurables(offset: u64, config_value: u8) -> Vec<(u64, Vec<u8>)> {
        // Build the configurable changes from the abi.json
        // This is hardcoded for now. From the json below we know it's at offset 68 for simple_contract

        // "configurables": [
        // {
        //     "name": "VALUE",
        //     "configurableType": {
        //       "name": "",
        //       "type": 0,
        //       "typeArguments": null
        //     },
        //     "offset": 68
        //   }
        // ]

        let mut my_configurables: Vec<(u64, Vec<u8>)> = Vec::new();
        let mut data: Vec<u8> = Vec::new();

        data.push(0u8);
        data.push(0u8);
        data.push(0u8);
        data.push(0u8);
        data.push(0u8);
        data.push(0u8);
        data.push(0u8);
        data.push(config_value);
        my_configurables.push((offset, data));

        my_configurables
    }

    pub fn contract_bytecode() -> Vec<u8> {
        fs::read(CONTRACT_BYTECODE_PATH).unwrap()
    }

    pub fn predicate_bytecode() -> Vec<u8> {
        fs::read(PREDICATE_BYTECODE_PATH).unwrap()
    }
}
