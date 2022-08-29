// TODO: Update function definitions to include `Option` once
// https://github.com/FuelLabs/fuels-rs/issues/415 is revolved

library nft;

dep NFT/data_structures;
dep NFT/errors;
dep NFT/events;

use data_structures::TokenMetaData;
use errors::{AccessError, InitError, InputError};
use events::{AdminEvent, ApprovalEvent, BurnEvent, MintEvent, OperatorEvent, TransferEvent};
use std::{
    chain::auth::msg_sender,
    hash::sha256,
    identity::Identity,
    logging::log,
    option::Option,
    result::Result,
    revert::require,
    storage::{get, store}
};

// TODO: These are temporary storage keys for manual storage management. These should be removed once
// https://github.com/FuelLabs/sway/issues/2585 is resolved.
const ACCESS_CONTROL: b256 = 0x1000000000000000000000000000000000000000000000000000000000000000;
const ADMIN: b256 = 0x2000000000000000000000000000000000000000000000000000000000000000;
const APPROVED: b256 = 0x3000000000000000000000000000000000000000000000000000000000000000;
const BALANCES: b256 = 0x4000000000000000000000000000000000000000000000000000000000000000;
const MAX_SUPPLY: b256 = 0x5000000000000000000000000000000000000000000000000000000000000000;
const META_DATA: b256 = 0x6000000000000000000000000000000000000000000000000000000000000000;
const OPERATOR_APPROVAL: b256 = 0x7000000000000000000000000000000000000000000000000000000000000000;
const OWNERS: b256 = 0x8000000000000000000000000000000000000000000000000000000000000000;
const TOKENS_MINTED: b256 = 0x9000000000000000000000000000000000000000000000000000000000000000;
const TOTAL_SUPPLY: b256 = 0xa000000000000000000000000000000000000000000000000000000000000000;

#[storage(read)]
pub fn admin() -> Identity {
    // let admin = storage.admin;
    let admin = get::<Option>(ADMIN);
    require(admin.is_some(), InputError::AdminDoesNotExist);
    admin.unwrap()
}

#[storage(read, write)]
pub fn approve(approved: Identity, token_id: u64) {
    // Ensure this is a valid token
    let approved = Option::Some(approved);
    // let token_owner = storage.owners.get(token_id);
    let token_owner: Option<Identity> = get::<Option>(sha256((OWNERS, token_id)));
    require(token_owner.is_some(), InputError::TokenDoesNotExist);

    // Ensure that the sender is the owner of the token to be approved
    let sender = msg_sender().unwrap();
    require(token_owner.unwrap() == sender, AccessError::SenderNotOwner);

    // Set and store the `approved` `Identity`
    // storage.approved.insert(token_id, approved);
    store(sha256((APPROVED, token_id)), approved);

    log(ApprovalEvent {
        owner: sender, approved, token_id
    });
}

#[storage(read)]
pub fn approved(token_id: u64) -> Identity {
    // storage.approved.get(token_id)
    // let approved = storage.approved.get(token_id);
    let approved = get::<Option>(sha256((APPROVED, token_id)));
    require(approved.is_some(), InputError::ApprovedDoesNotExist);
    approved.unwrap()
}

#[storage(read)]
pub fn balance_of(owner: Identity) -> u64 {
    // storage.balances.get(owner)
    get::<u64>(sha256((BALANCES, owner)))
}

#[storage(read, write)]
pub fn burn(token_id: u64) {
    // Ensure this is a valid token
    // let token_owner = storage.owners.get(token_id);
    let token_owner: Option<Identity> = get::<Option>(sha256((OWNERS, token_id)));
    require(token_owner.is_some(), InputError::TokenDoesNotExist);

    // Ensure the sender owns the token that is provided
    let sender = msg_sender().unwrap();
    require(token_owner.unwrap() == sender, AccessError::SenderNotOwner);

    // storage.owners.insert(token_id, Option::None());
    // storage.balances.insert(sender, storage.balances.get(sender) - 1);
    // storage.total_supply -= 1;
    store(sha256((OWNERS, token_id)), Option::None());
    let balance = get::<u64>(sha256((BALANCES, sender)));
    store(sha256((BALANCES, sender)), balance - 1);
    let total_supply = get::<u64>(TOTAL_SUPPLY);
    store(TOTAL_SUPPLY, total_supply);

    log(BurnEvent {
        owner: sender, token_id
    });
}

