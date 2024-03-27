library;

/// Error log for when something goes wrong when burning assets.
pub enum BurnError {
    /// Emitted when there are not enough coins owned by the contract to burn.
    NotEnoughCoins: (),
}
