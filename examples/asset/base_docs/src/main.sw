contract;

use std::{hash::*, storage::storage_string::*, string::String};

// ANCHOR: import
use asset::base::*;
use standards::src20::*;
// ANCHOR_END: import

// ANCHOR: src20_abi
abi SRC20 {
    #[storage(read)]
    fn total_assets() -> u64;
    #[storage(read)]
    fn total_supply(asset: AssetId) -> Option<u64>;
    #[storage(read)]
    fn name(asset: AssetId) -> Option<String>;
    #[storage(read)]
    fn symbol(asset: AssetId) -> Option<String>;
    #[storage(read)]
    fn decimals(asset: AssetId) -> Option<u8>;
}
// ANCHOR_END: src20_abi

// ANCHOR: set_attributes
abi SetAssetAttributes {
    #[storage(write)]
    fn set_name(asset: AssetId, name: String);
    #[storage(write)]
    fn set_symbol(asset: AssetId, symbol: String);
    #[storage(write)]
    fn set_decimals(asset: AssetId, decimals: u8);
}
// ANCHOR_END: set_attributes

// ANCHOR: src20_storage
storage {
    total_assets: u64 = 0,
    total_supply: StorageMap<AssetId, u64> = StorageMap {},
    name: StorageMap<AssetId, StorageString> = StorageMap {},
    symbol: StorageMap<AssetId, StorageString> = StorageMap {},
    decimals: StorageMap<AssetId, u8> = StorageMap {},
}
// ANCHOR_END: src20_storage
