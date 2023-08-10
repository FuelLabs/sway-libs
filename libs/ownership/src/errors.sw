library;

/// Error log for when access is denied.
pub enum AccessError {
    /// Emiited when an owner has already been set.
    CannotReinitialized: (),
    /// Emitted when the caller is not the owner of the contract.
    NotOwner: (),
}
