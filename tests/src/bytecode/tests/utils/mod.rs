use fuels::{
    accounts::predicate::Predicate,
    core::codec::{DecoderConfig, EncoderConfig},
    prelude::*,
    programs::responses::CallResponse,
    tx::StorageSlot,
    types::{Bits256, Bytes32},
};
use rand::prelude::{Rng, SeedableRng, StdRng};
use std::{fs, str::FromStr};

// Load abi from json
abigen!(
    Contract(
        name = "SimpleContract",
        abi = "src/bytecode/test_artifacts/simple_contract/out/release/simple_contract-abi.json"
    ),
    Contract(
        name = "ComplexContract",
        abi = "src/bytecode/test_artifacts/complex_contract/out/release/complex_contract-abi.json"
    ),
    Contract(
        name = "BytecodeTestContract",
        abi = "src/bytecode/test_contract/out/release/bytecode_test-abi.json"
    ),
    Predicate(
        name = "SimplePredicate",
        abi = "src/bytecode/test_artifacts/simple_predicate/out/release/simple_predicate-abi.json"
    ),
);

const SIMPLE_CONTRACT_BYTECODE_PATH: &str =
    "src/bytecode/test_artifacts/simple_contract/out/release/simple_contract.bin";
const COMPLEX_CONTRACT_BYTECODE_PATH: &str =
    "src/bytecode/test_artifacts/complex_contract/out/release/complex_contract.bin";
const PREDICATE_BYTECODE_PATH: &str =
    "src/bytecode/test_artifacts/simple_predicate/out/release/simple_predicate.bin";
const DEFAULT_PREDICATE_BALANCE: u64 = 512;

const HEX_STR_1: &str = "0xb4ca495f61ac3433e9a78cbf3adfb0e4486913bb548029cef99d1de2cf606d52";
const HEX_STR_2: &str = "0x5d617010b482b54332741fab0dfd1b15dfad07e8895360af0fb9f3e3a04b0c74";
const HEX_STR_3: &str = "0xfebf0fdda20de46a0f2261a69556b0f9fdeea85759af1edb322831cf7d0dc8d5";
// For bytecode test failures, these offsets need to be updated with the new configurable values
// in the .json files in `bytecode/test_artifacts/*/out/*-abi.json`.
// For example: in `bytecode/test_artifacts/complex_contract/out/contract_contract-abi.json` we have the following:
//  "configurables": [
//   {
//     "name": "VALUE",
//     "concreteTypeId": "1506e6f44c1d6291cdf46395a8e573276a4fa79e8ace3fc891e092ef32d1b0a0",
//     "offset": 20800
//   },
//   {
//     "name": "STRUCT",
//     "concreteTypeId": "75f7f7a06026cab5d7a70984d1fde56001e83505e3a091ff9722b92d7f56d8be",
//     "offset": 20760
//   },
//   {
//     "name": "ENUM",
//     "concreteTypeId": "8dfea60c80d5eb43188e38922a715225450c499b19fd0dacc673c13ff708cdb2",
//     "offset": 20688
//   }
// ]
// You would use 20800, 20760, and 20688 for 1, 2, 3 respectively
const SIMPLE_PREDICATE_OFFSET: u64 = 384;
const SIMPLE_CONTRACT_OFFSET: u64 = 1336;
const COMPLEX_CONTRACT_OFFSET_1: u64 = 20800;
const COMPLEX_CONTRACT_OFFSET_2: u64 = 20760;
const COMPLEX_CONTRACT_OFFSET_3: u64 = 20688;

pub mod abi_calls {

    use super::*;

