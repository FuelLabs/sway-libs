export const EXAMPLE_SWAY_CONTRACT_MULTIASSET = `// ERC1155 equivalent in Sway.
contract;

use standards::src5::{AccessError, SRC5, State};
use standards::src20::{SetDecimalsEvent, SetNameEvent, SetSymbolEvent, SRC20, TotalSupplyEvent};
use standards::src3::SRC3;
use std::{
    asset::{
        burn,
        mint_to,
    },
    call_frames::msg_asset_id,
    context::this_balance,
    hash::{
        Hash,
    },
    storage::storage_string::*,
    string::String,
};

storage {
    total_assets: u64 = 0,
    total_supply: StorageMap<AssetId, u64> = StorageMap {},
    name: StorageMap<AssetId, StorageString> = StorageMap {},
    symbol: StorageMap<AssetId, StorageString> = StorageMap {},
    decimals: StorageMap<AssetId, u8> = StorageMap {},
    owner: State = State::Uninitialized,
}

abi MultiAsset {
    #[storage(read, write)]
    fn constructor(owner_: Identity);

    #[storage(read, write)]
    fn set_name(asset: AssetId, name: String);

    #[storage(read, write)]
    fn set_symbol(asset: AssetId, symbol: String);

    #[storage(read, write)]
    fn set_decimals(asset: AssetId, decimals: u8);
}

impl MultiAsset for Contract {
    #[storage(read, write)]
    fn constructor(owner_: Identity) {
        require(
            storage
                .owner
                .read() == State::Uninitialized,
            "owner-initialized",
        );
        storage.owner.write(State::Initialized(owner_));
    }

    #[storage(read, write)]
    fn set_name(asset: AssetId, name: String) {
        require_access_owner();
        storage.name.insert(asset, StorageString {});
        storage.name.get(asset).write_slice(name);
        SetNameEvent::new(asset, Some(name), msg_sender().unwrap()).log();
    }

    #[storage(read, write)]
    fn set_symbol(asset: AssetId, symbol: String) {
        require_access_owner();
        storage.symbol.insert(asset, StorageString {});
        storage.symbol.get(asset).write_slice(symbol);
        SetSymbolEvent::new(asset, Some(symbol), msg_sender().unwrap()).log();
    }

    #[storage(read, write)]
    fn set_decimals(asset: AssetId, decimals: u8) {
        require_access_owner();
        storage.decimals.insert(asset, decimals);
        SetDecimalsEvent::new(asset, decimals, msg_sender().unwrap()).log();
    }
}

#[storage(read)]
fn require_access_owner() {
    require(
        storage
            .owner
            .read() == State::Initialized(msg_sender().unwrap()),
        AccessError::NotOwner,
    );
}

impl SRC20 for Contract {
    #[storage(read)]
    fn total_assets() -> u64 {
        storage.total_assets.read()
    }

    #[storage(read)]
    fn total_supply(asset: AssetId) -> Option<u64> {
        storage.total_supply.get(asset).try_read()
    }

    #[storage(read)]
    fn name(asset: AssetId) -> Option<String> {
        storage.name.get(asset).read_slice()
    }

    #[storage(read)]
    fn symbol(asset: AssetId) -> Option<String> {
        storage.symbol.get(asset).read_slice()
    }

    #[storage(read)]
    fn decimals(asset: AssetId) -> Option<u8> {
        storage.decimals.get(asset).try_read()
    }
}

impl SRC3 for Contract {
    #[storage(read, write)]
    fn mint(recipient: Identity, sub_id: Option<SubId>, amount: u64) {
        require_access_owner();
        let sub_id = match sub_id {
            Some(id) => id,
            None => SubId::zero(),
        };
        let asset_id = AssetId::new(ContractId::this(), sub_id);
        let supply = storage.total_supply.get(asset_id).try_read();
        if supply.is_none() {
            storage
                .total_assets
                .write(storage.total_assets.try_read().unwrap_or(0) + 1);
        }
        let current_supply = supply.unwrap_or(0);
        storage
            .total_supply
            .insert(asset_id, current_supply + amount);
        mint_to(recipient, sub_id, amount);
        TotalSupplyEvent::new(asset_id, current_supply + amount, msg_sender().unwrap()).log();
    }

    #[payable]
    #[storage(read, write)]
    fn burn(sub_id: SubId, amount: u64) {
        require_access_owner();
        let asset_id = AssetId::new(ContractId::this(), sub_id);
        require(this_balance(asset_id) >= amount, "not-enough-coins");

        let supply = storage.total_supply.get(asset_id).try_read();
        let current_supply = supply.unwrap_or(0);
        storage
            .total_supply
            .insert(asset_id, current_supply - amount);
        burn(sub_id, amount);
        TotalSupplyEvent::new(asset_id, current_supply - amount, msg_sender().unwrap()).log();
    }
}
`;
