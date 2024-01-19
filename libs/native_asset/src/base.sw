library;

use std::{hash::{Hash, sha256}, storage::storage_string::*, string::String};

/// Returns the total number of individual assets for a contract.
///
/// # Arguments
///
/// * `total_assets_key`: [StorageKey<u64>] - The location in storage that the `u64` which represents the total assets is stored.
///
/// # Returns
///
/// * [u64] - The number of assets that this contract has minted.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use asset::_total_assets;
///
/// storage {
///     total_assets: u64 = 0,
/// }
///
/// fn foo() {
///     let assets = _total_assets(storage.total_assets);
///     assert(assets == 0);
/// }
/// ```
#[storage(read)]
pub fn _total_assets(total_assets_key: StorageKey<u64>) -> u64 {
    total_assets_key.try_read().unwrap_or(0)
}

/// Returns the total supply of coins for an asset.
///
/// # Arguments
///
/// * `total_supply_key`: [StorageKey<StorageMap<AssetId, u64>>] - The location in storage which the `StorageMap` that stores the total supply of assets is stored.
/// * `asset`: [AssetId] - The asset of which to query the total supply.
///
/// # Returns
///
/// * [Option<u64>] - The total supply of an `asset`.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use asset::_total_supply;
///
/// storage {
///     total_supply: StorageMap<AssetId, u64> = StorageMap {},
/// }
///
/// fn foo(asset_id: AssetId) {
///     let supply = _total_supply(storage.total_supply, asset_id);
///     assert(supply.unwrap_or(0) != 0);
/// }
/// ```
#[storage(read)]
pub fn _total_supply(
    total_supply_key: StorageKey<StorageMap<AssetId, u64>>,
    asset: AssetId,
) -> Option<u64> {
    total_supply_key.get(asset).try_read()
}

