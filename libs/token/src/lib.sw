library;

mod errors;

use errors::BurnError;
use std::{
    asset_id::construct_asset_id,
    call_frames::{
        contract_id,
        msg_asset_id,
    },
    context::this_balance,
    hash::sha256,
    storage::storage_string::*,
    string::String,
    token::{
        burn,
        mint_to,
    },
};

/// Returns the total number of individual assets for a contract.
///
/// # Arguments
///
/// * `total_assets_storage_key`: [StorageKey<u64>] - The location in storage that the `u64` which represents the total assets are stored.
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
/// use token::_total_assets;
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
pub fn _total_assets(total_assets_storage_key: StorageKey<u64>) -> u64 {
    total_assets_storage_key.try_read().unwrap_or(0)
}

/// Returns the total supply of tokens for an asset.
///
/// # Arguments
///
/// * `total_supply_storage_key`: [StorageKey<StorageMap<AssetId, u64>>] - The location in storage which the `StorageMap` that stores the total supply of assets is stored.
/// * `asset`: [AssetId] - The asset of which to query the total supply.
///
/// # Returns
///
/// * [Option<u64>] - The total supply of tokens for `asset`.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
///
/// # Examples
///
/// ```sway
/// use token::_total_supply;
///
/// storage {
///     total_supply: StorageMap<AssetId, u64> = StorageMap {},
/// }
///
/// fn foo(asset_id: AssetId) {
///     let supply = _total_supply(storage.total_supply, asset_id);
///     assert(supply.unwrap() != 0);
/// }
/// ```
#[storage(read)]
pub fn _total_supply(
    total_supply_storage_key: StorageKey<StorageMap<AssetId, u64>>,
    asset: AssetId,
) -> Option<u64> {
    total_supply_storage_key.get(asset).try_read()
}

/// Returns the name of the asset, such as “Ether”.
///
/// # Arguments
///
/// * `name_storage_key`: [StorageKey<StorageMap<AssetId, StorageKey<StorageString>>>] - The location in storage which the `StorageMap` that stores the names of assets is stored.
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
/// use token::_name;
/// use std::string::String;
///
/// storage {
///     name: StorageMap<AssetId, StorageKey<StorageString>>> = StorageMap {},
/// }
///
/// fn foo(asset: AssetId) {
///     let name = _name(storage.name, asset);
///     assert(name.unwrap().len() != 0);
/// }
/// ```
#[storage(read)]
pub fn _name(
    name_storage_key: StorageKey<StorageMap<AssetId, StorageKey<StorageString>>>,
    asset: AssetId,
) -> Option<String> {
    match name_storage_key.get(asset).try_read() {
        Option::Some(s) => s.read_slice(),
        Option::None(s) => Option::None,
    }
}
/// Returns the symbol of the asset, such as “ETH”.
///
/// # Arguments
///
/// * `symbol_storage_key`: [StorageKey<StorageMap<AssetId, StorageKey<StorageString>>>] - The location in storage which the `StorageMap` that stores the symbols of assets is stored.
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
/// use token::_symbol;
/// use std::string::String;
///
/// storage {
///     symbol: StorageMap<AssetId, StorageKey<StorageString>>> = StorageMap {},
/// }
///
/// fn foo(asset: AssetId) {
///     let symbol = _symbol(storage.symbol, asset);
///     assert(symbol.unwrap().len() != 0);
/// }
/// ```
#[storage(read)]
pub fn _symbol(
    symbol_storage_key: StorageKey<StorageMap<AssetId, StorageKey<StorageString>>>,
    asset: AssetId,
) -> Option<String> {
    match symbol_storage_key.get(asset).try_read() {
        Option::Some(s) => s.read_slice(),
        Option::None(s) => Option::None,
    }
}

