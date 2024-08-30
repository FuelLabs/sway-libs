library;

use ::asset::errors::{BurnError, MintError};
use ::asset::base::{_total_assets, _total_supply};
use std::{
    asset::{
        burn,
        mint_to,
    },
    call_frames::msg_asset_id,
    context::this_balance,
    hash::{
        Hash,
        sha256,
    },
    storage::storage_string::*,
    string::String,
};
use standards::src20::TotalSupplyEvent;

/// Unconditionally mints new assets using the `sub_id` sub-identifier.
///
/// # Additional Information
///
/// **Warning** This function increases the total supply by the number of coins minted.
/// **Note:** If `None` is passed for the `sub_id` argument, `b256::zero()` is used as the `SubId`.
///
/// # Arguments
///
/// * `total_assets_key`: [StorageKey<u64>] - The location in storage that the `u64` which represents the total assets is stored.
/// * `total_supply_key`: [StorageKey<StorageMap<AssetId, u64>>] - The location in storage which the `StorageMap` that stores the total supply of assets is stored.
/// * `recipient`: [Identity] - The user to which the newly minted asset is transferred to.
/// * `sub_id`: [Option<SubId>] - The sub-identifier of the newly minted asset.
/// * `amount`: [u64] - The quantity of coins to mint.
///
/// # Returns
///
/// * [AssetId] - The `AssetId` of the newly minted asset.
///
/// # Reverts
///
/// * When `amount` is zero.
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
/// use std::context::balance_of;
///
/// storage {
///     total_assets: u64 = 0,
///     total_supply: StorageMap<AssetId, u64> = StorageMap {},
/// }
///
/// fn foo(recipient: Identity) {
///     let recipient = Identity::ContractId(ContractId::zero());
///     let asset_id = _mint(storage.total_assets, storage.total_supply, recipient, SubId::zero(), 100);
///     assert(balance_of(recipient.as_contract_id(), asset_id), 100);
/// }
/// ```
#[storage(read, write)]
pub fn _mint(
    total_assets_key: StorageKey<u64>,
    total_supply_key: StorageKey<StorageMap<AssetId, u64>>,
    recipient: Identity,
    sub_id: Option<SubId>,
    amount: u64,
) -> AssetId {
    require(amount > 0, MintError::ZeroAmount);
    let sub_id = match sub_id {
        Some(id) => id,
        None => b256::zero(),
    };
    let asset_id = AssetId::new(ContractId::this(), sub_id);
    let supply = _total_supply(total_supply_key, asset_id);

    // Only increment the number of assets minted by this contract if it hasn't been minted before.
    if supply.is_none() {
        total_assets_key.write(_total_assets(total_assets_key) + 1);
    }

    let current_supply = supply.unwrap_or(0);
    total_supply_key.insert(asset_id, current_supply + amount);

    mint_to(recipient, sub_id, amount);
    log(TotalSupplyEvent {
        asset: asset_id,
        supply: current_supply + amount,
        sender: msg_sender().unwrap(),
    });

    asset_id
}

/// Burns assets with the given `sub_id`.
///
/// # Additional Information
///
/// **Warning** This function burns assets unequivocally. It does not check that assets are sent to the calling contract.
/// **Warning** This function reduces the total supply by the number of coins burned. Using this value when minting may cause unintended consequences.
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
/// * When `amount` is zero.
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
/// use std::{call_frames::contract_id, context::balance_of};
///
/// storage {
///     total_supply: StorageMap<AssetId, u64> = StorageMap {},
/// }
///
/// fn foo(asset_id: AssetId) {
///     assert(balance_of(contract_id(), asset_id) == 100);
///     _burn(storage.total_supply, SubId::zero(), 100);
///     assert(balance_of(contract_id(), asset_id) == 0);
/// }
/// ```
#[storage(read, write)]
pub fn _burn(
    total_supply_key: StorageKey<StorageMap<AssetId, u64>>,
    sub_id: SubId,
    amount: u64,
) {
    require(amount > 0, BurnError::ZeroAmount);
    let asset_id = AssetId::new(ContractId::this(), sub_id);

    require(this_balance(asset_id) >= amount, BurnError::NotEnoughCoins);

    // If we pass the check above, we can assume it is safe to unwrap.
    let supply = _total_supply(total_supply_key, asset_id).unwrap();
    total_supply_key.insert(asset_id, supply - amount);

    burn(sub_id, amount);
    log(TotalSupplyEvent {
        asset: asset_id,
        supply: supply - amount,
        sender: msg_sender().unwrap(),
    });
}
