contract;

use std::{auth::*, call_frames::contract_id};
use reentrancy::*;

use reentrancy_attacker_abi::Attacker;
use reentrancy_target_abi::Target;

// Return the sender as a ContractId or panic:
pub fn get_msg_sender_id_or_panic() -> ContractId {
    match msg_sender().unwrap() {
        Identity::ContractId(v) => v,
        _ => revert(0),
    }
}

impl Target for Contract {
    fn reentrancy_detected() -> bool {
        if is_reentrant() {
            true
        } else {
            // this call transfers control to the attacker contract, allowing it to execute arbitrary code.
            let return_value = abi(Attacker, get_msg_sender_id_or_panic().value).evil_callback_1();
            false
        }
    }

    fn reentrance_denied() {
        // panic if reentrancy detected
        reentrancy_guard();

        // this call transfers control to the attacker contract, allowing it to execute arbitrary code.
        let return_value = abi(Attacker, get_msg_sender_id_or_panic().value).evil_callback_2();
    }

    fn cross_function_reentrance_denied() {
        // panic if reentrancy detected
        reentrancy_guard();

        // this call transfers control to the attacker contract, allowing it to execute arbitrary code.
        let return_value = abi(Attacker, get_msg_sender_id_or_panic().value).evil_callback_3();
    }

    fn intra_contract_call() {
        abi(Target, contract_id().value).cross_function_reentrance_denied();
    }

    fn guarded_function_is_callable() {
        // panic if reentrancy detected
        reentrancy_guard();
    }

    fn cross_contract_reentrancy_denied() {
        // panic if reentrancy detected
        reentrancy_guard();

        // this call transfers control to the attacker contract, allowing it to execute arbitrary code.
        let return_value = abi(Attacker, get_msg_sender_id_or_panic().value).evil_callback_4();
    }
}
