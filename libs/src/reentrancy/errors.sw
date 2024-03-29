library;

/// Error log for when reentrancy has been detected
pub enum ReentrancyError {
    /// Emitted when the caller is a reentrant.
    NonReentrant: (),
}
