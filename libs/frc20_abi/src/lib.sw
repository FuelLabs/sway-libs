library frc20_abi;

use std::u256::U256;

abi FRC20 {
    #[storage(read)]
    /// Get the total supply of the token.
    /// MUST track all mint and burn operations.
    /// /// /// MAY store the amount as another type (i.e: 'u64') internally.
    fn total_supply() -> U256;

    /// Get the name of the token
    /// Example (with trailing padding): "MY_TOKEN                                                        "
    fn name() -> str[64];

    /// Get the symbol of the token
    /// Example (with trailing padding): "TKN                             "
    fn symbol() -> str[32];

    /// Get the decimals of the token
    fn decimals() -> u8;
}
