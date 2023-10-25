library;
use std::{constants::ZERO_B256, token::{burn, mint}};

// Precomputed hash of sha256("pausable")
const PAUSABLE = 0xd987cda398e9af257cbcf8a8995c5dccb19833cadc727ba56b0fec60ccf8944c;

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
    fn pause();

    /// Returns whether the contract is paused.
    ///
    /// # Returns
    ///
    /// * [bool] - The pause state for the contract.
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
    fn is_paused() -> bool;

    /// Unpauses the contract.
    ///
    /// # Additional Information
    ///
    /// It is highly encouraged to use the Ownership Library in order to lock this
    /// function to a single administrative user.
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
    fn unpause();
}

/// Unconditionally sets the contract to the paused state.
///
/// # Examples
///
/// ```sway
/// use pausable::{_pause, _is_paused};
///
/// fn foo() {
///     _pause();
///     assert(_is_paused() == true);
/// }
/// ```
pub fn _pause() {
    if balance() == 0 {
        mint(PAUSABLE, 1);
    }
}

/// Unconditionally sets the contract to the unpaused state.
///
/// # Examples
///
/// ```sway
/// use pausable::{_unpause, _is_paused};
///
/// fn foo() {
///     _unpause();
///     assert(_is_paused() == false);
/// }
/// ```
pub fn _unpause() {
    if balance() == 1 {
        burn(PAUSABLE, 1);
    }
}

/// Returns whether the contract is in the paused state.
///
/// # Returns
///
/// * [bool] - The pause state of the contract.
///
/// # Examples
///
/// ```sway
/// use pausable::_is_paused;
///
/// fn foo() {
///     assert(_is_paused() == false);
/// }
/// ```
pub fn _is_paused() -> bool {
    balance() == 1
}

/// Requires that the contract is in the paused state.
///
/// # Reverts
///
/// * When the contract is not paused.
///
/// # Examples
///
/// ```sway
/// use pausable::{_pause, require_paused};
///
/// fn foo() {
///     _pause();
///     require_paused();
/// }
/// ```
pub fn require_paused() {
    require(balance() == 1, PauseError::NotPaused);
}

/// Requires that the contract is in the unpaused state.
///
/// # Reverts
///
/// * When the contract is paused.
///
/// # Examples
///
/// ```sway
/// use pausable::{_unpause, require_not_paused};
///
/// fn foo() {
///     _unpause();
///     require_not_paused();
/// }
/// ```
pub fn require_not_paused() {
    require(balance() == 0, PauseError::Paused);
}

fn balance() -> u64 {
    let id = asm() { fp: b256 };
    let result_buffer = ZERO_B256;
    // Hashing in assmeby gives us significant gas savings over using the std::hash::sha256
    // as this does not use std::bytes::Bytes. 
    // Only possible because of the fixed length of bytes.
    asm(balance, token_id: result_buffer, ptr: (id, PAUSABLE), bytes: 64, id: id) {
        s256 token_id ptr bytes;
        bal  balance token_id id;
        balance: u64
    }
}
