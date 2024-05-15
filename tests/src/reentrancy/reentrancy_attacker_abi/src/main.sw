library;

abi Attacker {
    fn launch_attack(target: ContractId) -> bool;
    fn launch_thwarted_attack_1(target: ContractId);
    fn launch_thwarted_attack_2(target: ContractId);
    #[storage(write)]
    fn launch_thwarted_attack_3(target: ContractId, helper: ContractId);
    fn innocent_call(target: ContractId);
    fn evil_callback_1() -> bool;
    fn evil_callback_2();
    fn evil_callback_3();
    #[storage(read)]
    fn evil_callback_4();
    fn innocent_callback();
}
