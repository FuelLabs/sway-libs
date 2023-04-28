use fuels::{
    prelude::{
        abigen, launch_provider_and_get_wallet, Contract, LoadConfiguration, StorageConfiguration,
        TxParameters, WalletUnlocked,
    },
    tx::ContractId,
};

abigen!(
    Contract(name="AttackerContract", abi="src/reentrancy/reentrancy_attacker_contract/out/debug/reentrancy_attacker_contract-abi.json"),
    Contract(name="TargetContract", abi="src/reentrancy/reentrancy_target_contract/out/debug/reentrancy_target_contract-abi.json")
);

const REENTRANCY_ATTACKER_BIN: &str =
    "src/reentrancy/reentrancy_attacker_contract/out/debug/reentrancy_attacker_contract.bin";
const REENTRANCY_ATTACKER_STORAGE: &str = "src/reentrancy/reentrancy_attacker_contract/out/debug/reentrancy_attacker_contract-storage_slots.json";

const REENTRANCY_TARGET_BIN: &str =
    "src/reentrancy/reentrancy_target_contract/out/debug/reentrancy_target_contract.bin";
const REENTRANCY_TARGET_STORAGE: &str = "src/reentrancy/reentrancy_target_contract/out/debug/reentrancy_target_contract-storage_slots.json";

pub async fn get_attacker_instance(
    wallet: WalletUnlocked,
) -> (AttackerContract<WalletUnlocked>, ContractId) {
    let storage_configuration = StorageConfiguration::load_from(REENTRANCY_ATTACKER_STORAGE);
    let id = Contract::load_from(
        REENTRANCY_ATTACKER_BIN,
        LoadConfiguration::default().set_storage_configuration(storage_configuration.unwrap()),
    )
    .unwrap()
    .deploy(&wallet, TxParameters::default())
    .await
    .unwrap();

    let instance = AttackerContract::new(id.clone(), wallet);

    (instance, id.into())
}

pub async fn get_target_instance(
    wallet: WalletUnlocked,
) -> (TargetContract<WalletUnlocked>, ContractId) {
    let storage_configuration = StorageConfiguration::load_from(REENTRANCY_TARGET_STORAGE);
    let id = Contract::load_from(
        REENTRANCY_TARGET_BIN,
        LoadConfiguration::default().set_storage_configuration(storage_configuration.unwrap()),
    )
    .unwrap()
    .deploy(&wallet, TxParameters::default())
    .await
    .unwrap();

    let instance = TargetContract::new(id.clone(), wallet);

    (instance, id.into())
}

mod success {
    use super::*;

    #[tokio::test]
    async fn can_detect_reentrancy() {
        let wallet = launch_provider_and_get_wallet().await;
        let (attacker_instance, _) = get_attacker_instance(wallet.clone()).await;
        let (instance, target_id) = get_target_instance(wallet).await;

        let result = attacker_instance
            .methods()
            .launch_attack(target_id)
            .set_contracts(&[&instance])
            .call()
            .await
            .unwrap();

        assert_eq!(result.value, true);
    }

    #[tokio::test]
    async fn can_call_guarded_function() {
        let wallet = launch_provider_and_get_wallet().await;
        let (attacker_instance, _) = get_attacker_instance(wallet.clone()).await;
        let (instance, target_id) = get_target_instance(wallet).await;

        attacker_instance
            .methods()
            .innocent_call(target_id)
            .set_contracts(&[&instance])
            .call()
            .await
            .unwrap();
    }
}

mod revert {
    use super::*;

    #[tokio::test]
    #[should_panic]
    async fn can_block_reentrancy() {
        let wallet = launch_provider_and_get_wallet().await;
        let (attacker_instance, _) = get_attacker_instance(wallet.clone()).await;
        let (instance, target_id) = get_target_instance(wallet).await;

        attacker_instance
            .methods()
            .launch_thwarted_attack_1(target_id)
            .set_contracts(&[&instance])
            .call()
            .await
            .unwrap();
    }

    #[tokio::test]
    #[should_panic]
    async fn can_block_cross_function_reentrancy() {
        let wallet = launch_provider_and_get_wallet().await;
        let (attacker_instance, _) = get_attacker_instance(wallet.clone()).await;
        let (instance, target_id) = get_target_instance(wallet).await;

        attacker_instance
            .methods()
            .launch_thwarted_attack_2(target_id)
            .set_contracts(&[&instance])
            .call()
            .await
            .unwrap();
    }
}
