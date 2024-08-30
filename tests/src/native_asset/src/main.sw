contract;

use standards::{src20::SRC20, src3::SRC3, src7::{Metadata, SRC7}};
use sway_libs::asset::{
    base::{
        _decimals,
        _name,
        _set_decimals,
        _set_name,
        _set_symbol,
        _symbol,
        _total_assets,
        _total_supply,
        SetAssetAttributes,
    },
    metadata::*,
    supply::{
        _burn,
        _mint,
    },
};
use std::{hash::Hash, storage::storage_string::*, string::String};

storage {
    total_assets: u64 = 0,
    total_supply: StorageMap<AssetId, u64> = StorageMap {},
    name: StorageMap<AssetId, StorageString> = StorageMap {},
    symbol: StorageMap<AssetId, StorageString> = StorageMap {},
    decimals: StorageMap<AssetId, u8> = StorageMap {},
    metadata: StorageMetadata = StorageMetadata {},
}

impl SRC20 for Contract {
    #[storage(read)]
    fn total_assets() -> u64 {
        _total_assets(storage.total_assets)
    }

    #[storage(read)]
    fn total_supply(asset: AssetId) -> Option<u64> {
        _total_supply(storage.total_supply, asset)
    }

    #[storage(read)]
    fn name(asset: AssetId) -> Option<String> {
        _name(storage.name, asset)
    }

    #[storage(read)]
    fn symbol(asset: AssetId) -> Option<String> {
        _symbol(storage.symbol, asset)
    }

    #[storage(read)]
    fn decimals(asset: AssetId) -> Option<u8> {
        _decimals(storage.decimals, asset)
    }
}

impl SRC3 for Contract {
    #[storage(read, write)]
    fn mint(recipient: Identity, sub_id: Option<SubId>, amount: u64) {
        let _ = _mint(
            storage
                .total_assets,
            storage
                .total_supply,
            recipient,
            sub_id,
            amount,
        );
    }

    #[payable]
    #[storage(read, write)]
    fn burn(sub_id: SubId, amount: u64) {
        _burn(storage.total_supply, sub_id, amount);
    }
}

impl SRC7 for Contract {
    #[storage(read)]
    fn metadata(asset: AssetId, key: String) -> Option<Metadata> {
        _metadata(storage.metadata, asset, key)
    }
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

impl SetAssetMetadata for Contract {
    #[storage(read, write)]
    fn set_metadata(asset: AssetId, metadata: Option<Metadata>, key: String) {
        _set_metadata(storage.metadata, asset, metadata, key);
    }
}

#[test]
fn test_total_assets() {
    let src3_abi = abi(SRC3, CONTRACT_ID);
    let src20_abi = abi(SRC20, CONTRACT_ID);

    let recipient = Identity::ContractId(ContractId::from(CONTRACT_ID));
    let sub_id1 = 0x0000000000000000000000000000000000000000000000000000000000000001;
    let sub_id2 = 0x0000000000000000000000000000000000000000000000000000000000000002;

    assert(src20_abi.total_assets() == 0);

    src3_abi.mint(recipient, Some(sub_id1), 10);
    assert(src20_abi.total_assets() == 1);

    src3_abi.mint(recipient, Some(sub_id2), 10);
    assert(src20_abi.total_assets() == 2);
}

#[test]
fn test_total_supply() {
    let src3_abi = abi(SRC3, CONTRACT_ID);
    let src20_abi = abi(SRC20, CONTRACT_ID);

    let recipient = Identity::ContractId(ContractId::from(CONTRACT_ID));
    let sub_id = SubId::zero();
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), sub_id);

    assert(src20_abi.total_supply(asset_id).is_none());

    src3_abi.mint(recipient, Some(sub_id), 10);
    assert(src20_abi.total_supply(asset_id).unwrap() == 10);

    src3_abi.mint(recipient, Some(sub_id), 10);
    assert(src20_abi.total_supply(asset_id).unwrap() == 20);
}

#[test]
fn test_name() {
    let src20_abi = abi(SRC20, CONTRACT_ID);
    let attributes_abi = abi(SetAssetAttributes, CONTRACT_ID);

    let recipient = Identity::ContractId(ContractId::from(CONTRACT_ID));
    let sub_id = SubId::zero();
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), sub_id);
    let name = String::from_ascii_str("Fuel Asset");

    assert(src20_abi.name(asset_id).is_none());

    attributes_abi.set_name(asset_id, Some(name));
    assert(src20_abi.name(asset_id).unwrap().as_bytes() == name.as_bytes());
}

#[test]
fn test_symbol() {
    let src20_abi = abi(SRC20, CONTRACT_ID);
    let attributes_abi = abi(SetAssetAttributes, CONTRACT_ID);

    let recipient = Identity::ContractId(ContractId::from(CONTRACT_ID));
    let sub_id = SubId::zero();
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), sub_id);
    let symbol = String::from_ascii_str("FUEL");

    assert(src20_abi.symbol(asset_id).is_none());

    attributes_abi.set_symbol(asset_id, Some(symbol));
    assert(src20_abi.symbol(asset_id).unwrap().as_bytes() == symbol.as_bytes());
}

