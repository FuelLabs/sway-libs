library;

use src5::State;

/// Logged when ownership is a new proxy target is set.
pub struct ProxyTargetSet {
    /// The new target contract.
    pub new_target: ContractId,
}

/// Logged when ownership is a new proxy owner is set.
pub struct ProxyOwnerSet {
    /// The new ownership state.
    pub new_proxy_owner: State,
}
