library;

abi Attacker {
    fn launch_attack(target: ContractId) -> bool;
    fn launch_thwarted_attack_1(target: ContractId);
    fn launch_thwarted_attack_2(target: ContractId);
    fn innocent_call(target: ContractId);
    fn evil_callback_1();
    fn evil_callback_2();
    fn evil_callback_3();
    fn innocent_callback();
}
