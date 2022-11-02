library supply;

use ::nft::nft_storage::MAX_SUPPLY;
use std::{storage::{get, store}};

/// Returns the maximum supply that has been set for the NFT library.
#[storage(read)]
pub fn max_supply() -> Option<u64> {
    get::<Option<u64>>(MAX_SUPPLY)
}

/// Sets the maximum supply for the NFT library.
///
/// # Arguments
///
/// * `supply` - The maximum number fo tokens which may be minted
///
/// # Reverts
///
/// * When the supply has already been set
#[storage(read, write)]
pub fn set_max_supply(supply: Option<u64>) {
    let current_supply = get::<Option<u64>>(MAX_SUPPLY);
    require(current_supply.is_none(), "Cannot reinitialize supply");

    store(MAX_SUPPLY, supply);
}
