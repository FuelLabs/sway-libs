contract;

// ANCHOR: basic_src20
use asset::base::{_decimals, _name, _symbol, _total_assets, _total_supply};
use standards::src20::SRC20;
use std::{hash::Hash, storage::storage_string::*, string::String};

// The SRC-20 storage block
storage {
    total_assets: u64 = 0,
    total_supply: StorageMap<AssetId, u64> = StorageMap {},
    name: StorageMap<AssetId, StorageString> = StorageMap {},
    symbol: StorageMap<AssetId, StorageString> = StorageMap {},
    decimals: StorageMap<AssetId, u8> = StorageMap {},
}

// Implement the SRC-20 Standard for this contract
impl SRC20 for Contract {
    #[storage(read)]
    fn total_assets() -> u64 {
        // Pass the `total_assets` StorageKey to `_total_assets()` from the Asset Library.
        _total_assets(storage.total_assets)
    }

    #[storage(read)]
    fn total_supply(asset: AssetId) -> Option<u64> {
        // Pass the `total_supply` StorageKey to `_total_supply()` from the Asset Library.
        _total_supply(storage.total_supply, asset)
    }

    #[storage(read)]
    fn name(asset: AssetId) -> Option<String> {
        // Pass the `name` StorageKey to `_name_()` from the Asset Library.
        _name(storage.name, asset)
    }

    #[storage(read)]
    fn symbol(asset: AssetId) -> Option<String> {
        // Pass the `symbol` StorageKey to `_symbol_()` function from the Asset Library.
        _symbol(storage.symbol, asset)
    }

    #[storage(read)]
    fn decimals(asset: AssetId) -> Option<u8> {
        // Pass the `decimals` StorageKey to `_decimals_()` function from the Asset Library.
        _decimals(storage.decimals, asset)
    }
}
// ANCHOR_END: basic_src20
