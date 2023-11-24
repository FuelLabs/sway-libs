library;

/// Error log for when access is denied.
pub enum AddminError {
    /// Emiited when the caller is not an admin.
    NotAdmin: (),
}
