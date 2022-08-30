// TODO: Update function definitions to include `Option` once
// https://github.com/FuelLabs/fuels-rs/issues/415 is revolved

library nft;

dep data_structures;
dep errors;
dep events;

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

/// Returns the current admin for the contract.
///
/// # Reverts
///
/// * When the contract does not have an admin.
#[storage(read)]
pub fn admin() -> Identity {
    // let admin = storage.admin;
    let admin = get::<Option>(ADMIN);
    require(admin.is_some(), InputError::AdminDoesNotExist);
    admin.unwrap()
}

/// Gives approval to the `approved` user to transfer a specific token on another user's behalf.
///
/// To revoke approval the approved user should be `None`.
///
/// # Arguments
///
/// * `approved` - The user which will be allowed to transfer the token on the owner's behalf.
/// * `token_id` - The unique identifier of the token which the owner is giving approval for.
///
/// # Reverts
///
/// * When `token_id` does not map to an existing token.
/// * When the sender is not the token's owner.
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

/// Returns the user which is approved to transfer the given token.
///
/// If there is no approved user or the unique identifier does not map to an existing token,
/// the function will return `None`.
///
/// # Arguments
///
/// * `token_id` - The unique identifier of the token which the approved user should be returned.
///
/// # Reverts
///
/// * When there is no approved for the `token_id`.
#[storage(read)]
pub fn approved(token_id: u64) -> Identity {
    // storage.approved.get(token_id)
    // let approved = storage.approved.get(token_id);
    let approved = get::<Option>(sha256((APPROVED, token_id)));
    require(approved.is_some(), InputError::ApprovedDoesNotExist);
    approved.unwrap()
}

/// Returns the balance of the `owner` user.
///
/// # Arguments
///
/// * `owner` - The user of which the balance should be returned.
#[storage(read)]
pub fn balance_of(owner: Identity) -> u64 {
    // storage.balances.get(owner)
    get::<u64>(sha256((BALANCES, owner)))
}

/// Burns the specified token.
///
/// When burned, the metadata of the token is removed. After the token has been burned, no one
/// will be able to fetch any data about this token or have control over it.
///
/// # Arguments
///
/// * `token_id` - The unique identifier of the token which is to be burned.
///
/// * Reverts
///
/// * When `token_id` does not map to an existing token.
/// * When sender is not the owner of the token.
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
    let none_owner: Option<Identity> = Option::None();
    store(sha256((OWNERS, token_id)), none_owner);
    let balance = get::<u64>(sha256((BALANCES, sender)));
    store(sha256((BALANCES, sender)), balance - 1);
    let total_supply = get::<u64>(TOTAL_SUPPLY);
    store(TOTAL_SUPPLY, total_supply);

    log(BurnEvent {
        owner: sender, token_id
    });
}

/// Sets the inital state and unlocks the functionality for the rest of the contract.
///
/// This function can only be called once.
///
/// # Arguments
///
/// * `access_control` - Determines whether only the admin can call the mint function.
/// * `admin` - The user which has the ability to mint if `access_control` is set to true and change the contract's admin.
/// * `max_supply` - The maximum supply of tokens that can ever be minted.
///
/// # Reverts
///
/// * When the constructor function has already been called.
/// * When the `token_supply` is set to 0.
/// * When `access_control` is set to true and no admin `Identity` was given.
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

/// Returns whether the `operator` user is approved to transfer all tokens on the `owner`
/// user's behalf.
///
/// # Arguments
///
/// * `operator` - The user which has recieved approval to transfer all tokens on the `owner`s behalf.
/// * `owner` - The user which has given approval to transfer all tokens to the `operator`.
#[storage(read)]
pub fn is_approved_for_all(operator: Identity, owner: Identity) -> bool {
    // storage.operator_approval.get((owner, operator))
    get::<bool>(sha256((OPERATOR_APPROVAL, owner, operator)))
}

/// Returns the total number of tokens which will ever be minted.
#[storage(read)]
pub fn max_supply() -> u64 {
    // storage.max_supply
    get::<u64>(MAX_SUPPLY)
}

