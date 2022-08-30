contract;

use sway_libs::nft::{
    admin,
    approve,
    approved,
    balance_of,
    burn,
    constructor,
    data_structures::TokenMetaData,
    is_approved_for_all,
    max_supply,
    meta_data,
    mint,
    owner_of,
    set_admin,
    set_approval_for_all,
    total_supply,
    transfer_from,
};

use std::identity::Identity;

abi NFT_Test {
    #[storage(read)]fn admin() -> Identity;
    #[storage(read, write)]fn approve(approved_identity: Identity, token_id: u64);
    #[storage(read)]fn approved(token_id: u64) -> Identity;
    #[storage(read)]fn balance_of(owner: Identity) -> u64;
    #[storage(read, write)]fn burn(token_id: u64);
    #[storage(read, write)]fn constructor(access_control: bool, admin_identity: Identity, max_supply: u64);
    #[storage(read)]fn is_approved_for_all(operator: Identity, owner: Identity) -> bool;
    #[storage(read)]fn max_supply() -> u64;
    #[storage(read, write)]fn mint(amount: u64, to: Identity);
    #[storage(read)]fn meta_data(token_id: u64) -> TokenMetaData;
    #[storage(read)]fn owner_of(token_id: u64) -> Identity;
    #[storage(read, write)]fn set_admin(admin_identity: Identity);
    #[storage(read, write)]fn set_approval_for_all(approve_bool: bool, operator: Identity);
    #[storage(read)]fn total_supply() -> u64;
    #[storage(read, write)]fn transfer_from(from: Identity, to: Identity, token_id: u64);
}

impl NFT_Test for Contract {
    #[storage(read)]fn admin() -> Identity {
        admin()
    }

    #[storage(read, write)]fn approve(approved_identity: Identity, token_id: u64) {
        approve(approved_identity, token_id);
    }

    #[storage(read)]fn approved(token_id: u64) -> Identity {
        approved(token_id)
    }

    #[storage(read)]fn balance_of(owner: Identity) -> u64 {
        balance_of(owner)
    }

    #[storage(read, write)]fn burn(token_id: u64) {
        burn(token_id);
    }

    #[storage(read, write)]fn constructor(access_control: bool, admin_identity: Identity, max_supply_u64: u64) {
        constructor(access_control, admin_identity, max_supply_u64);
    }

    #[storage(read)]fn is_approved_for_all(operator: Identity, owner: Identity) -> bool {
        is_approved_for_all(operator, owner)
    }

    #[storage(read)]fn max_supply() -> u64 {
        max_supply()
    }

    #[storage(read, write)]fn mint(amount: u64, to: Identity) {
        mint(amount, to);
    }

    #[storage(read)]fn meta_data(token_id: u64) -> TokenMetaData {
        meta_data(token_id)
    }

    #[storage(read)]fn owner_of(token_id: u64) -> Identity {
        owner_of(token_id)
    }

    #[storage(read, write)]fn set_admin(admin_identity: Identity) {
        set_admin(admin_identity)
    }

    #[storage(read, write)]fn set_approval_for_all(approve_bool: bool, operator: Identity) {
        set_approval_for_all(approve_bool, operator);
    }

    #[storage(read)]fn total_supply() -> u64 {
        total_supply()
    }

    #[storage(read, write)]fn transfer_from(from: Identity, to: Identity, token_id: u64) {
        transfer_from(from, to, token_id);
    }
}
