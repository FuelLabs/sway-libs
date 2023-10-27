library;

/// Error emitted upon the opposite of the desired pause state.
pub enum PauseError {
    /// Emitted when the contract is paused.
    Paused: (),
    /// Emitted when the contract is not paused.
    NotPaused: (),
}

abi Pausable {
    /// Pauses the contract.
    ///
    /// # Additional Information
    ///
    /// It is highly encouraged to use the Ownership Library in order to lock this
    /// function to a single administrative user.
    ///
    /// # Number of Storage Accesses
    ///
    /// * Writes: `1`
    ///
    /// # Examples
    ///
    /// ```sway
    /// use pausable::Pausable;
    ///
    /// fn foo(contract_id: ContractId) {
    ///     let pausable_abi = abi(Pauseable, contract_id);
    ///     pausable_abi.pause();
    ///     assert(pausable_abi.is_paused() == true);
    /// }
    /// ```
    #[storage(write)]
    fn pause();

    /// Returns whether the contract is paused.
    ///
    /// # Returns
    ///
    /// * [bool] - The pause state for the contract.
    ///
    /// # Number of Storage Accesses
    ///
    /// * Reads: `1`
    ///
    /// # Examples
    ///
    /// ```sway
    /// use pausable::Pausable;
    ///
    /// fn foo(contract_id: ContractId) {
    ///     let pausable_abi = abi(Pauseable, contract_id);
    ///     assert(pausable_abi.is_paused() == false);
    /// }
    /// ```
    #[storage(read)]
    fn is_paused() -> bool;

    /// Unpauses the contract.
    ///
    /// # Additional Information
    ///
    /// It is highly encouraged to use the Ownership Library in order to lock this
    /// function to a single administrative user.
    ///
    /// # Number of Storage Accesses
    ///
    /// * Writes: `1`
    ///
    /// # Examples
    ///
    /// ```sway
    /// use pausable::Pausable;
    ///
    /// fn foo(contract_id: ContractId) {
    ///     let pausable_abi = abi(Pauseable, contract_id);
    ///     pausable_abi.unpause();
    ///     assert(pausable_abi.is_paused() == false);
    /// }
    /// ```
    #[storage(write)]
    fn unpause();
}

/// Unconditionally sets the contract to the paused state.
///
/// # Arguments
///
/// * `paused_key`: [StorageKey<bool>] - The location in storage at which the paused state is stored.
///
/// # Number of Storage Accesses
///
/// * Writes: `1`
///
/// # Examples
///
/// ```sway
/// use pausable::{_pause, _is_paused};
///
/// storage {
///     paused: bool = false,
/// }
///
/// fn foo() {
///     _pause(storage.paused);
///     assert(_is_paused(storage.paused) == true);
/// }
/// ```
#[storage(write)]
pub fn _pause(paused_key: StorageKey<bool>) {
    paused_key.write(true);
}

/// Unconditionally sets the contract to the unpaused state.
///
/// # Arguments
///
/// * `paused_key`: [StorageKey<bool>] - The location in storage at which the paused state is stored.
///
/// # Number of Storage Accesses
///
/// * Writes: `1`
///
/// # Examples
///
/// ```sway
/// use pausable::{_unpause, _is_paused};
///
/// storage {
///     paused: bool = false,
/// }
///
/// fn foo() {
///     _unpause(storage.paused);
///     assert(_is_paused(storage.paused) == false);
/// }
/// ```
#[storage(write)]
pub fn _unpause(paused_key: StorageKey<bool>) {
    paused_key.write(false);
}

/// Returns whether the contract is in the paused state.
///
/// # Arguments
///
/// * `paused_key`: [StorageKey<bool>] - The location in storage at which the paused state is stored.
///
/// # Returns
///
/// * [bool] - The pause state of the contract.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use pausable::_is_paused;
///
/// storage {
///     paused: bool = false,
/// }
///
/// fn foo() {
///     assert(_is_paused(storage.paused) == false);
/// }
/// ```
#[storage(read)]
pub fn _is_paused(paused_key: StorageKey<bool>) -> bool {
    paused_key.read()
}

/// Requires that the contract is in the paused state.
///
/// # Arguments
///
/// * `paused_key`: [StorageKey<bool>] - The location in storage at which the paused state is stored.
///
/// # Reverts
///
/// * When the contract is not paused.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use pausable::{_pause, require_paused};
///
/// storage {
///     paused: bool = false,
/// }
///
/// fn foo() {
///     _pause(storage.paused);
///     require_paused(storage.paused);
///     // Only reachable when paused
/// }
/// ```
#[storage(read)]
pub fn require_paused(paused_key: StorageKey<bool>) {
    require(paused_key.read(), PauseError::NotPaused);
}

/// Requires that the contract is in the unpaused state.
///
/// # Arguments
///
/// * `paused_key`: [StorageKey<bool>] - The location in storage at which the paused state is stored.
///
/// # Reverts
///
/// * When the contract is paused.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use pausable::{_unpause, require_not_paused};
///
/// storage {
///     paused: bool = false,
/// }
///
/// fn foo() {
///     _unpause(storage.paused);
///     require_not_paused(storage.paused);
///     // Only reachable when unpaused
/// }
/// ```
#[storage(read)]
pub fn require_not_paused(paused_key: StorageKey<bool>) {
    require(!paused_key.read(), PauseError::Paused);
}
