contract;

use std::auth::*;
use sway_libs::reentrancy::*;

use reentrancy_attacker_abi::Attacker;
use reentrancy_target_abi::Target;
use reentrancy_fallback_abi::FallbackAttack;

storage {
    attack_contract: ContractId = ContractId::zero(),
}

impl Target for Contract {
    #[storage(read)]
    fn reentrancy_detected() -> bool {
        if is_reentrant() {
            true
        } else {
            // this call transfers control to the attacker contract, allowing it to execute arbitrary code.
            abi(Attacker, storage.attack_contract.read().bits()).evil_callback_1()
        }
    }

    #[storage(read)]
    fn reentrance_denied() {
        // panic if reentrancy detected
        reentrancy_guard();

        // this call transfers control to the attacker contract, allowing it to execute arbitrary code.
        abi(Attacker, storage.attack_contract.read().bits())
            .evil_callback_2();
    }

    #[storage(read)]
    fn cross_function_reentrance_denied() {
        // panic if reentrancy detected
        reentrancy_guard();

        // this call transfers control to the attacker contract, allowing it to execute arbitrary code.
        abi(Attacker, storage.attack_contract.read().bits())
            .evil_callback_3();
    }

    fn intra_contract_call() {
        abi(Target, ContractId::this()
            .bits())
            .cross_function_reentrance_denied();
    }

    fn guarded_function_is_callable() {
        // panic if reentrancy detected
        reentrancy_guard();
    }

    #[storage(read)]
    fn cross_contract_reentrancy_denied() {
        // panic if reentrancy detected
        reentrancy_guard();
        // this call transfers control to the attacker contract, allowing it to execute arbitrary code.
        abi(Attacker, storage.attack_contract.read().bits())
            .evil_callback_4();
    }

    #[storage(read)]
    fn fallback_contract_call() {
        // panic if reentrancy detected
        reentrancy_guard();

        // this call transfers control to the attacker contract, allowing it to execute arbitrary code.
        abi(FallbackAttack, storage.attack_contract.read().bits())
            .nonexistant_function(ContractId::this());
    }

    #[storage(write)]
    fn set_attack_contract(attack_contract_id: ContractId) {
        storage.attack_contract.write(attack_contract_id);
    }
}
