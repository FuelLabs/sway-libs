library;

/// Error log for when setting proxy owner is denied.
pub enum SetProxyOwnerError {
    /// Emitted when the owner state is being uninitialized.
    CannotUninitialize: (),
}
