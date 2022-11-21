library nft_storage;

// TODO: These are temporary storage keys for manual storage management. These should be removed once
// https://github.com/FuelLabs/sway/issues/2585 is resolved.
pub const ADMIN: b256 = 0x1000000000000000000000000000000000000000000000000000000000000000;
pub const APPROVED: b256 = 0x2000000000000000000000000000000000000000000000000000000000000000;
pub const BALANCES: b256 = 0x3000000000000000000000000000000000000000000000000000000000000000;
pub const MAX_SUPPLY: b256 = 0x4000000000000000000000000000000000000000000000000000000000000000;
pub const METADATA: b256 = 0x5000000000000000000000000000000000000000000000000000000000000000;
pub const OPERATOR_APPROVAL: b256 = 0x6000000000000000000000000000000000000000000000000000000000000000;
pub const TOKENS: b256 = 0x7000000000000000000000000000000000000000000000000000000000000000;
pub const TOKENS_MINTED: b256 = 0x8000000000000000000000000000000000000000000000000000000000000000;