/// Mints `amount` number of tokens to the `to` `Identity`.
///
/// Once a token has been minted, it can be transfered and burned.
///
/// # Arguments
///
/// * `amount` - The number of tokens to be minted in this transaction.
/// * `to` - The user which will own the minted tokens.
///
/// # Reverts
///
/// * When the sender attempts to mint more tokens than total supply.
/// * When the sender is not the admin and `access_control` is set.
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
    // require(!storage.access_control || (admin.is_some() && msg_sender().unwrap() == admin.unwrap()), AccessError::SenderNotAdmin);
    let admin: Option<Identity> = get::<Option>(ADMIN);
    require(!get::<bool>(ACCESS_CONTROL) || (admin.is_some() && msg_sender().unwrap() == admin.unwrap()), AccessError::SenderNotAdmin);

    // Mint as many tokens as the sender has asked for
    let mut index = tokens_minted;
    while index < total_mint {
        // Create the TokenMetaData for this new token
        // storage.meta_data.insert(index, ~TokenMetaData::new());
        // storage.owners.insert(index, Option::Some(to));
        store(sha256((META_DATA, index)), ~TokenMetaData::new());
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

/// Returns the metadata for the token specified
///
/// # Arguments
///
/// * `token_id` - The unique identifier of the token.
///
/// # Reverts
///
/// * When the `token_id` does not map to an exsiting token.
#[storage(read)]
pub fn meta_data(token_id: u64) -> TokenMetaData {
    // require(token_id < storage.tokens_minted, InputError::TokenDoesNotExist);
    // storage.meta_data.get(token_id)
    require(token_id < get::<u64>(TOKENS_MINTED), InputError::TokenDoesNotExist);
    get::<TokenMetaData>(sha256((META_DATA, token_id)))
}

/// Returns the user which owns the specified token.
///
/// # Arguments
///
/// * `token_id` - The unique identifier of the token.
///
/// # Reverts
///
/// * When there is no owner for the `token_id`.
#[storage(read)]
pub fn owner_of(token_id: u64) -> Identity {
    // let owner = storage.owners.get(token_id);
    let owner: Option<Identity> = get::<Option>(sha256((OWNERS, token_id)));
    require(owner.is_some(), InputError::OwnerDoesNotExist);
    owner.unwrap()
}

/// Changes the contract's admin.
///
/// This new admin will have access to minting if `access_control` is set to true and be able
/// to change the contract's admin to a new admin.
///
/// # Arguments
///
/// * `admin` - The user which is to be set as the new admin.
///
/// # Reverts
///
/// * When the sender is not the `admin` in storage.
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

/// Gives the `operator` user approval to transfer ALL tokens owned by the `owner` user.
///
/// This can be dangerous. If a malicous user is set as an operator to another user, they could
/// drain their wallet.
///
/// # Arguments
///
/// * `approve` - Represents whether the user is giving or revoking operator status.
/// * `operator` - The user which may transfer all tokens on the owner's behalf.
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

/// Returns the total supply of tokens which are currently in existence.
#[storage(read)]
pub fn total_supply() -> u64 {
    // storage.total_supply
    get::<u64>(TOTAL_SUPPLY)
}

/// Transfers ownership of the specified token from one user to another.
///
/// Transfers can occur under one of three conditions:
/// 1. The token's owner is transfering the token.
/// 2. The token's approved user is transfering the token.
/// 3. The token's owner has a user set as an operator and is transfering the token.
///
/// # Arguments
///
/// * `from` - The user which currently owns the token to be transfered.
/// * `to` - The user which the ownership of the token should be set to.
/// * `token_id` - The unique identifier of the token which should be transfered.
///
/// # Reverts
///
/// * When the `token_id` does not map to an existing token.
/// * When the sender is not the owner of the token.
/// * When the sender is not approved to transfer the token on the owner's behalf.
/// * When the sender is not approved to transfer all tokens on the owner's behalf.
#[storage(read, write)]
pub fn transfer_from(from: Identity, to: Identity, token_id: u64) {
    // Make sure the `token_id` maps to an existing token
    // let token_owner = storage.owners.get(token_id);
    let token_owner: Option<Identity> = get::<Option>(sha256((OWNERS, token_id)));
    require(token_owner.is_some(), InputError::TokenDoesNotExist);
    let token_owner = token_owner.unwrap();

    // Ensure that the sender is either:
    // 1. The owner of the token
    // 2. Approved for transfer of this `token_id`
    // 3. Has operator approval for the `from` identity and this token belongs to the `from` identity
    let sender = msg_sender().unwrap();
    // let approved = storage.approved.get(token_id);
    // require(sender == token_owner || (approved.is_some() && sender == approved.unwrap()) || (from == token_owner && storage.operator_approval.get((from, sender))), AccessError::SenderNotOwnerOrApproved);
    let approved: Option<Identity> = get::<Option>(sha256((APPROVED, token_id)));
    let has_operator_approval = get::<bool>(sha256((OPERATOR_APPROVAL, from, sender)));
    require(sender == token_owner || (approved.is_some() && sender == approved.unwrap()) || (from == token_owner && has_operator_approval), AccessError::SenderNotOwnerOrApproved);
    
    // Set the new owner of the token and reset the approved Identity
    // storage.owners.insert(token_id, Option::Some(to));
    store(sha256((OWNERS, token_id)), Option::Some(to));
    if approved.is_some() {
        // storage.approved.insert(token_id, Option::None());
        let none_approved: Option<Identity> = Option::None();
        store(sha256((APPROVED, token_id)), none_approved);
    }

    // storage.balances.insert(from, storage.balances.get(from) - 1);
    // storage.balances.insert(to, storage.balances.get(to) + 1);
    let from_balance = get::<u64>(sha256((BALANCES, from)));
    let to_balance = get::<u64>(sha256((BALANCES, to)));
    store(sha256((BALANCES, from)), from_balance - 1);
    store(sha256((BALANCES, to)), to_balance + 1);

    log(TransferEvent {
        from, sender, to, token_id
    });
}
