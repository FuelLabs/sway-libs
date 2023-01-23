contract;

use std::{auth::*, call_frames::contract_id};

use reentrancy_target_abi::Target;
use reentrancy_attacker_abi::Attacker;

// Return the sender as a ContractId or panic:
fn get_msg_sender_id_or_panic() -> ContractId {
    match msg_sender().unwrap() {
        Identity::ContractId(v) => v,
        _ => revert(0),
    }
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
        abi(Attacker, contract_id().value).launch_thwarted_attack_1(get_msg_sender_id_or_panic());
    }

    fn innocent_callback() {}
}
