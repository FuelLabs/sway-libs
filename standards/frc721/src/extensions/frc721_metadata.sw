library;

/// Any contract that implements FRC721_metadata SHALL also implement FRC721.
abi FRC721_metadata {
    /// Get the name of the token
    /// Example (with trailing padding): "MY_TOKEN                                                        "
    fn name() -> str[64];
    /// Get the symbol of the token
    /// Example (with trailing padding): "TKN                             "
    fn symbol() -> str[32];
    /// A distinct Uniform Resource Identifier (URI) for a given asset.
    /// URIs are defined in FRC-3986.
    /// NOTE: This will be updated with StorageString once https://github.com/FuelLabs/sway-libs/issues/40 is merged.
    fn uri(token_id: u64) -> str[2048];
}
