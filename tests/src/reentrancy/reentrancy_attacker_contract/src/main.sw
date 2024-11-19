contract;

use std::{
    auth::*,
    call_frames::*,
};

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
    target_id: ContractId = ContractId::zero(),
    helper: ContractId = ContractId::zero(),
}

impl Attacker for Contract {
    fn launch_attack(target: ContractId) -> bool {
        abi(Target, target.bits()).reentrancy_detected()
    }

    fn launch_thwarted_attack_1(target: ContractId) {
        abi(Target, target.bits()).reentrance_denied();
    }

    fn launch_thwarted_attack_2(target: ContractId) {
        abi(Target, target.bits()).intra_contract_call();
    }

    #[storage(write)]
    fn launch_thwarted_attack_3(target: ContractId, helper: ContractId) {
        storage.target_id.write(target);
        storage.helper.write(helper);
        abi(Target, target
            .bits())
            .cross_contract_reentrancy_denied();
    }

    fn launch_thwarted_attack_4(target: ContractId) {
        abi(Target, target.bits()).fallback_contract_call();
    }

    fn innocent_call(target: ContractId) {
        abi(Target, target.bits()).guarded_function_is_callable();
    }

    fn evil_callback_1() -> bool {
        abi(Attacker, ContractId::this().bits()).launch_attack(get_msg_sender_id_or_panic())
    }

    fn evil_callback_2() {
        abi(Attacker, ContractId::this()
            .bits())
            .launch_thwarted_attack_1(get_msg_sender_id_or_panic());
    }

    fn evil_callback_3() {
        abi(Attacker, ContractId::this()
            .bits())
            .launch_thwarted_attack_2(get_msg_sender_id_or_panic());
    }

    #[storage(read)]
    fn evil_callback_4() {
        let helper = storage.helper.read();
        abi(AttackHelper, helper
            .bits())
            .attempt_cross_contract_reentrancy(storage.target_id.read());
    }

    fn innocent_callback() {}
}

#[fallback]
fn fallback() {
    let call_args = called_args::<ContractId>();

    let target_abi = abi(Target, call_args.bits());
    target_abi.fallback_contract_call();
}
