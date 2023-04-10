library;

// TODO: Move these into alphabetical order once https://github.com/FuelLabs/sway/issues/409 is resolved
mod nft_core;
mod extensions;

use nft_core::{
    errors::InputError,
    events::OperatorEvent,
    nft_storage::{
        BALANCES,
        OPERATOR_APPROVAL,
        TOKENS,
        TOKENS_MINTED,
    },
    NFTCore,
};
use std::{auth::msg_sender, hash::sha256, storage::{get, store}};

abi NFT {
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

/// Sets the approved identity for a specific token.
///
/// To revoke approval the approved user should be `None`.
///
/// # Arguments
///
/// * `approved` - The user which will be allowed to transfer the token on the owner's behalf.
/// * `token_id` - The unique identifier of the token which the owner is giving approval for.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
/// * Writes: `1`
///
/// # Reverts
///
/// * When `token_id` does not map to an existing token.
#[storage(read, write)]
pub fn approve(approved: Option<Identity>, token_id: u64) {
    let mut nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id))).unwrap_or(Option::None);
    require(nft.is_some(), InputError::TokenDoesNotExist);
    nft.unwrap().approve(approved);
}

/// Returns the user which is approved to transfer the specified token.
///
/// # Arguments
///
/// * `token_id` - The unique identifier of the token which the approved user should be returned.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
#[storage(read)]
pub fn approved(token_id: u64) -> Option<Identity> {
    let nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id))).unwrap_or(Option::None);

    match nft {
        Option::Some(nft) => {
            nft.approved()
        },
        Option::None => {
            Option::None
        }
    }
}

/// Returns the balance of an user.
///
/// # Arguments
///
/// * `owner` - The user of which the balance should be returned.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
#[storage(read)]
pub fn balance_of(owner: Identity) -> u64 {
    get::<u64>(sha256((BALANCES, owner))).unwrap_or(0)
}

/// Returns whether the `operator` user is approved to transfer all tokens on behalf of the `owner`.
///
/// # Arguments
///
/// * `operator` - The user which may or may not transfer all tokens on the `owner`s behalf.
/// * `owner` - The user which may or may not have given approval to transfer all tokens.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
#[storage(read)]
pub fn is_approved_for_all(operator: Identity, owner: Identity) -> bool {
    get::<bool>(sha256((OPERATOR_APPROVAL, owner, operator))).unwrap_or(false)
}

/// Mints `amount` number of tokens to the specified user.
///
/// # Arguments
///
/// * `amount` - The number of tokens to be minted in this transaction.
/// * `to` - The user which will own the minted tokens.
///
/// # Number of Storage Accesses
///
/// * Reads: `n + 1`
/// * Writes: `3n`
#[storage(read, write)]
pub fn mint(amount: u64, to: Identity) {
    let tokens_minted = get::<u64>(TOKENS_MINTED).unwrap_or(0);
    let total_mint = tokens_minted + amount;

    // Mint as many tokens as the sender has asked for
    let mut index = tokens_minted;
    while index < total_mint {
        let _ = NFTCore::mint(to, index);
        index += 1;
    }
}

/// Returns the user which owns the specified token.
///
/// # Arguments
///
/// * `token_id` - The unique identifier of the token.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
#[storage(read)]
pub fn owner_of(token_id: u64) -> Option<Identity> {
    let nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id))).unwrap_or(Option::None);

    match nft {
        Option::Some(nft) => {
            Option::Some(nft.owner())
        },
        Option::None => {
            Option::None
        }
    }
}

/// Gives the `operator` user approval to transfer ALL tokens owned by the `owner` user.
///
/// This can be dangerous. If a malicous user is set as an operator to another user, they could
/// drain their wallet.
///
/// # Arguments
///
/// * `approve` - Represents whether the user is giving or revoking operator status.
/// * `operator` - The user which may or may not transfer all tokens on the sender's behalf.
///
/// # Number of Storage Accesses
///
/// * Writes: `1`
#[storage(write)]
pub fn set_approval_for_all(approve: bool, operator: Identity) {
    let sender = msg_sender().unwrap();
    store(sha256((OPERATOR_APPROVAL, sender, operator)), approve);

    log(OperatorEvent {
        approved: approve,
        owner: sender,
        operator,
    });
}

/// Returns the total number of tokens that have been minted.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
#[storage(read)]
pub fn tokens_minted() -> u64 {
    get::<u64>(TOKENS_MINTED).unwrap_or(0)
}

/// Transfers ownership of the specified token to another user.
///
/// # Arguments
///
/// * `to` - The user which the ownership of the token should be set to.
/// * `token_id` - The unique identifier of the token which should be transfered.
///
/// # Number of Storage Accesses
///
/// * Reads: `4`
/// * Writes: `3`
///
/// # Reverts
///
/// * When the `token_id` does not map to an existing token.
#[storage(read, write)]
pub fn transfer(to: Identity, token_id: u64) {
    let nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id))).unwrap_or(Option::None);
    require(nft.is_some(), InputError::TokenDoesNotExist);
    let _ = nft.unwrap().transfer(to);
}
