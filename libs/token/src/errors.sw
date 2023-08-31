library;

/// Error log for when something goes wrong when burning tokens.
pub enum BurnError {
    /// Emitted when there are not enough tokens owned by the contract to burn.
    NotEnoughTokens: (),
}
