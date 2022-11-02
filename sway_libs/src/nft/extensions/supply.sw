library supply;

use ::nft::nft_storage::MAX_SUPPLY;
use std::{storage::{get, store}};

#[storage(read)]
pub fn max_supply() -> Option<u64> {
    get::<Option<u64>>(MAX_SUPPLY)
}

#[storage(read, write)]
pub fn set_max_supply(supply: Option<u64>) {
    let current_supply = get::<Option<u64>>(MAX_SUPPLY);
    require(current_supply.is_none(), "Cannot reinitialize supply");

    store(MAX_SUPPLY, supply);
}
