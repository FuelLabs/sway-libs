library;

/// Error log for when access is denied.
pub enum InitializationError {
    /// Emiited when an owner has already been set.
    CannotReinitialized: (),
}
