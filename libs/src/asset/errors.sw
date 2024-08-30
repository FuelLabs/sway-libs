library;

/// Error log for when something goes wrong when burning assets.
pub enum BurnError {
    /// Emitted when there are not enough coins owned by the contract to burn.
    NotEnoughCoins: (),
    /// Emitted when attempting to burn zero coins.
    ZeroAmount: (),
}

/// Error log for when something goes wrong when minting assets.
pub enum MintError {
    /// Emitted when attempting to mint zero coins.
    ZeroAmount: (),
}

/// Error log for when something goes wrong when setting metadata.
pub enum SetMetadataError {
    /// Emitted when the metadata is an empty string.
    EmptyString: (),
    /// Emitted when the metadata is empty bytes.
    EmptyBytes: (),
}
