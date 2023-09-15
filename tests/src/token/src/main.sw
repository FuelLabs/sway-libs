contract;

use src_20::SRC20;
use src_3::SRC3;
use token::{
    _burn,
    _decimals,
    _mint,
    _name,
    _set_decimals,
    _set_name,
    _set_symbol,
    _symbol,
    _total_assets,
    _total_supply,
    SetTokenAttributes,
};
use std::{hash::Hash, storage::storage_string::*, string::String};

storage {
    total_assets: u64 = 0,
    total_supply: StorageMap<AssetId, u64> = StorageMap {},
    name: StorageMap<AssetId, StorageKey<StorageString>> = StorageMap {},
    symbol: StorageMap<AssetId, StorageKey<StorageString>> = StorageMap {},
    decimals: StorageMap<AssetId, u8> = StorageMap {},
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
    fn mint(recipient: Identity, sub_id: SubId, amount: u64) {
        _mint(storage.total_assets, storage.total_supply, recipient, sub_id, amount);
    }

    #[storage(read, write)]
    fn burn(sub_id: SubId, amount: u64) {
        _burn(storage.total_supply, sub_id, amount);
    }
}

impl SetTokenAttributes for Contract {
    #[storage(write)]
    fn set_name(asset: AssetId, name: String) {
        _set_name(storage.name, asset, name);
    }

    #[storage(write)]
    fn set_symbol(asset: AssetId, symbol: String) {
        _set_symbol(storage.symbol, asset, symbol);
    }

    #[storage(write)]
    fn set_decimals(asset: AssetId, decimals: u8) {
        _set_decimals(storage.decimals, asset, decimals);
    }
}

#[test]
fn test_total_assets() {
    let src3_abi = abi(SRC3, CONTRACT_ID);
    let src20_abi = abi(SRC20, CONTRACT_ID);

    let recipient = Identity::ContractId(ContractId::from(CONTRACT_ID));
    let sub_id1 = 0x0000000000000000000000000000000000000000000000000000000000000000;
    let sub_id2 = 0x0000000000000000000000000000000000000000000000000000000000000001;

    assert(src20_abi.total_assets() == 0);

    src3_abi.mint(recipient, sub_id1, 10);
    assert(src20_abi.total_assets() == 1);

    src3_abi.mint(recipient, sub_id2, 10);
    assert(src20_abi.total_assets() == 2);
}

#[test]
fn test_total_supply() {
    let src3_abi = abi(SRC3, CONTRACT_ID);
    let src20_abi = abi(SRC20, CONTRACT_ID);

    let recipient = Identity::ContractId(ContractId::from(CONTRACT_ID));
    let sub_id = 0x0000000000000000000000000000000000000000000000000000000000000000;
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), sub_id);

    assert(src20_abi.total_supply(asset_id).is_none());

    src3_abi.mint(recipient, sub_id, 10);
    assert(src20_abi.total_supply(asset_id).unwrap() == 10);

    src3_abi.mint(recipient, sub_id, 10);
    assert(src20_abi.total_supply(asset_id).unwrap() == 20);
}

#[test]
fn test_name() {
    let src20_abi = abi(SRC20, CONTRACT_ID);
    let attributes_abi = abi(SetTokenAttributes, CONTRACT_ID);

    let recipient = Identity::ContractId(ContractId::from(CONTRACT_ID));
    let sub_id = 0x0000000000000000000000000000000000000000000000000000000000000000;
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), sub_id);
    let name = String::from_ascii_str("Fuel Token");

    assert(src20_abi.name(asset_id).is_none());

    attributes_abi.set_name(asset_id, name);
    assert(src20_abi.name(asset_id).unwrap().as_bytes() == name.as_bytes());
}

#[test]
fn test_symbol() {
    let src20_abi = abi(SRC20, CONTRACT_ID);
    let attributes_abi = abi(SetTokenAttributes, CONTRACT_ID);

    let recipient = Identity::ContractId(ContractId::from(CONTRACT_ID));
    let sub_id = 0x0000000000000000000000000000000000000000000000000000000000000000;
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), sub_id);
    let symbol = String::from_ascii_str("FUEL");

    assert(src20_abi.symbol(asset_id).is_none());

    attributes_abi.set_symbol(asset_id, symbol);
    assert(src20_abi.symbol(asset_id).unwrap().as_bytes() == symbol.as_bytes());
}

#[test]
fn test_decimals() {
    let src20_abi = abi(SRC20, CONTRACT_ID);
    let attributes_abi = abi(SetTokenAttributes, CONTRACT_ID);

    let recipient = Identity::ContractId(ContractId::from(CONTRACT_ID));
    let sub_id = 0x0000000000000000000000000000000000000000000000000000000000000000;
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
    let sub_id = 0x0000000000000000000000000000000000000000000000000000000000000000;
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), sub_id);

    assert(balance_of(ContractId::from(CONTRACT_ID), asset_id) == 0);

    src3_abi.mint(recipient, sub_id, 10);
    assert(balance_of(ContractId::from(CONTRACT_ID), asset_id) == 10);
}

#[test]
fn test_burn() {
    use std::context::balance_of;

    let src3_abi = abi(SRC3, CONTRACT_ID);
    let src20_abi = abi(SRC20, CONTRACT_ID);

    let recipient = Identity::ContractId(ContractId::from(CONTRACT_ID));
    let sub_id = 0x0000000000000000000000000000000000000000000000000000000000000000;
    let asset_id = AssetId::new(ContractId::from(CONTRACT_ID), sub_id);

    src3_abi.mint(recipient, sub_id, 10);
    assert(balance_of(ContractId::from(CONTRACT_ID), asset_id) == 10);

    src3_abi.burn(sub_id, 10);
    assert(balance_of(ContractId::from(CONTRACT_ID), asset_id) == 0);
}