    pub async fn predicate_address_from_root(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode_root: Bits256,
    ) -> Address {
        contract
            .methods()
            .predicate_address_from_root(bytecode_root)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn compute_predicate_address(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode: Vec<u8>,
        configurables: Option<Vec<(u64, Vec<u8>)>>,
    ) -> Address {
        contract
            .methods()
            .compute_predicate_address(bytecode, configurables)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn compute_bytecode_root(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode: Vec<u8>,
        configurables: Option<Vec<(u64, Vec<u8>)>>,
    ) -> Bits256 {
        contract
            .clone()
            .with_encoder_config(EncoderConfig {
                max_depth: 10,
                max_tokens: 100_000,
            })
            .methods()
            .compute_bytecode_root(bytecode, configurables)
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
            .clone()
            .with_encoder_config(EncoderConfig {
                max_depth: 10,
                max_tokens: 100_000,
            })
            .methods()
            .swap_configurables(bytecode, configurables)
            .with_decoder_config(DecoderConfig {
                max_tokens: 10_000_000,
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
        configurables: Option<Vec<(u64, Vec<u8>)>>,
        contract_id: ContractId,
        simple_contract_instance: SimpleContract<WalletUnlocked>,
    ) -> CallResponse<()> {
        contract
            .methods()
            .verify_contract_bytecode(contract_id, bytecode, configurables)
            .with_contracts(&[&simple_contract_instance])
            .call()
            .await
            .unwrap()
    }

    pub async fn verify_complex_contract_bytecode(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode: Vec<u8>,
        configurables: Option<Vec<(u64, Vec<u8>)>>,
        contract_id: ContractId,
        complex_contract_instance: ComplexContract<WalletUnlocked>,
    ) -> CallResponse<()> {
        contract
            .clone()
            .with_encoder_config(EncoderConfig {
                max_depth: 10,
                max_tokens: 100_000,
            })
            .methods()
            .verify_contract_bytecode(contract_id, bytecode, configurables)
            .with_contracts(&[&complex_contract_instance])
            .call()
            .await
            .unwrap()
    }

    pub async fn verify_predicate_address(
        contract: &BytecodeTestContract<WalletUnlocked>,
        bytecode: Vec<u8>,
        configurables: Option<Vec<(u64, Vec<u8>)>>,
        predicate_id: Address,
    ) -> CallResponse<()> {
        contract
            .methods()
            .verify_predicate_address(predicate_id, bytecode, configurables)
            .call()
            .await
            .unwrap()
    }
}

pub mod test_helpers {

    use super::*;

    pub fn defaults() -> (u64, u64, u8) {
        let config_value = 119;

        (
            SIMPLE_CONTRACT_OFFSET,
            SIMPLE_PREDICATE_OFFSET,
            config_value,
        )
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
            "src/bytecode/test_contract/out/release/bytecode_test.bin",
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
        let result_id = Contract::regular(bytecode, salt.into(), storage_vec)
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
        let configurables = SimpleContractConfigurables::default()
            .with_VALUE(config_value)
            .unwrap();

        let id = Contract::load_from(
            SIMPLE_CONTRACT_BYTECODE_PATH,
            LoadConfiguration::default().with_configurables(configurables),
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
        let configurables = SimpleContractConfigurables::new(EncoderConfig {
            max_tokens: 10_000_000,
            ..Default::default()
        })
        .with_VALUE(config_value)
        .unwrap();

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
        let result_id = Contract::regular(bytecode, salt.into(), storage_vec)
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
        let configurables = ComplexContractConfigurables::new(EncoderConfig {
            max_tokens: 10_000_000,
            ..Default::default()
        })
        .with_VALUE(config_value)
        .unwrap()
        .with_STRUCT(config_struct)
        .unwrap()
        .with_ENUM(config_enum)
        .unwrap();

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
        let configurables = ComplexContractConfigurables::new(EncoderConfig {
            max_tokens: 10_000_000,
            ..Default::default()
        })
        .with_VALUE(config_value)
        .unwrap()
        .with_STRUCT(config_struct)
        .unwrap()
        .with_ENUM(config_enum)
        .unwrap();

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
        let predicate_data = SimplePredicateEncoder::default()
            .encode_data(config_value)
            .unwrap();
        let result_instance = Predicate::from_code(bytecode)
            .with_provider(provider.clone())
            .with_data(predicate_data);

        // Fund predicate
        wallet
            .transfer(
                result_instance.address(),
                DEFAULT_PREDICATE_BALANCE,
                *wallet
                    .provider()
                    .unwrap()
                    .consensus_parameters()
                    .await
                    .unwrap()
                    .base_asset_id(),
                TxPolicies::default(),
            )
            .await
            .unwrap();

        let predicate_balance = result_instance
            .get_asset_balance(
                &wallet
                    .provider()
                    .unwrap()
                    .consensus_parameters()
                    .await
                    .unwrap()
                    .base_asset_id(),
            )
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
                *wallet
                    .provider()
                    .unwrap()
                    .consensus_parameters()
                    .await
                    .unwrap()
                    .base_asset_id(),
                TxPolicies::default(),
            )
            .await
            .unwrap();

        let predicate_balance = result_instance
            .get_asset_balance(
                &wallet
                    .provider()
                    .unwrap()
                    .consensus_parameters()
                    .await
                    .unwrap()
                    .base_asset_id(),
            )
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
        let predicate_data = SimplePredicateEncoder::default()
            .encode_data(config_value)
            .unwrap();
        let configurables = SimplePredicateConfigurables::default()
            .with_VALUE(config_value)
            .unwrap();
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
                *wallet
                    .provider()
                    .unwrap()
                    .consensus_parameters()
                    .await
                    .unwrap()
                    .base_asset_id(),
                TxPolicies::default(),
            )
            .await
            .unwrap();

        let predicate_balance = result_instance
            .get_asset_balance(
                &wallet
                    .provider()
                    .unwrap()
                    .consensus_parameters()
                    .await
                    .unwrap()
                    .base_asset_id(),
            )
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
        let predicate_data = SimplePredicateEncoder::default()
            .encode_data(config_value)
            .unwrap();
        let configurables = SimplePredicateConfigurables::default()
            .with_VALUE(config_value)
            .unwrap();
        let result_instance = Predicate::from_code(predicate_bytecode)
            .with_configurables(configurables)
            .with_provider(provider.clone())
            .with_data(predicate_data);

        Bits256(*fuel_tx::Contract::root_from_code(result_instance.code()))
    }

    pub async fn spend_predicate(predicate_instance: Predicate, wallet: WalletUnlocked) {
        predicate_instance
            .transfer(
                wallet.address(),
                1,
                *wallet
                    .provider()
                    .unwrap()
                    .consensus_parameters()
                    .await
                    .unwrap()
                    .base_asset_id(),
                TxPolicies::default(),
            )
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
        my_configurables.push((COMPLEX_CONTRACT_OFFSET_1, data1));

        let mut data2: Vec<u8> = Vec::new();
        data2.extend_from_slice(&[0u8, 0u8, 0u8, config_struct.x.try_into().unwrap()]);
        let bits1 = *Bytes32::from_str(HEX_STR_1).expect("failed to create Bytes32 from string");
        data2.extend_from_slice(&bits1);
        my_configurables.push((COMPLEX_CONTRACT_OFFSET_2, data2));

        let mut data3: Vec<u8> = Vec::new();
        data3.extend_from_slice(&[0u8, 0u8, 0u8, 0u8, 0u8, 0u8, 0u8, 2u8]);
        let bits2 = *Bytes32::from_str(HEX_STR_2).expect("failed to create Bytes32 from string");
        let bits3 = *Bytes32::from_str(HEX_STR_3).expect("failed to create Bytes32 from string");
        data3.extend_from_slice(&bits2);
        data3.extend_from_slice(&bits3);
        my_configurables.push((COMPLEX_CONTRACT_OFFSET_3, data3));

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
