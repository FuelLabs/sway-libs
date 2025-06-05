library;

/// Error log for when access is denied.
pub enum AdminError {
    /// Emitted when the caller is not an admin.
    NotAdmin: (),
}