/// Returns the name of the asset, such as “Ether”.
///
/// # Arguments
///
/// * `name_key`: [StorageKey<StorageMap<AssetId, StorageKey<StorageString>>>] - The location in storage which the `StorageMap` that stores the names of assets is stored.
/// * `asset`: [AssetId] - The asset of which to query the name.
///
/// # Returns
///
/// * [Option<String>] - The name of `asset`.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use asset::_name;
/// use std::string::String;
///
/// storage {
///     name: StorageMap<AssetId, StorageString> = StorageMap {},
/// }
///
/// fn foo(asset: AssetId) {
///     let name = _name(storage.name, asset);
///     assert(name.unwrap_or(String::new()).len() != 0);
/// }
/// ```
#[storage(read)]
pub fn _name(
    name_key: StorageKey<StorageMap<AssetId, StorageString>>,
    asset: AssetId,
) -> Option<String> {
    name_key.get(asset).read_slice()
}
/// Returns the symbol of the asset, such as “ETH”.
///
/// # Arguments
///
/// * `symbol_key`: [StorageKey<StorageMap<AssetId, StorageKey<StorageString>>>] - The location in storage which the `StorageMap` that stores the symbols of assets is stored.
/// * `asset`: [AssetId] - The asset of which to query the symbol.
///
/// # Returns
///
/// * [Option<String>] - The symbol of `asset`.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use asset::_symbol;
/// use std::string::String;
///
/// storage {
///     symbol: StorageMap<AssetId, StorageString> = StorageMap {},
/// }
///
/// fn foo(asset: AssetId) {
///     let symbol = _symbol(storage.symbol, asset);
///     assert(symbol.unwrap_or(String::new()).len() != 0);
/// }
/// ```
#[storage(read)]
pub fn _symbol(
    symbol_key: StorageKey<StorageMap<AssetId, StorageString>>,
    asset: AssetId,
) -> Option<String> {
    symbol_key.get(asset).read_slice()
}
/// Returns the number of decimals the asset uses.
///
/// # Additional Information
///
/// e.g. 8, means to divide the coins amount by 100000000 to get its user representation.
///
/// # Arguments
///
/// * `decimals_key`: [StorageKey<StorageMap<AssetId, u8>>] - The location in storage which the `StorageMap` that stores the decimals of assets is stored.
/// * `asset`: [AssetId] - The asset of which to query the decimals.
///
/// # Returns
///
/// * [Option<u8>] - The decimal precision used by `asset`.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use asset::_decimals;
///
/// storage {
///     decimals: StorageMap<AssetId, u8> = StorageMap {},
/// }
///
/// fn foo(asset: AssedId) {
///     let decimals = _decimals(storage.decimals, asset);
///     assert(decimals.unwrap_or(0u8) == 8);
/// }
/// ```
#[storage(read)]
pub fn _decimals(
    decimals_key: StorageKey<StorageMap<AssetId, u8>>,
    asset: AssetId,
) -> Option<u8> {
    decimals_key.get(asset).try_read()
}
/// Unconditionally sets the name of an asset.
///
/// # Additional Information
///
/// NOTE: This does not check whether the asset id provided is valid or already exists.
///
/// # Arguments
///
/// * `name_key`: [StorageKey<StorageMap<AssetId, StorageKey<StorageString>>>] - The location in storage which the `StorageMap` that stores the names of assets is stored.
/// * `asset`: [AssetId] - The asset of which to set the name.
/// * `name`: [String] - The name of the asset.
///
/// # Number of Storage Accesses
///
/// * Writes: `2`
///
/// # Examples
///
/// ```sway
/// use asset::{_set_name, _name};
/// use std::string::String;
///
/// storage {
///     name: StorageMap<AssetId, StorageString> = StorageMap {},
/// }
///
/// fn foo(asset: AssetId) {
///     let name = String::from_ascii_str("Ether");
///     _set_name(storage.name, asset, name);
///     assert(_name(storage.name, asset) == name);
/// }
/// ```
#[storage(write)]
pub fn _set_name(
    name_key: StorageKey<StorageMap<AssetId, StorageString>>,
    asset: AssetId,
    name: String,
) {
    name_key.insert(asset, StorageString {});
    name_key.get(asset).write_slice(name);
}
/// Unconditionally sets the symbol of an asset.
///
/// # Additional Information
///
/// NOTE: This does not check whether the asset id provided is valid or already exists.
///
/// # Arguments
///
/// * `symbol_key`: [StorageKey<StorageMap<AssetId, StorageKey<StorageString>>>] - The location in storage which the `StorageMap` that stores the symbols of assets is stored.
/// * `asset`: [AssetId] - The asset of which to set the symbol.
/// * `symbol`: [String] - The symbol of the asset.
///
/// # Number of Storage Accesses
///
/// * Writes: `2`
///
/// # Examples
///
/// ```sway
/// use asset::{_set_symbol, _symbol};
/// use std::string::String;
///
/// storage {
///     symbol: StorageMap<AssetId, StorageString> = StorageMap {},
/// }
///
/// fn foo(asset: AssetId) {
///     let symbol = String::from_ascii_str("ETH");
///     _set_symbol(storage.symbol, asset, symbol);
///     assert(_symbol(storage.symbol, asset) == symbol);
/// }
/// ```
#[storage(write)]
pub fn _set_symbol(
    symbol_key: StorageKey<StorageMap<AssetId, StorageString>>,
    asset: AssetId,
    symbol: String,
) {
    symbol_key.insert(asset, StorageString {});
    symbol_key.get(asset).write_slice(symbol);
}
/// Unconditionally sets the decimals of an asset.
///
/// # Additional Information
///
/// NOTE: This does not check whether the asset id provided is valid or already exists.
///
/// # Arguments
///
/// * `decimals_key`: [StorageKey<StorageMap<AssetId, u8>>] - The location in storage which the `StorageMap` that stores the decimals of assets is stored.
/// * `asset`: [AssetId] - The asset of which to set the decimals.
/// * `decimal`: [u8] - The decimals of the asset.
///
/// # Number of Storage Accesses
///
/// * Writes: `1`
///
/// # Examples
///
/// ```sway
/// use asset::{_set_decimals, _decimals};
/// use std::string::String;
///
/// storage {
///     decimals: StorageMap<AssetId, u8> = StorageMap {},
/// }
///
/// fn foo(asset: AssetId) {
///     let decimals = 8u8;
///     _set_decimals(storage.decimals, asset, decimals);
///     assert(_decimals(storage.decimals, asset) == decimals);
/// }
/// ```
#[storage(write)]
pub fn _set_decimals(
    decimals_key: StorageKey<StorageMap<AssetId, u8>>,
    asset: AssetId,
    decimals: u8,
) {
    decimals_key.insert(asset, decimals);
}
abi SetAssetAttributes {
    #[storage(write)]
    fn set_name(asset: AssetId, name: String);
    #[storage(write)]
    fn set_symbol(asset: AssetId, symbol: String);
    #[storage(write)]
    fn set_decimals(asset: AssetId, decimals: u8);
}
