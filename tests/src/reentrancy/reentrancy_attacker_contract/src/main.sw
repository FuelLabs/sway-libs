contract;

use std::{auth::*, call_frames::contract_id, constants::ZERO_B256};

use reentrancy_target_abi::Target;
use reentrancy_attacker_abi::Attacker;
use reentrancy_attack_helper_abi::AttackHelper;

// Return the sender as a ContractId or panic:
fn get_msg_sender_id_or_panic() -> ContractId {
    match msg_sender().unwrap() {
        Identity::ContractId(v) => v,
        _ => revert(0),
    }
}

storage {
    target_id: ContractId = ContractId::from(ZERO_B256),
    helper: ContractId = ContractId::from(ZERO_B256),
}

impl Attacker for Contract {
    fn launch_attack(target: ContractId) -> bool {
        abi(Target, target.value).reentrancy_detected()
    }

    fn launch_thwarted_attack_1(target: ContractId) {
        abi(Target, target.value).intra_contract_call();
    }

    fn launch_thwarted_attack_2(target: ContractId) {
        abi(Target, target.value).cross_function_reentrance_denied();
    }

    #[storage(write)]
    fn launch_thwarted_attack_3(target: ContractId, helper: ContractId) {
        storage.target_id.write(target);
        storage.helper.write(helper);
        abi(Target, target.value).cross_contract_reentrancy_denied();
    }

    fn innocent_call(target: ContractId) {
        abi(Target, target.value).guarded_function_is_callable();
    }

    fn evil_callback_1() {
        assert(abi(Attacker, contract_id().value).launch_attack(get_msg_sender_id_or_panic()));
    }

    fn evil_callback_2() {
        abi(Attacker, contract_id().value).launch_thwarted_attack_1(get_msg_sender_id_or_panic());
    }

    fn evil_callback_3() {
        abi(Attacker, contract_id().value).launch_thwarted_attack_2(get_msg_sender_id_or_panic());
    }

    #[storage(read)]
    fn evil_callback_4() {
        let helper = storage.helper.read();
        abi(AttackHelper, helper.value).attempt_cross_contract_reentrancy(storage.target_id.read());
    }

    fn innocent_callback() {}
}
