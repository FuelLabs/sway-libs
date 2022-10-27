library supply;

use ::nft::nft_storage::MAX_SUPPLY;
use std::{storage::{get, store}};

#[storage(read)]
pub fn max_supply() -> u64 {
    get::<u64>(MAX_SUPPLY)
}

#[storage(read, write)]
pub fn set_max_supply(supply: u64) {
    let current_supply = get::<u64>(MAX_SUPPLY);
    require(current_supply == 0, "Cannot reinitialize supply");

    store(MAX_SUPPLY, supply);
}
