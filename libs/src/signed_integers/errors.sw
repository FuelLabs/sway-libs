library;

/// Error log for when unexpected behavior has occurred.
pub enum Error {
    /// Emitted when division by zero has occured.
    ZeroDivisor: (),
}
