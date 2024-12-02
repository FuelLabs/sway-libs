contract;

use std::{auth::*, call_frames::*,};

use reentrancy_target_abi::Target;
use reentrancy_attacker_abi::Attacker;
use reentrancy_attack_helper_abi::AttackHelper;

storage {
    target_id: ContractId = ContractId::zero(),
    helper: ContractId = ContractId::zero(),
}

impl Attacker for Contract {
    #[storage(read)]
    fn launch_attack(target: Option<ContractId>) -> bool {
        match target {
            Some(target_id) =>  abi(Target, target_id.bits()).reentrancy_detected(),
            None => abi(Target, storage.target_id.read().bits()).reentrancy_detected(),
        }       
    }

    #[storage(read)]
    fn launch_thwarted_attack_1(target: Option<ContractId>) {
        log("launch_thwarted_attack_1");
        match target {
            Some(target_id) =>  abi(Target, target_id.bits()).reentrance_denied(),
            None => abi(Target, storage.target_id.read().bits()).reentrance_denied(),
        }
    }

    #[storage(read)]
    fn launch_thwarted_attack_2(target: Option<ContractId>) {
        match target {
            Some(target_id) =>  abi(Target, target_id.bits()).intra_contract_call(),
            None => abi(Target, storage.target_id.read().bits()).intra_contract_call(),
        };
    }

    #[storage(read, write)]
    fn launch_thwarted_attack_3(target: Option<ContractId>, helper: ContractId) {
        storage.helper.write(helper);

        match target {
            Some(target_id) =>  abi(Target, target_id.bits()).cross_contract_reentrancy_denied(),
            None => abi(Target, storage.target_id.read().bits()).cross_contract_reentrancy_denied(),
        };
    }

    #[storage(read)]
    fn launch_thwarted_attack_4(target: Option<ContractId>) {
        match target {
            Some(target_id) =>  abi(Target, target_id.bits()).fallback_contract_call(),
            None => abi(Target, storage.target_id.read().bits()).fallback_contract_call(),
        };
    }

    #[storage(read)]
    fn innocent_call(target: Option<ContractId>) {
        match target {
            Some(target_id) =>  abi(Target, target_id.bits()).guarded_function_is_callable(),
            None => abi(Target, storage.target_id.read().bits()).guarded_function_is_callable(),
        };
    }

    fn evil_callback_1() -> bool {
        abi(Attacker, ContractId::this().bits()).launch_attack(None)
    }

    fn evil_callback_2() {
        abi(Attacker, ContractId::this()
            .bits())
            .launch_thwarted_attack_1(None);
    }

    fn evil_callback_3() {
        abi(Attacker, ContractId::this()
            .bits())
            .launch_thwarted_attack_2(None);
    }

    #[storage(read)]
    fn evil_callback_4() {
        let helper = storage.helper.read();
        abi(AttackHelper, helper
            .bits())
            .attempt_cross_contract_reentrancy(storage.target_id.read());
    }

    fn innocent_callback() {}

    #[storage(write)]
    fn set_target_contract(target_contract_id: ContractId) {
        storage.target_id.write(target_contract_id);
    }
}

#[fallback]
fn fallback() {
    let call_args = called_args::<ContractId>();

    let target_abi = abi(Target, call_args.bits());
    target_abi.fallback_contract_call();
}
