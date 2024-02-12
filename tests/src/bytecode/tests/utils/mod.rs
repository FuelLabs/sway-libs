use fuels::{
    accounts::predicate::Predicate,
    prelude::*,
    programs::call_response::FuelCallResponse,
    tx::{Bytes32, StorageSlot},
    types::Bits256,
};
use fuels_core::codec::DecoderConfig;
use rand::prelude::{Rng, SeedableRng, StdRng};
use std::{fs, str::FromStr};

// Load abi from json
abigen!(
    Contract(
        name = "SimpleContract",
        abi = "src/bytecode/test_artifacts/simple_contract/out/debug/simple_contract-abi.json"
    ),
    Contract(
        name = "ComplexContract",
        abi = "src/bytecode/test_artifacts/complex_contract/out/debug/complex_contract-abi.json"
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

const SIMPLE_CONTRACT_BYTECODE_PATH: &str =
    "src/bytecode/test_artifacts/simple_contract/out/debug/simple_contract.bin";
const COMPLEX_CONTRACT_BYTECODE_PATH: &str =
    "src/bytecode/test_artifacts/complex_contract/out/debug/complex_contract.bin";
const PREDICATE_BYTECODE_PATH: &str =
    "src/bytecode/test_artifacts/simple_predicate/out/debug/simple_predicate.bin";
const DEFAULT_PREDICATE_BALANCE: u64 = 512;

const HEX_STR_1: &str = "0xacbe4bfc77e55c071db31f2e37c824d75794867d88499107dc8318cb22aceea5";
const HEX_STR_2: &str = "0x0b1af92ac5a3e8cfeafede9586a1f853a9e0258e7cdccae5e5181edac081f2c1b";
const HEX_STR_3: &str = "0x0345c74edfb0ce0820409176d0cbc2c44eac1e5e4c7382ee7e7c38d611d9ba767";

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

    pub async fn return_configurables(
        contract: &ComplexContract<WalletUnlocked>,
    ) -> (u64, SimpleStruct, SimpleEnum) {
        contract
            .methods()
            .return_configurables()
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
            .with_decoder_config(DecoderConfig {
                max_tokens: 1_000_000,
                ..Default::default()
            })
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

    pub async fn verify_simple_contract_bytecode(
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

    pub async fn verify_complex_contract_bytecode(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode: Vec<u8>,
        contract_id: ContractId,
        complex_contract_instance: ComplexContract<WalletUnlocked>,
    ) -> FuelCallResponse<()> {
        contract
            .methods()
            .verify_contract_bytecode(contract_id, bytecode)
            .with_contracts(&[&complex_contract_instance])
            .call()
            .await
            .unwrap()
    }

    pub async fn verify_simple_contract_bytecode_with_configurables(
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

    pub async fn verify_complex_contract_bytecode_with_configurables(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode: Vec<u8>,
        configurables: Vec<(u64, Vec<u8>)>,
        contract_id: ContractId,
        complex_contract_instance: ComplexContract<WalletUnlocked>,
    ) -> FuelCallResponse<()> {
        contract
            .methods()
            .verify_contract_bytecode_with_configurables(contract_id, bytecode, configurables)
            .with_contracts(&[&complex_contract_instance])
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

    pub fn complex_defaults() -> (SimpleStruct, SimpleEnum) {
        let simple_struct = SimpleStruct {
            x: 10u32,
            y: Bits256(
                *Bytes32::from_str(HEX_STR_1).expect("failed to create Bytes32 from string"),
            ),
        };

        let simple_enum = SimpleEnum::Z((
            Bits256(*Bytes32::from_str(HEX_STR_2).expect("failed to create Bytes32 from string")),
            Bits256(*Bytes32::from_str(HEX_STR_3).expect("failed to create Bytes32 from string")),
        ));

        (simple_struct, simple_enum)
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
        let id = Contract::load_from(SIMPLE_CONTRACT_BYTECODE_PATH, LoadConfiguration::default())
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
            SIMPLE_CONTRACT_BYTECODE_PATH,
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
        let root = Contract::load_from(SIMPLE_CONTRACT_BYTECODE_PATH, LoadConfiguration::default())
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
            SIMPLE_CONTRACT_BYTECODE_PATH,
            LoadConfiguration::default().with_configurables(configurables),
        )
        .unwrap()
        .code_root();

        Bits256(*root)
    }

    /// Helper function to deploy the simple contract from bytecode
    pub async fn deploy_complex_contract_from_bytecode(
        wallet: WalletUnlocked,
        bytecode: Vec<u8>,
    ) -> ComplexContract<WalletUnlocked> {
        let rng = &mut StdRng::seed_from_u64(2323u64);
        let salt: [u8; 32] = rng.gen();
        let storage_vec = Vec::<StorageSlot>::new();
        let result_id = Contract::new(bytecode, salt.into(), storage_vec)
            .deploy(&wallet, TxPolicies::default())
            .await
            .unwrap();
        ComplexContract::new(result_id.clone(), wallet.clone())
    }

    /// Helper function to deploy the simple contract from file
    pub async fn deploy_complex_contract_from_file(
        wallet: WalletUnlocked,
    ) -> (ComplexContract<WalletUnlocked>, ContractId) {
        let id = Contract::load_from(COMPLEX_CONTRACT_BYTECODE_PATH, LoadConfiguration::default())
            .unwrap()
            .deploy(&wallet, TxPolicies::default())
            .await
            .unwrap();

        let instance = ComplexContract::new(id.clone(), wallet.clone());

        (instance, id.into())
    }

    /// Helper function to deploy the simple contract from file
    pub async fn deploy_complex_contract_with_configurables_from_file(
        wallet: WalletUnlocked,
        config_value: u64,
        config_struct: SimpleStruct,
        config_enum: SimpleEnum,
    ) -> (ComplexContract<WalletUnlocked>, ContractId) {
        let configurables = ComplexContractConfigurables::new()
            .with_VALUE(config_value)
            .with_STRUCT(config_struct)
            .with_ENUM(config_enum);

        let id = Contract::load_from(
            COMPLEX_CONTRACT_BYTECODE_PATH,
            LoadConfiguration::default().with_configurables(configurables.clone()),
        )
        .unwrap()
        .deploy(&wallet, TxPolicies::default())
        .await
        .unwrap();

        let instance = ComplexContract::new(id.clone(), wallet.clone());

        (instance, id.into())
    }

    /// Helper function to deploy the simple contract from a file
    pub async fn complex_contract_bytecode_root_from_file() -> Bits256 {
        // Fetch the bytecode root
        let root =
            Contract::load_from(COMPLEX_CONTRACT_BYTECODE_PATH, LoadConfiguration::default())
                .unwrap()
                .code_root();

        Bits256(*root)
    }

    /// Helper function to deploy the simple contract from a file
    pub async fn complex_contract_bytecode_root_with_configurables_from_file(
        config_value: u64,
        config_struct: SimpleStruct,
        config_enum: SimpleEnum,
    ) -> Bits256 {
        let configurables = ComplexContractConfigurables::new()
            .with_VALUE(config_value)
            .with_STRUCT(config_struct)
            .with_ENUM(config_enum);

        // Fetch the bytecode root
        let root = Contract::load_from(
            COMPLEX_CONTRACT_BYTECODE_PATH,
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

    /// Helper function to generate the configurable changes needed. Hardcoded for now
    pub fn build_simple_configurables(offset: u64, config_value: u8) -> Vec<(u64, Vec<u8>)> {
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

        data.extend_from_slice(&[0u8, 0u8, 0u8, 0u8, 0u8, 0u8, 0u8, config_value]);
        my_configurables.push((offset, data));

        my_configurables
    }

    pub fn build_complex_configurables(
        config_value: u8,
        config_struct: SimpleStruct,
        _config_enum: SimpleEnum,
    ) -> Vec<(u64, Vec<u8>)> {
        let mut my_configurables: Vec<(u64, Vec<u8>)> = Vec::new();

        let mut data1: Vec<u8> = Vec::new();
        data1.extend_from_slice(&[0u8, 0u8, 0u8, 0u8, 0u8, 0u8, 0u8, config_value]);
        my_configurables.push((238016, data1));

        let mut data2: Vec<u8> = Vec::new();
        data2.extend_from_slice(&[
            0u8,
            0u8,
            0u8,
            0u8,
            0u8,
            0u8,
            0u8,
            config_struct.x.try_into().unwrap(),
        ]);
        let bits1 = *Bytes32::from_str(HEX_STR_1).expect("failed to create Bytes32 from string");
        data2.extend_from_slice(&bits1);
        my_configurables.push((238024, data2));

        let mut data3: Vec<u8> = Vec::new();
        data3.extend_from_slice(&[0u8, 0u8, 0u8, 0u8, 0u8, 0u8, 0u8, 2u8]);
        let bits2 = *Bytes32::from_str(HEX_STR_2).expect("failed to create Bytes32 from string");
        let bits3 = *Bytes32::from_str(HEX_STR_3).expect("failed to create Bytes32 from string");
        data3.extend_from_slice(&bits2);
        data3.extend_from_slice(&bits3);
        my_configurables.push((238064, data3));

        my_configurables
    }

    pub fn simple_contract_bytecode() -> Vec<u8> {
        fs::read(SIMPLE_CONTRACT_BYTECODE_PATH).unwrap()
    }

    pub fn complex_contract_bytecode() -> Vec<u8> {
        fs::read(COMPLEX_CONTRACT_BYTECODE_PATH).unwrap()
    }

    pub fn predicate_bytecode() -> Vec<u8> {
        fs::read(PREDICATE_BYTECODE_PATH).unwrap()
    }
}
