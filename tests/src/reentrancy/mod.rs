use fuels::{
    prelude::{
        abigen, launch_provider_and_get_wallet, Contract, LoadConfiguration, StorageConfiguration,
        TxPolicies, WalletUnlocked,
    },
    types::ContractId,
};

abigen!(
    Contract(name="AttackerContract", abi="src/reentrancy/reentrancy_attacker_contract/out/release/reentrancy_attacker_contract-abi.json"),
    Contract(name="TargetContract", abi="src/reentrancy/reentrancy_target_contract/out/release/reentrancy_target_contract-abi.json"),
    Contract(name="AttackHelperContract", abi="src/reentrancy/reentrancy_attack_helper_contract/out/release/reentrancy_attack_helper_contract-abi.json"),
);

const REENTRANCY_ATTACKER_BIN: &str =
    "src/reentrancy/reentrancy_attacker_contract/out/release/reentrancy_attacker_contract.bin";
const REENTRANCY_ATTACK_HELPER_BIN: &str =
    "src/reentrancy/reentrancy_attack_helper_contract/out/release/reentrancy_attack_helper_contract.bin";
const REENTRANCY_ATTACKER_STORAGE: &str = "src/reentrancy/reentrancy_attacker_contract/out/release/reentrancy_attacker_contract-storage_slots.json";

const REENTRANCY_TARGET_BIN: &str =
    "src/reentrancy/reentrancy_target_contract/out/release/reentrancy_target_contract.bin";
const REENTRANCY_TARGET_STORAGE: &str = "src/reentrancy/reentrancy_target_contract/out/release/reentrancy_target_contract-storage_slots.json";

pub async fn get_attacker_instance(
    wallet: WalletUnlocked,
) -> (AttackerContract<WalletUnlocked>, ContractId) {
    let storage_configuration =
        StorageConfiguration::default().add_slot_overrides_from_file(REENTRANCY_ATTACKER_STORAGE);
    let id = Contract::load_from(
        REENTRANCY_ATTACKER_BIN,
        LoadConfiguration::default().with_storage_configuration(storage_configuration.unwrap()),
    )
    .unwrap()
    .deploy(&wallet, TxPolicies::default())
    .await
    .unwrap();

    let instance = AttackerContract::new(id.clone(), wallet);

    (instance, id.into())
}

pub async fn get_target_instance(
    wallet: WalletUnlocked,
) -> (TargetContract<WalletUnlocked>, ContractId) {
    let storage_configuration =
        StorageConfiguration::default().add_slot_overrides_from_file(REENTRANCY_TARGET_STORAGE);
    let id = Contract::load_from(
        REENTRANCY_TARGET_BIN,
        LoadConfiguration::default().with_storage_configuration(storage_configuration.unwrap()),
    )
    .unwrap()
    .deploy(&wallet, TxPolicies::default())
    .await
    .unwrap();

    let instance = TargetContract::new(id.clone(), wallet);

    (instance, id.into())
}

pub async fn get_attack_helper_id(
    wallet: WalletUnlocked,
) -> (AttackHelperContract<WalletUnlocked>, ContractId) {
    let id = Contract::load_from(REENTRANCY_ATTACK_HELPER_BIN, LoadConfiguration::default())
        .unwrap()
        .deploy(&wallet, TxPolicies::default())
        .await
        .unwrap();

    let instance = AttackHelperContract::new(id.clone(), wallet);

    (instance, id.into())
}

mod success {
    use super::*;

    #[tokio::test]
    async fn can_detect_reentrancy() {
        let wallet = launch_provider_and_get_wallet().await.unwrap();
        let (attacker_instance, _) = get_attacker_instance(wallet.clone()).await;
        let (instance, target_id) = get_target_instance(wallet).await;

        let result = attacker_instance
            .methods()
            .launch_attack(target_id)
            .with_contracts(&[&instance])
            .call()
            .await
            .unwrap();

        assert_eq!(result.value, true);
    }

    #[tokio::test]
    async fn can_call_guarded_function() {
        let wallet = launch_provider_and_get_wallet().await.unwrap();
        let (attacker_instance, _) = get_attacker_instance(wallet.clone()).await;
        let (instance, target_id) = get_target_instance(wallet).await;

        attacker_instance
            .methods()
            .innocent_call(target_id)
            .with_contracts(&[&instance])
            .call()
            .await
            .unwrap();
    }
}

mod revert {
    use super::*;

    #[tokio::test]
    #[should_panic(expected = "NonReentrant")]
    async fn can_block_reentrancy() {
        let wallet = launch_provider_and_get_wallet().await.unwrap();
        let (attacker_instance, _) = get_attacker_instance(wallet.clone()).await;
        let (instance, target_id) = get_target_instance(wallet).await;

        attacker_instance
            .methods()
            .launch_thwarted_attack_1(target_id)
            .with_contracts(&[&instance])
            .call()
            .await
            .unwrap();
    }

    #[tokio::test]
    #[should_panic(expected = "NonReentrant")]
    async fn can_block_cross_function_reentrancy() {
        let wallet = launch_provider_and_get_wallet().await.unwrap();
        let (attacker_instance, _) = get_attacker_instance(wallet.clone()).await;
        let (instance, target_id) = get_target_instance(wallet).await;

        attacker_instance
            .methods()
            .launch_thwarted_attack_2(target_id)
            .with_contracts(&[&instance])
            .call()
            .await
            .unwrap();
    }

    #[tokio::test]
    #[should_panic(expected = "NonReentrant")]
    async fn can_block_cross_contract_reentrancy() {
        let wallet = launch_provider_and_get_wallet().await.unwrap();
        let (attacker_instance, _) = get_attacker_instance(wallet.clone()).await;
        let (helper_instance, helper_id) = get_attack_helper_id(wallet.clone()).await;
        let (target_instance, target_id) = get_target_instance(wallet).await;

        attacker_instance
            .methods()
            .launch_thwarted_attack_3(target_id, helper_id)
            .with_contracts(&[&target_instance, &helper_instance])
            .call()
            .await
            .unwrap();
    }
}
