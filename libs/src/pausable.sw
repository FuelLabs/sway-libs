library;

pub mod errors;

use ::pausable::errors::PauseError;

// Precomputed hash of sha256("pausable")
const PAUSABLE = 0xd987cda398e9af257cbcf8a8995c5dccb19833cadc727ba56b0fec60ccf8944c;

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
    /// use sway_libs::pausable::Pausable;
    ///
    /// fn foo(contract_id: ContractId) {
    ///     let pausable_abi = abi(Pauseable, contract_id);
    ///     pausable_abi.pause();
    ///     assert(pausable_abi.is_paused());
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
    /// use sway_libs::pausable::Pausable;
    ///
    /// fn foo(contract_id: ContractId) {
    ///     let pausable_abi = abi(Pauseable, contract_id);
    ///     assert(!pausable_abi.is_paused());
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
    /// use sway_libs::pausable::Pausable;
    ///
    /// fn foo(contract_id: ContractId) {
    ///     let pausable_abi = abi(Pauseable, contract_id);
    ///     pausable_abi.unpause();
    ///     assert(!pausable_abi.is_paused());
    /// }
    /// ```
    #[storage(write)]
    fn unpause();
}

/// Unconditionally sets the contract to the paused state.
///
/// # Number of Storage Accesses
///
/// * Writes: `1`
///
/// # Examples
///
/// ```sway
/// use sway_libs::pausable::{_pause, _is_paused};
///
/// fn foo() {
///     _pause();
///     assert(_is_paused());
/// }
/// ```
#[storage(write)]
pub fn _pause() {
    let paused_key = StorageKey::new(PAUSABLE, 0, PAUSABLE);
    paused_key.write(true);
}

/// Unconditionally sets the contract to the unpaused state.
///
/// # Number of Storage Accesses
///
/// * Writes: `1`
///
/// # Examples
///
/// ```sway
/// use sway_libs::pausable::{_unpause, _is_paused};
///
/// fn foo() {
///     _unpause();
///     assert(!_is_paused());
/// }
/// ```
#[storage(write)]
pub fn _unpause() {
    let paused_key = StorageKey::new(PAUSABLE, 0, PAUSABLE);
    paused_key.write(false);
}

/// Returns whether the contract is in the paused state.
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
/// use sway_libs::pausable::_is_paused;
///
/// fn foo() {
///     assert(!_is_paused());
/// }
/// ```
#[storage(read)]
pub fn _is_paused() -> bool {
    let paused_key = StorageKey::new(PAUSABLE, 0, PAUSABLE);
    paused_key.try_read().unwrap_or(false)
}

/// Requires that the contract is in the paused state.
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
/// use sway_libs::pausable::{_pause, require_paused};
///
/// fn foo() {
///     _pause();
///     require_paused();
///     // Only reachable when paused
/// }
/// ```
#[storage(read)]
pub fn require_paused() {
    let paused_key = StorageKey::<bool>::new(PAUSABLE, 0, PAUSABLE);
    require(
        paused_key
            .try_read()
            .unwrap_or(false),
        PauseError::NotPaused,
    );
}

/// Requires that the contract is in the unpaused state.
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
/// use sway_libs::pausable::{_unpause, require_not_paused};
///
/// fn foo() {
///     _unpause();
///     require_not_paused();
///     // Only reachable when unpaused
/// }
/// ```
#[storage(read)]
pub fn require_not_paused() {
    let paused_key = StorageKey::<bool>::new(PAUSABLE, 0, PAUSABLE);
    require(!paused_key.try_read().unwrap_or(false), PauseError::Paused);
}
