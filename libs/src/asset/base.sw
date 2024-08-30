library;

use std::{hash::{Hash, sha256}, storage::storage_string::*, string::String};
use standards::src20::{SetDecimalsEvent, SetNameEvent, SetSymbolEvent};
use ::asset::errors::SetMetadataError;

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
/// use sway_libs::asset::base::_total_assets;
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
/// use sway_libs::asset::base::_total_supply;
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
/// use sway_libs::asset::base::_name;
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
/// use sway_libs::asset::base::_symbol;
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
/// use sway_libs::asset::base::_decimals;
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
/// # Reverts
///
/// * When passing an empty string.
///
/// # Number of Storage Accesses
///
/// * Writes: `2`
///
/// # Examples
///
/// ```sway
/// use sway_libs::asset::base::{_set_name, _name};
/// use std::string::String;
///
/// storage {
///     name: StorageMap<AssetId, StorageString> = StorageMap {},
/// }
///
/// fn foo(asset: AssetId) {
///     let name = String::from_ascii_str("Ether");
///     _set_name(storage.name, asset, name);
///     assert(_name(storage.name, asset).unwrap() == name);
/// }
/// ```
#[storage(write)]
pub fn _set_name(
    name_key: StorageKey<StorageMap<AssetId, StorageString>>,
    asset: AssetId,
    name: String,
) {
    require(!name.is_empty(), SetMetadataError::EmptyString);

    name_key.insert(asset, StorageString {});
    name_key.get(asset).write_slice(name);

    log(SetNameEvent {
        asset,
        name: Some(name),
        sender: msg_sender().unwrap(),
    });
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
/// # Reverts
///
/// * When passing an empty string.
///
/// # Number of Storage Accesses
///
/// * Writes: `2`
///
/// # Examples
///
/// ```sway
/// use sway_libs::asset::base::{_set_symbol, _symbol};
/// use std::string::String;
///
/// storage {
///     symbol: StorageMap<AssetId, StorageString> = StorageMap {},
/// }
///
/// fn foo(asset: AssetId) {
///     let symbol = String::from_ascii_str("ETH");
///     _set_symbol(storage.symbol, asset, symbol);
///     assert(_symbol(storage.symbol, asset).unwrap() == symbol);
/// }
/// ```
#[storage(write)]
pub fn _set_symbol(
    symbol_key: StorageKey<StorageMap<AssetId, StorageString>>,
    asset: AssetId,
    symbol: String,
) {
    require(!symbol.is_empty(), SetMetadataError::EmptyString);

    symbol_key.insert(asset, StorageString {});
    symbol_key.get(asset).write_slice(symbol);

    log(SetSymbolEvent {
        asset,
        symbol: Some(symbol),
        sender: msg_sender().unwrap(),
    });
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
/// use sway_libs::asset::base::{_set_decimals, _decimals};
///
/// storage {
///     decimals: StorageMap<AssetId, u8> = StorageMap {},
/// }
///
/// fn foo(asset: AssetId) {
///     let decimals = 8u8;
///     _set_decimals(storage.decimals, asset, decimals);
///     assert(_decimals(storage.decimals, asset).unwrap() == decimals);
/// }
/// ```
#[storage(write)]
pub fn _set_decimals(
    decimals_key: StorageKey<StorageMap<AssetId, u8>>,
    asset: AssetId,
    decimals: u8,
) {
    decimals_key.insert(asset, decimals);

    log(SetDecimalsEvent {
        asset,
        decimals,
        sender: msg_sender().unwrap(),
    });
}

abi SetAssetAttributes {
    /// Stores the name for a specific asset.
    ///
    /// # Arguments
    ///
    /// * `asset`: [AssetId] - The asset for the name to be stored.
    /// * `name`: [String] - The name which to be stored.
    ///
    /// # Example
    ///
    /// ```sway
    /// use standards::src20::SRC20;
    /// use sway_libs::asset::base::*;
    /// use std::string::String;
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, name: String) {
    ///     let contract_abi = abi(SetAssetAttributes, contract_id.bits());
    ///     contract_abi.set_name(asset, name);
    ///     assert(contract_abi.name(asset) == name);
    /// }
    /// ```
    #[storage(write)]
    fn set_name(asset: AssetId, name: String);
    /// Stores the symbol for a specific asset.
    ///
    /// # Arguments
    ///
    /// * `asset`: [AssetId] - The asset for the symbol to be stored.
    /// * `symbol`: [String] - The symbol which to be stored.
    ///
    /// # Example
    ///
    /// ```sway
    /// use standards::src20::SRC20;
    /// use sway_libs::asset::base::*;
    /// use std::string::String;
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, symbol: String) {
    ///     let contract_abi = abi(SetAssetAttributes, contract_id.bits());
    ///     contract_abi.set_symbol(asset, symbol);
    ///     assert(contract_abi.symbol(asset) == symbol);
    /// }
    /// ```
    #[storage(write)]
    fn set_symbol(asset: AssetId, symbol: String);
    /// Stores the decimals for a specific asset.
    ///
    /// # Arguments
    ///
    /// * `asset`: [AssetId] - The asset for the symbol to be stored.
    /// * `decimals`: [u8] - The decimals which to be stored.
    ///
    /// # Example
    ///
    /// ```sway
    /// use standards::src20::SRC20;
    /// use sway_libs::asset::base::*;
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, decimals: u8) {
    ///     let contract_abi = abi(SetAssetAttributes, contract_id.bits());
    ///     contract_abi.set_decimals(asset, decimals);
    ///     assert(contract_abi.decimals(asset).unwrap() == decimals);
    /// }
    /// ```
    #[storage(write)]
    fn set_decimals(asset: AssetId, decimals: u8);
}
