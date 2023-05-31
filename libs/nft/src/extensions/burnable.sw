library;

pub mod burnable_events;

use burnable_events::BurnEvent;
use ::nft_core::{errors::{AccessError, InputError}, nft_storage::{BALANCES, TOKENS}, NFTCore};
use std::{auth::msg_sender, hash::sha256, storage::storage_api::{read, write}};

abi Burn {
    #[storage(read, write)]
    fn burn(token_id: u64);
}

pub trait Burnable {
    /// Deletes this token from storage and decrements the balance of the owner.
    ///
    /// * Reverts
    ///
    /// * When sender is not the owner of the token.
    #[storage(read, write)]
    fn burn(self);
}

impl Burnable for NFTCore {
    #[storage(read, write)]
    fn burn(self) {
        require(self.owner == msg_sender().unwrap(), AccessError::SenderNotOwner);

        write(sha256((BALANCES, self.owner)), 0, read::<u64>(sha256((BALANCES, self.owner)), 0).unwrap() - 1);
        write(sha256((TOKENS, self.token_id)), 0, Option::None::<NFTCore>);

        log(BurnEvent {
            owner: self.owner,
            token_id: self.token_id,
        });
    }
}

/// Burns the specified token.
///
/// # Arguments
///
/// * `token_id` - The id of the token to burn.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
/// * Writes: `2`
///
/// # Reverts
///
/// * When the `token_id` specified does not map to an existing token.
#[storage(read, write)]
pub fn burn(token_id: u64) {
    let nft = read::<Option<NFTCore>>(sha256((TOKENS, token_id)), 0).unwrap_or(Option::None);
    require(nft.is_some(), InputError::TokenDoesNotExist);
    nft.unwrap().burn();
}
