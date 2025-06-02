//! A reentrancy check for use in Sway contracts.
//! Note that this only works in internal contexts.
//! to prevent reentrancy: `assert(!is_reentrant());`
library;

pub mod errors;

use ::errors::ReentrancyError;
use std::call_frames::*;
use std::registers::frame_ptr;

/// Reverts if the reentrancy pattern is detected in the contract in which this is called.
///
/// # Additional Information
///
/// Not needed if the Checks-Effects-Interactions (CEI) pattern is followed (as prompted by the
/// compiler).
///
/// # Examples
///
/// ```sway
/// use reentrancy::reentrancy_guard;
///
/// fn foo() {
///     reentrancy_guard();
///     // Do critical stuff here
/// }
/// ```
pub fn reentrancy_guard() {
    require(!is_reentrant(), ReentrancyError::NonReentrant);
}

/// Returns `true` if the reentrancy pattern is detected, and `false` otherwise.
///
/// # Additional Information
///
/// Detects reentrancy by iteratively checking previous calls in the current call stack for a
/// contract ID equal to the current contract ID. If a match is found, it returns true, else false.
///
/// # Returns
///
/// * [bool] - `true` if reentrancy pattern has occurred.
///
/// # Examples
///
/// ```sway
/// use reentrancy::is_reentrant;
///
/// fn foo() {
///     assert(is_reentrant() == false);
///     // Do critical stuff here
/// }
/// ```
pub fn is_reentrant() -> bool {
    // Get our current contract ID
    let this_id = ContractId::this();

    // Reentrancy cannot occur in an external context. If not detected by the time we get to the
    // bottom of the call_frame stack, then no reentrancy has occurred.
    let mut call_frame_pointer = frame_ptr();
    if !call_frame_pointer.is_null() {
        call_frame_pointer = get_previous_frame_pointer(call_frame_pointer);
    };
    while !call_frame_pointer.is_null() {
        // get the ContractId value from the previous call frame
        let previous_contract_id = get_contract_id_from_call_frame(call_frame_pointer);
        if previous_contract_id == this_id {
            return true;
        };
        call_frame_pointer = get_previous_frame_pointer(call_frame_pointer);
    }

    // The current contract ID wasn't found in any contract calls prior to here.
    false
}
