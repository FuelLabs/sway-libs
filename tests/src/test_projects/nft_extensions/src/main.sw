contract;

use sway_libs::nft::{
    administrator::{admin, set_admin},
    balance_of,
    burnable::burn,
    meta_data::{meta_data, meta_data_structures::NFTMetaData, set_meta_data},
    mint,
    owner_of,
    supply::{max_supply, set_max_supply},
    tokens_minted,
    transfer,
};

abi NFT_Extensions_Test {
    #[storage(read)]
    fn admin() -> Option<Identity>;
    #[storage(read)]
    fn balance_of(owner: Identity) -> u64;
    #[storage(read, write)]
    fn burn(token_id: u64);
    #[storage(read)]
    fn max_supply() -> Option<u64>;
    #[storage(read)]
    fn meta_data(token_id: u64) -> NFTMetaData;
    #[storage(read, write)]
    fn mint(amount: u64, to: Identity);
    #[storage(read)]
    fn owner_of(token_id: u64) -> Option<Identity>;
    #[storage(read, write)]
    fn set_admin(new_admin: Option<Identity>);
    #[storage(read, write)]
    fn set_max_supply(supply: Option<u64>);
    #[storage(read, write)]
    fn set_meta_data(value: u64, token_id: u64);
    #[storage(read)]
    fn tokens_minted() -> u64;
    #[storage(read, write)]
    fn transfer(to: Identity, token_id: u64);
}

impl NFT_Extensions_Test for Contract {
    #[storage(read)]
    fn admin() -> Option<Identity> {
        admin()
    }

    #[storage(read)]
    fn balance_of(owner: Identity) -> u64 {
        balance_of(owner)
    }

    #[storage(read, write)]
    fn burn(token_id: u64) {
        burn(token_id);
    }

    #[storage(read)]
    fn max_supply() -> Option<u64> {
        max_supply()
    }

    #[storage(read)]
    fn meta_data(token_id: u64) -> NFTMetaData {
        meta_data(token_id)
    }

    #[storage(read, write)]
    fn mint(amount: u64, to: Identity) {
        mint(amount, to);
    }

    #[storage(read)]
    fn owner_of(token_id: u64) -> Option<Identity> {
        owner_of(token_id)
    }
    
    #[storage(read, write)]
    fn set_admin(new_admin: Option<Identity>) {
        set_admin(new_admin);
    }

    #[storage(read, write)]
    fn set_max_supply(supply: Option<u64>) {
        set_max_supply(supply)
    }

    #[storage(read, write)]
    fn set_meta_data(token_id: u64, value: u64) {
        set_meta_data(token_id, value);
    }

    #[storage(read)]
    fn tokens_minted() -> u64 {
        tokens_minted()
    }

    #[storage(read, write)]
    fn transfer(to: Identity, token_id: u64) {
        transfer(to, token_id);
    }
}
