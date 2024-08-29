contract;

// ANCHOR: setting_src20_attributes
use sway_libs::asset::base::*;
use std::{hash::Hash, storage::storage_string::*, string::String};

storage {
    name: StorageMap<AssetId, StorageString> = StorageMap {},
    symbol: StorageMap<AssetId, StorageString> = StorageMap {},
    decimals: StorageMap<AssetId, u8> = StorageMap {},
}

impl SetAssetAttributes for Contract {
    #[storage(write)]
    fn set_name(asset: AssetId, name: Option<String>) {
        _set_name(storage.name, asset, name);
    }

    #[storage(write)]
    fn set_symbol(asset: AssetId, symbol: Option<String>) {
        _set_symbol(storage.symbol, asset, symbol);
    }

    #[storage(write)]
    fn set_decimals(asset: AssetId, decimals: u8) {
        _set_decimals(storage.decimals, asset, decimals);
    }
}
// ANCHOR_END: setting_src20_attributes
