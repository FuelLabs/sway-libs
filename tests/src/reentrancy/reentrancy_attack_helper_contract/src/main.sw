contract;

use reentrancy_attack_helper_abi::AttackHelper;
use reentrancy_target_abi::Target;

impl AttackHelper for Contract {
    fn attempt_cross_contract_reentrancy(target: ContractId) {
        abi(Target, target.value).cross_contract_reentrancy_denied();
    }
}