#[storage(read, write)]
pub fn constructor(access_control: bool, admin: Identity, max_supply: u64) {
    // This function can only be called once so if the token supply is already set it has
    // already been called
    let admin = Option::Some(admin);
    // require(storage.max_supply == 0, InitError::CannotReinitialize);
    require(get::<u64>(MAX_SUPPLY) == 0, InitError::CannotReinitialize);
    require(max_supply != 0, InputError::TokenSupplyCannotBeZero);
    require((access_control && admin.is_some()) || (!access_control && admin.is_none()), InitError::AdminIsNone);

    // storage.access_control = access_control;
    // storage.admin = admin;
    // storage.max_supply = max_supply;
    store(ACCESS_CONTROL, access_control);
    store(ADMIN, admin);
    store(MAX_SUPPLY, max_supply);
}

#[storage(read)]
pub fn is_approved_for_all(operator: Identity, owner: Identity) -> bool {
    // storage.operator_approval.get((owner, operator))
    get::<bool>(sha256((OPERATOR_APPROVAL, owner, operator)))
}

#[storage(read)]
pub fn max_supply() -> u64 {
    // storage.max_supply
    get::<u64>(MAX_SUPPLY)
}

#[storage(read, write)]
pub fn mint(amount: u64, to: Identity) {
    // let tokens_minted = storage.tokens_minted;
    let tokens_minted = get::<u64>(TOKENS_MINTED);
    let total_mint = tokens_minted + amount;
    // The current number of tokens minted plus the amount to be minted cannot be
    // greater than the total supply
    // require(storage.max_supply >= total_mint, InputError::NotEnoughTokensToMint);
    require(get::<u64>(MAX_SUPPLY) >= total_mint, InputError::NotEnoughTokensToMint);

    // Ensure that the sender is the admin if this is a controlled access mint
    // let admin = storage.admin;
    //require(!storage.access_control || (admin.is_some() && msg_sender().unwrap() == admin.unwrap()), AccessError::SenderNotAdmin);
    let admin: Option<Identity> = get::<Option>(ADMIN);
    require(!get::<bool>(ACCESS_CONTROL) || (admin.is_some() && msg_sender().unwrap() == admin.unwrap()), AccessError::SenderNotAdmin);

    // Mint as many tokens as the sender has asked for
    let mut index = tokens_minted;
    while index < total_mint {
        // Create the TokenMetaData for this new token
        // storage.meta_data.insert(index, ~TokenMetaData::new());
        // storage.owners.insert(index, Option::Some(to));
        
        store(sha256((OWNERS, index)), Option::Some(to));
        index += 1;
    }

    // storage.balances.insert(to, storage.balances.get(to) + amount);
    // storage.tokens_minted = total_mint;
    // storage.total_supply += amount;
    let balance = get::<u64>(sha256((BALANCES, to)));
    store(sha256((BALANCES, to)), balance + amount);
    store(TOKENS_MINTED, total_mint);
    let total_supply = get::<u64>(TOTAL_SUPPLY);
    store(TOTAL_SUPPLY, total_supply + amount);

    log(MintEvent {
        owner: to, token_id_start: tokens_minted, total_tokens: amount
    });
}

#[storage(read)]
pub fn meta_data(token_id: u64) -> TokenMetaData {
    // require(token_id < storage.tokens_minted, InputError::TokenDoesNotExist);
    // storage.meta_data.get(token_id)
    require(token_id < get::<u64>(TOKENS_MINTED), InputError::TokenDoesNotExist);
    get::<TokenMetaData>(sha256((META_DATA, token_id)))
}

#[storage(read)]
pub fn owner_of(token_id: u64) -> Identity {
    // let owner = storage.owners.get(token_id);
    let owner: Option<Identity> = get::<Option>(sha256((OWNERS, token_id)));
    require(owner.is_some(), InputError::OwnerDoesNotExist);
    owner.unwrap()
}

#[storage(read, write)]
pub fn set_admin(admin: Identity) {
    // Ensure that the sender is the admin
    let admin = Option::Some(admin);
    // let current_admin = storage.admin;
    let current_admin: Option<Identity> = get::<Option>(ADMIN);
    require(current_admin.is_some() && msg_sender().unwrap() == current_admin.unwrap(), AccessError::SenderCannotSetAccessControl);
    // storage.admin = admin;
    store(ADMIN, admin);

    log(AdminEvent {
        admin
    });
}

#[storage(read, write)]
pub fn set_approval_for_all(approve: bool, operator: Identity) {
    // Store `approve` with the (sender, operator) tuple
    let sender = msg_sender().unwrap();
    // storage.operator_approval.insert((sender, operator), approve);
    store(sha256((OPERATOR_APPROVAL, sender, operator)), approve);

    log(OperatorEvent {
        approve, owner: sender, operator
    });
}
