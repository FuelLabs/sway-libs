// TODO: Update function definitions to include `Option` once
// https://github.com/FuelLabs/fuels-rs/issues/415 is revolved

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