#[test]
fn test_decimals() {
    let src20_abi = abi(SRC20, CONTRACT_ID);
    let attributes_abi = abi(SetAssetAttributes, CONTRACT_ID);

    let recipient = Identity::ContractId(ContractId::from(CONTRACT_ID));
    let sub_id = SubId::zero();
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), sub_id);
    let decimals = 8u8;

    assert(src20_abi.decimals(asset_id).is_none());

    attributes_abi.set_decimals(asset_id, decimals);
    assert(src20_abi.decimals(asset_id).unwrap() == decimals);
}

#[test]
fn test_mint() {
    use std::context::balance_of;

    let src3_abi = abi(SRC3, CONTRACT_ID);
    let src20_abi = abi(SRC20, CONTRACT_ID);

    let recipient = Identity::ContractId(ContractId::from(CONTRACT_ID));
    let sub_id = SubId::zero();
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), sub_id);

    assert(balance_of(ContractId::from(CONTRACT_ID), asset_id) == 0);

    src3_abi.mint(recipient, Some(sub_id), 10);
    assert(balance_of(ContractId::from(CONTRACT_ID), asset_id) == 10);
}

#[test]
fn test_burn() {
    use std::context::balance_of;

    let src3_abi = abi(SRC3, CONTRACT_ID);
    let src20_abi = abi(SRC20, CONTRACT_ID);

    let recipient = Identity::ContractId(ContractId::from(CONTRACT_ID));
    let sub_id = SubId::zero();
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), sub_id);

    src3_abi.mint(recipient, Some(sub_id), 10);
    assert(balance_of(ContractId::from(CONTRACT_ID), asset_id) == 10);

    src3_abi.burn(sub_id, 10);
    assert(balance_of(ContractId::from(CONTRACT_ID), asset_id) == 0);
}

#[test]
fn test_set_metadata_b256() {
    let data_b256 = 0x0000000000000000000000000000000000000000000000000000000000000001;
    let metadata = Metadata::B256(data_b256);
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), SubId::zero());
    let src7_abi = abi(SRC7, CONTRACT_ID);
    let set_metadata_abi = abi(SetAssetMetadata, CONTRACT_ID);
    let key = String::from_ascii_str("my_key");

    set_metadata_abi.set_metadata(asset_id, Some(metadata), key);

    let returned_metadata = src7_abi.metadata(asset_id, key);
    assert(returned_metadata.is_some());
    assert(returned_metadata.unwrap() == metadata);
}

#[test]
fn test_set_metadata_u64() {
    let data_int = 1;
    let metadata = Metadata::Int(data_int);
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), SubId::zero());
    let src7_abi = abi(SRC7, CONTRACT_ID);
    let set_metadata_abi = abi(SetAssetMetadata, CONTRACT_ID);
    let key = String::from_ascii_str("my_key");

    set_metadata_abi.set_metadata(asset_id, Some(metadata), key);

    let returned_metadata = src7_abi.metadata(asset_id, key);
    assert(returned_metadata.is_some());
    assert(returned_metadata.unwrap() == metadata);
}

#[test]
fn test_set_metadata_string() {
    let data_string = String::from_ascii_str("Fuel is blazingly fast");
    let metadata = Metadata::String(data_string);
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), SubId::zero());
    let src7_abi = abi(SRC7, CONTRACT_ID);
    let set_metadata_abi = abi(SetAssetMetadata, CONTRACT_ID);
    let key = String::from_ascii_str("my_key");

    set_metadata_abi.set_metadata(asset_id, Some(metadata), key);

    let returned_metadata = src7_abi.metadata(asset_id, key);
    assert(returned_metadata.is_some());
    assert(returned_metadata.unwrap() == metadata);
}

#[test]
fn test_set_metadata_bytes() {
    let data_bytes = String::from_ascii_str("Fuel is blazingly fast").as_bytes();
    let metadata = Metadata::Bytes(data_bytes);
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), SubId::zero());
    let src7_abi = abi(SRC7, CONTRACT_ID);
    let set_metadata_abi = abi(SetAssetMetadata, CONTRACT_ID);
    let key = String::from_ascii_str("my_key");

    set_metadata_abi.set_metadata(asset_id, Some(metadata), key);

    let returned_metadata = src7_abi.metadata(asset_id, key);
    assert(returned_metadata.is_some());
    assert(returned_metadata.unwrap() == metadata);
}

#[test]
fn total_assets_only_incremented_once() {
    use std::context::balance_of;

    let src3_abi = abi(SRC3, CONTRACT_ID);
    let src20_abi = abi(SRC20, CONTRACT_ID);

    let recipient = Identity::ContractId(ContractId::from(CONTRACT_ID));
    let sub_id = SubId::zero();
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), sub_id);

    assert(src20_abi.total_assets() == 0);

    src3_abi.mint(recipient, Some(sub_id), 10);
    assert(balance_of(ContractId::from(CONTRACT_ID), asset_id) == 10);

    assert(src20_abi.total_assets() == 1);

    src3_abi.burn(sub_id, 10);
    assert(balance_of(ContractId::from(CONTRACT_ID), asset_id) == 0);

    assert(src20_abi.total_assets() == 1);

    src3_abi.mint(recipient, Some(sub_id), 10);
    assert(balance_of(ContractId::from(CONTRACT_ID), asset_id) == 10);

    assert(src20_abi.total_assets() == 1);
}
