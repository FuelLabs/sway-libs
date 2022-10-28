library burnable;

dep burnable_events;

use burnable_events::BurnEvent;
use ::nft::{errors::{AccessError, InputError}, nft_core::NFTCore, nft_storage::{BALANCES, TOKENS}};
use std::{chain::auth::msg_sender, hash::sha256, logging::log, storage::{get, store}};

pub trait Burnable {
    #[storage(read, write)]
    fn burn(self);
}

impl Burnable for NFTCore {
    /// Burns this token.
    ///
    /// * Reverts
    ///
    /// * When sender is not the owner of the token.
    #[storage(read, write)]
    fn burn(self) {
        // Ensure this is a valid token
        let sender = msg_sender().unwrap();
        
        require(self.owner == sender, AccessError::SenderNotOwner);

        let owner = self.owner;
        let token_id = self.token_id;
        store(sha256((BALANCES, self.owner)), get::<u64>(sha256((BALANCES, self.owner))) - 1);
        store(sha256((TOKENS, self.token_id)), Option::None::<NFTCore>());

        log(BurnEvent {
            owner,
            token_id,
        });
    }
}

#[storage(read, write)]
pub fn burn(token_id: u64) {
    let nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id)));
    require(nft.is_some(), InputError::TokenDoesNotExist);
    nft.unwrap().burn();
}
