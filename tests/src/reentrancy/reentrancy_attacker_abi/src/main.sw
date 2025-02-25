library;

abi Attacker {
    #[storage(read)]
    fn launch_attack(target: Option<ContractId>) -> bool;
    #[storage(read)]
    fn launch_thwarted_attack_1(target: Option<ContractId>);
    #[storage(read)]
    fn launch_thwarted_attack_2(target: Option<ContractId>);
    #[storage(read, write)]
    fn launch_thwarted_attack_3(target: Option<ContractId>, helper: ContractId);
    #[storage(read)]
    fn launch_thwarted_attack_4(target: Option<ContractId>);
    #[storage(read)]
    fn innocent_call(target: Option<ContractId>);
    fn evil_callback_1() -> bool;
    fn evil_callback_2();
    fn evil_callback_3();
    #[storage(read)]
    fn evil_callback_4();
    fn innocent_callback();
    #[storage(write)]
    fn set_target_contract(target_contract_id: ContractId);
}