/// Returns the number of decimals the asset uses.
///
/// # Additional Information
///
/// e.g. 8, means to divide the token amount by 100000000 to get its user representation.
///
/// # Arguments
///
/// * `decimals_storage_key`: [StorageKey<StorageMap<AssetId, u8>>] - The location in storage which the `StorageMap` that stores the decimals of assets is stored.
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
/// use token::_decimals;
///
/// storage {
///     decimals: StorageMap<AssetId, u8> = StorageMap {},
/// }
///
/// fn foo(asset: AssedId) {
///     let decimals = _decimals(storage.decimals, asset);
///     assert(decimals == 8);
/// }
/// ```
#[storage(read)]
pub fn _decimals(
    decimals_storage_key: StorageKey<StorageMap<AssetId, u8>>,
    asset: AssetId,
) -> Option<u8> {
    decimals_storage_key.get(asset).try_read()
}
/// Unconditionally mints new tokens using the `sub_id` sub-identifier.
///
/// # Arguments
///
/// * `total_assets_storage_key`: [StorageKey<u64>] - The location in storage that the `u64` which represents the total assets are stored.
/// * `total_supply_storage_key`: [StorageKey<StorageMap<AssetId, u64>>] - The location in storage which the `StorageMap` that stores the total supply of assets is stored.
/// * `recipient`: [Identity] - The user to which the newly minted tokens are transferred to.
/// * `sub_id`: [SubId] - The sub-identifier of the newly minted token.
/// * `amount`: [u64] - The quantity of tokens to mint.
///
/// # Returns
///
/// * [AssetId] - The `AssetId` of the newly minted asset.
///
/// # Number of Storage Accesses
///
/// * Reads: `2`
/// * Writes: `2`
///
/// # Examples
///
/// ```sway
/// use token::_mint;
/// use std::{constants::ZERO_B256, context::balance_of};
///
/// storage {
///     total_assets: u64 = 0,
///     total_supply: StorageMap<AssetId, u64> = StorageMap {},
/// }
///
/// fn foo(recipient: Identity) {
///     let recipient = Identity::ContractId(ContractId::from(ZERO_B256));
///     let asset_id = _mint(storage.total_assets, storage.total_supply, recipient, ZERO_B256, 100);
///     balance_of(recipient.as_contract_id(), asset_id)
/// }
/// ```
#[storage(read, write)]
pub fn _mint(
    total_assets_storage_key: StorageKey<u64>,
    total_supply_storage_key: StorageKey<StorageMap<AssetId, u64>>,
    recipient: Identity,
    sub_id: SubId,
    amount: u64,
) -> AssetId {
    let asset_id = construct_asset_id(contract_id(), sub_id);
    let supply = _total_supply(total_supply_storage_key, asset_id);
    // Only increment the number of assets minted by this contract if it hasn't been minted before.
    if supply.is_none() {
        total_assets_storage_key.write(_total_assets(total_assets_storage_key) + 1);
    }
    let current_supply = supply.unwrap_or(0);
    total_supply_storage_key.insert(asset_id, current_supply + amount);
    mint_to(recipient, sub_id, amount);
    asset_id
}
/// Burns tokens with the given `sub_id`.
///
/// # Additional Information
///
/// **Warning** This function burns tokens unequivocally. It does not check that tokens are sent to the calling contract.
///
/// # Arguments
///
/// * `sub_id`: [SubId] - The sub-identifier of the token to burn.
/// * `amount`: [u64] - The quantity of tokens to burn.
///
/// # Reverts
///
/// * When the calling contract does not have enough tokens.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
/// * Writes: `1`
///
/// # Examples
///
/// ```sway
/// use token::_burn;
/// use std::{call_frames::contract_id, constants::ZERO_B256, context::balance_of};
///
/// storage {
///     total_supply: StorageMap<AssetId, u64> = StorageMap {},
/// }
///
/// fn foo(asset_id: AssetId) {
///     assert(balance_of(contract_id(), asset_id) == 100);
///     _burn(storage.total_supply, ZERO_B256, 100);
///     assert(balance_of(contract_id(), asset_id) == 0);
/// }
/// ```
#[storage(read, write)]
fn _burn(
    total_supply_storage_key: StorageKey<StorageMap<AssetId, u64>>,
    sub_id: SubId,
    amount: u64,
) {
    let asset_id = construct_asset_id(contract_id(), sub_id);
    require(this_balance(asset_id) >= amount, BurnError::NotEnoughTokens);
    // If we pass the check above, we can assume it is safe to unwrap.
    let supply = _total_supply(total_supply_storage_key, asset_id).unwrap();
    total_supply_storage_key.insert(asset_id, supply - amount);
    burn(sub_id, amount);
}
/// Unconditionally sets the name of an asset.
///
/// # Additional Information
///
/// NOTE: This does not check whether the asset id provided is valid or already exists.
///
/// # Arguments
///
/// * `name_storage_key`: [StorageKey<StorageMap<AssetId, StorageKey<StorageString>>>] - The location in storage which the `StorageMap` that stores the names of assets is stored.
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
/// use token::{set_name, _name};
/// use std::string::String;
///
/// storage {
///     name: StorageMap<AssetId, StorageKey<StorageString>>> = StorageMap {},
/// }
///
/// fn foo(asset: AssetId) {
///     let name = String::from_ascii_str("Ether");
///     set_name(storage.name, asset, name);
///     assert(_name(storage.name, asset) == name);
/// }
/// ```
#[storage(write)]
pub fn set_name(
    name_storage_key: StorageKey<StorageMap<AssetId, StorageKey<StorageString>>>,
    asset: AssetId,
    name: String,
) {
    let name_string_key: StorageKey<StorageString> = StorageKey {
        slot: sha256((asset, String::from_ascii_str("name_slot"))),
        offset: 0,
        field_id: sha256((asset, String::from_ascii_str("name_field_id"))),
    };
    name_string_key.write_slice(name);
    name_storage_key.insert(asset, name_string_key);
}
/// Unconditionally sets the symbol of an asset.
///
/// # Additional Information
///
/// NOTE: This does not check whether the asset id provided is valid or already exists.
///
/// # Arguments
///
/// * `symbol_storage_key`: [StorageKey<StorageMap<AssetId, StorageKey<StorageString>>>] - The location in storage which the `StorageMap` that stores the symbols of assets is stored.
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
/// use token::{set_symbol, _symbol};
/// use std::string::String;
///
/// storage {
///     symbol: StorageMap<AssetId, StorageKey<StorageString>>> = StorageMap {},
/// }
///
/// fn foo(asset: AssetId) {
///     let symbol = String::from_ascii_str("ETH");
///     set_symbol(storage.symbol, asset, symbol);
///     assert(_symbol(storage.symbol, asset) == symbol);
/// }
/// ```
#[storage(write)]
pub fn set_symbol(
    symbol_storage_key: StorageKey<StorageMap<AssetId, StorageKey<StorageString>>>,
    asset: AssetId,
    symbol: String,
) {
    let symbol_string_key: StorageKey<StorageString> = StorageKey {
        slot: sha256((asset, String::from_ascii_str("symbol_slot"))),
        offset: 0,
        field_id: sha256((asset, String::from_ascii_str("symbol_field_id"))),
    };
    symbol_string_key.write_slice(symbol);
    symbol_storage_key.insert(asset, symbol_string_key);
}
/// Unconditionally sets the decimals of an asset.
///
/// # Additional Information
///
/// NOTE: This does not check whether the asset id provided is valid or already exists.
///
/// # Arguments
///
/// * `decimals_storage_key`: [StorageKey<StorageMap<AssetId, u8>>] - The location in storage which the `StorageMap` that stores the decimals of assets is stored.
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
/// use token::{set_decimals, _decimals};
/// use std::string::String;
///
/// storage {
///     decimals: StorageMap<AssetId, u8> = StorageMap {},
/// }
///
/// fn foo(asset: AssetId) {
///     let decimals = 8u8;
///     set_decimals(storage.decimals, asset, decimals);
///     assert(_decimals(storage.decimals, asset) == decimals);
/// }
/// ```
#[storage(write)]
pub fn set_decimals(
    decimals_storage_key: StorageKey<StorageMap<AssetId, u8>>,
    asset: AssetId,
    decimals: u8,
) {
    decimals_storage_key.insert(asset, decimals);
}
