library frc721_metadata;

/**
The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”,
“SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be
interpreted as described in RFC 2119: https://www.ietf.org/rfc/rfc2119.txt
*/

/// Any contract that implements FRC721_metadata SHALL also implement FRC721.
abi FRC721_metadata {
    /// Get the name of the token
    /// Example (with trailing padding): "MY_TOKEN                                                        "
    fn name() -> str[64];

    /// Get the symbol of the token
    /// Example (with trailing padding): "TKN                             "
    fn symbol() -> str[32];

    /// Get the base URI for the token contract. 
    /// URIs are defined in FRC-3986.
    /// NOTE: This is the base URI, not a URI for individual tokens. This will be updated once
    /// https://github.com/FuelLabs/sway-libs/issues/40 is merged
    fn uri(token_id: u64) -> str[2048];
}