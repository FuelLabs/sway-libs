library;

abi Target {
    #[storage(read)]
    fn reentrancy_detected() -> bool;
    #[storage(read)]
    fn reentrance_denied();
    #[storage(read)]
    fn cross_function_reentrance_denied();
    fn intra_contract_call();
    fn guarded_function_is_callable();
    #[storage(read)]
    fn cross_contract_reentrancy_denied();
    #[storage(read)]
    fn fallback_contract_call();
    #[storage(write)]
    fn set_attack_contract(attack_contract_id: ContractId);
}
