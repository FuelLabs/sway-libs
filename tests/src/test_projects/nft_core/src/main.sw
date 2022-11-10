contract;

use sway_libs::nft::{
    approve,
    approved,
    balance_of,
    is_approved_for_all,
    mint,
    owner_of,
    set_approval_for_all,
    tokens_minted,
    transfer,
};

abi NFT_Core_Test {
    #[storage(read, write)]
    fn approve(approved: Option<Identity>, token_id: u64);
    #[storage(read)]
    fn approved(token_id: u64) -> Option<Identity>;
    #[storage(read)]
    fn balance_of(owner: Identity) -> u64;
    #[storage(read)]
    fn is_approved_for_all(operator: Identity, owner: Identity) -> bool;
    #[storage(read, write)]
    fn mint(amount: u64, to: Identity);
    #[storage(read)]
    fn owner_of(token_id: u64) -> Option<Identity>;
    #[storage(write)]
    fn set_approval_for_all(approve: bool, operator: Identity);
    #[storage(read)]
    fn tokens_minted() -> u64;
    #[storage(read, write)]
    fn transfer(to: Identity, token_id: u64);
}

impl NFT_Core_Test for Contract {
    #[storage(read, write)]
    fn approve(approved_identity: Option<Identity>, token_id: u64) {
        approve(approved_identity, token_id);
    }

    #[storage(read)]
    fn approved(token_id: u64) -> Option<Identity> {
        approved(token_id)
    }

    #[storage(read)]
    fn balance_of(owner: Identity) -> u64 {
        balance_of(owner)
    }

    #[storage(read)]
    fn is_approved_for_all(operator: Identity, owner: Identity) -> bool {
        is_approved_for_all(operator, owner)
    }

    #[storage(read, write)]
    fn mint(amount: u64, to: Identity) {
        mint(amount, to);
    }

    #[storage(read)]
    fn owner_of(token_id: u64) -> Option<Identity> {
        owner_of(token_id)
    }

    #[storage(write)]
    fn set_approval_for_all(approval: bool, operator: Identity) {
        set_approval_for_all(approval, operator);
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
