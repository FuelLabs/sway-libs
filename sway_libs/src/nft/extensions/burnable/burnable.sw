library burnable;

dep burnable_events;

use burnable_events::BurnEvent;
use ::nft::{errors::AccessError, nft_core::NFTCore, nft_storage::{BALANCES, TOKENS}};
use std::{chain::auth::msg_sender, hash::sha256, logging::log, storage::{get, store}};

trait Burnable {
    #[storage(read, write)]
    fn burn(self) -> Self;
}

impl Burnable for NFTCore {
    /// Burns this token.
    ///
    /// * Reverts
    ///
    /// * When the token has no owner.
    /// * When sender is not the owner of the token.
    #[storage(read, write)]
    fn burn(self) -> Self {
        // Ensure this is a valid token
        let sender = msg_sender().unwrap();
        let owner = self.owner;
        require(owner.is_some() && owner.unwrap() == sender, AccessError::SenderNotOwner);

        let balance = get::<u64>(sha256((BALANCES, owner.unwrap())));
        store(sha256((BALANCES, owner.unwrap())), balance - 1);

        let mut nft = self;
        nft.owner = Option::None();
        store(sha256((TOKENS, self.token_id)), nft);

        log(BurnEvent {
            owner: owner.unwrap(),
            token_id: nft.token_id,
        });

        nft
    }
}
