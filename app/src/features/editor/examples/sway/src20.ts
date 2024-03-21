export const EXAMPLE_SWAY_CONTRACT_SRC20 = `contract;

use ownership;
use src3::SRC3;
use src5::SRC5;
use src20::SRC20;
use std::{
    asset::{
        burn,
        mint_to,
    },
    call_frames::{
        msg_asset_id,
    },
    constants::DEFAULT_SUB_ID,
    context::msg_amount,
    string::String,
};

abi NativeAsset {
    #[storage(read, write)]
    fn constructor(owner_: Identity);

    #[storage(read, write)]
    fn transferOwnership(owner_: Identity);
}

configurable {
    /// The decimals of the asset minted by this contract.
    DECIMALS: u8 = 9u8,
    /// The name of the asset minted by this contract.
    NAME: str[7] = __to_str_array("MyAsset"),
    /// The symbol of the asset minted by this contract.
    SYMBOL: str[5] = __to_str_array("MYTKN"),
}

storage {
    /// The total supply of the asset minted by this contract.
    total_supply: u64 = 0,
}

impl SRC20 for Contract {
    #[storage(read)]
    fn total_assets() -> u64 {
        1
    }

    #[storage(read)]
    fn total_supply(asset: AssetId) -> Option<u64> {
        if asset == AssetId::default() {
            Some(storage.total_supply.read())
        } else {
            None
        }
    }

    #[storage(read)]
    fn name(asset: AssetId) -> Option<String> {
        if asset == AssetId::default() {
            Some(String::from_ascii_str(from_str_array(NAME)))
        } else {
            None
        }
    }

    #[storage(read)]
    fn symbol(asset: AssetId) -> Option<String> {
        if asset == AssetId::default() {
            Some(String::from_ascii_str(from_str_array(SYMBOL)))
        } else {
            None
        }
    }

    #[storage(read)]
    fn decimals(asset: AssetId) -> Option<u8> {
        if asset == AssetId::default() {
            Some(DECIMALS)
        } else {
            None
        }
    }
}

impl NativeAsset for Contract {
    #[storage(read, write)]
    fn constructor(owner_: Identity) {
        require(storage.owner.read() == State::Uninitialized, "owner-initialized");
        ownership::initialize_ownership(owner_);
    }

    #[storage(read, write)]
    fn transferOwner(owner_: Identity) {
        ownership::transfer_ownership(owner_);
    }
}

impl SRC5 for Contract {
    #[storage(read)]
    fn owner() -> State {
        _owner()
    }
}

impl SRC3 for Contract {
    #[storage(read, write)]
    fn mint(recipient: Identity, sub_id: SubId, amount: u64) {
        require(sub_id == DEFAULT_SUB_ID, "Incorrect Sub Id");
        ownership::only_owner();

        // Increment total supply of the asset and mint to the recipient.
        storage
            .total_supply
            .write(amount + storage.total_supply.read());
        mint_to(recipient, DEFAULT_SUB_ID, amount);
    }

    #[storage(read, write)]
    fn burn(sub_id: SubId, amount: u64) {
        require(sub_id == DEFAULT_SUB_ID, "Incorrect Sub Id");
        require(msg_amount() >= amount, "Incorrect amount provided");
        require(
            msg_asset_id() == AssetId::default(),
            "Incorrect asset provided",
        );
        ownership::only_owner();

        // Decrement total supply of the asset and burn.
        storage
            .total_supply
            .write(storage.total_supply.read() - amount);
        burn(DEFAULT_SUB_ID, amount);
    }
}`;