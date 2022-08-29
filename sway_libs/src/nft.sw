library nft;

dep NFT/data_structures;
dep NFT/errors;
dep NFT/events;

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

// TODO: These are temporary storage keys for manual storage management. These should be updated once
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
    // TODO: Remove this and update function definition to include Option once
    // https://github.com/FuelLabs/fuels-rs/issues/415 is revolved
    // let admin = storage.admin;
    let admin = get::<Option>(ADMIN);
    require(admin.is_some(), InputError::AdminDoesNotExist);
    admin.unwrap()
}

#[storage(read, write)]
pub fn approve(approved: Identity, token_id: u64) {
    // Ensure this is a valid token
    // TODO: Remove this and update function definition to include Option once
    // https://github.com/FuelLabs/fuels-rs/issues/415 is revolved
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
    // TODO: This should be removed and update function definition to include Option once
    // https://github.com/FuelLabs/fuels-rs/issues/415 is revolved
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
