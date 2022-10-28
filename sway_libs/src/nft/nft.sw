library nft;

// TODO: Move these into alphabetical order once https://github.com/FuelLabs/sway/issues/409 is resolved
dep nft_storage;
dep nft_core;
dep errors;
dep events;
dep extensions/administrator/administrator;
dep extensions/burnable/burnable;
dep extensions/meta_data/meta_data;
dep extensions/supply;

use errors::InputError;
use events::OperatorEvent;
use nft_core::NFTCore;
use nft_storage::{BALANCES, OPERATOR_APPROVAL, TOKENS, TOKENS_MINTED};
use std::{chain::auth::msg_sender, hash::sha256, logging::log, storage::{get, store}};

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
#[storage(read, write)]
pub fn approve(approved: Option<Identity>, token_id: u64) {
    let mut nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id)));
    require(nft.is_some(), InputError::TokenDoesNotExist);
    nft.unwrap().approve(approved);
}

/// Returns the user which is approved to transfer the given token.
///
/// # Arguments
///
/// * `token_id` - The unique identifier of the token which the approved user should be returned.
///
/// # Reverts
///
/// * When `token_id` does not map to an existing token.
#[storage(read)]
pub fn approved(token_id: u64) -> Option<Identity> {
    let mut nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id)));
    require(nft.is_some(), InputError::TokenDoesNotExist);
    nft.unwrap().approved()
}

/// Returns the balance of the user.
///
/// # Arguments
///
/// * `owner` - The user of which the balance should be returned.
#[storage(read)]
pub fn balance_of(owner: Identity) -> u64 {
    get::<u64>(sha256((BALANCES, owner)))
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
    get::<bool>(sha256((OPERATOR_APPROVAL, owner, operator)))
}

/// Mints `amount` number of tokens to the `to` `Identity`.
///
/// Once a token has been minted, it can be transfered and burned.
///
/// # Arguments
///
/// * `amount` - The number of tokens to be minted in this transaction.
/// * `to` - The user which will own the minted tokens.
#[storage(read, write)]
pub fn mint(amount: u64, to: Identity) {
    let tokens_minted = get::<u64>(TOKENS_MINTED);
    let total_mint = tokens_minted + amount;

    // Mint as many tokens as the sender has asked for
    let mut index = tokens_minted;
    while index < total_mint {
        ~NFTCore::mint(to, amount);
        index += 1;
    }
}

/// Returns the user which owns the specified token.
///
/// # Arguments
///
/// * `token_id` - The unique identifier of the token.
///
/// # Reverts
///
/// * When `token_id` does not map to an existing token.
#[storage(read)]
pub fn owner_of(token_id: u64) -> Option<Identity> {
    let nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id)));
    require(nft.is_some(), InputError::TokenDoesNotExist);
    nft.unwrap().owner()
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
    let sender = msg_sender().unwrap();
    store(sha256((OPERATOR_APPROVAL, sender, operator)), approve);

    log(OperatorEvent {
        approved: approve,
        owner: sender,
        operator,
    });
}

/// Returns the current number of tokens are in existence.
#[storage(read)]
pub fn tokens_minted() -> u64 {
    get::<u64>(TOKENS_MINTED)
}

/// Transfers ownership of the specified token to another user.
///
/// # Arguments
///
/// * `to` - The user which the ownership of the token should be set to.
/// * `token_id` - The unique identifier of the token which should be transfered.
///
/// # Reverts
///
/// * When the `token_id` does not map to an existing token.
#[storage(read, write)]
pub fn transfer(to: Identity, token_id: u64) {
    let nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id)));
    require(nft.is_some(), InputError::TokenDoesNotExist);
    nft.unwrap().transfer(to);
}
