library;

use ::asset::errors::BurnError;
use ::asset::base::{_total_assets, _total_supply};
use std::{
    asset::{
        burn,
        mint_to,
    },
    call_frames::{
        contract_id,
        msg_asset_id,
    },
    context::this_balance,
    hash::{
        Hash,
        sha256,
    },
    storage::storage_string::*,
    string::String,
};

/// Unconditionally mints new assets using the `sub_id` sub-identifier.
///
/// # Arguments
///
/// * `total_assets_key`: [StorageKey<u64>] - The location in storage that the `u64` which represents the total assets is stored.
/// * `total_supply_key`: [StorageKey<StorageMap<AssetId, u64>>] - The location in storage which the `StorageMap` that stores the total supply of assets is stored.
/// * `recipient`: [Identity] - The user to which the newly minted asset is transferred to.
/// * `sub_id`: [SubId] - The sub-identifier of the newly minted asset.
/// * `amount`: [u64] - The quantity of coins to mint.
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
/// use sway_libs::asset::supply::_mint;
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
///     assert(balance_of(recipient.as_contract_id(), asset_id), 100);
/// }
/// ```
#[storage(read, write)]
pub fn _mint(
    total_assets_key: StorageKey<u64>,
    total_supply_key: StorageKey<StorageMap<AssetId, u64>>,
    recipient: Identity,
    sub_id: SubId,
    amount: u64,
) -> AssetId {
    let asset_id = AssetId::new(contract_id(), sub_id);
    let supply = _total_supply(total_supply_key, asset_id);
    // Only increment the number of assets minted by this contract if it hasn't been minted before.
    if supply.is_none() {
        total_assets_key.write(_total_assets(total_assets_key) + 1);
    }
    let current_supply = supply.unwrap_or(0);
    total_supply_key.insert(asset_id, current_supply + amount);
    mint_to(recipient, sub_id, amount);
    asset_id
}

/// Burns assets with the given `sub_id`.
///
/// # Additional Information
///
/// **Warning** This function burns assets unequivocally. It does not check that assets are sent to the calling contract.
///
/// # Arguments
///
/// * `total_assets_key`: [StorageKey<u64>] - The location in storage that the `u64` which represents the total assets is stored.
/// * `sub_id`: [SubId] - The sub-identifier of the asset to burn.
/// * `amount`: [u64] - The quantity of coins to burn.
///
/// # Reverts
///
/// * When the calling contract does not have enough assets.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
/// * Writes: `1`
///
/// # Examples
///
/// ```sway
/// use sway_libs::asset::supply::_burn;
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
pub fn _burn(
    total_supply_key: StorageKey<StorageMap<AssetId, u64>>,
    sub_id: SubId,
    amount: u64,
) {
    let asset_id = AssetId::new(contract_id(), sub_id);
    require(this_balance(asset_id) >= amount, BurnError::NotEnoughCoins);
    // If we pass the check above, we can assume it is safe to unwrap.
    let supply = _total_supply(total_supply_key, asset_id).unwrap();
    total_supply_key.insert(asset_id, supply - amount);
    burn(sub_id, amount);
}
