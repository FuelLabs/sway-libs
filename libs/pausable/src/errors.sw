library;

/// Error emitted upon the opposite of the desired pause state.
pub enum PauseError {
    /// Emitted when the contract is paused.
    Paused: (),
    /// Emitted when the contract is not paused.
    NotPaused: (),
}
