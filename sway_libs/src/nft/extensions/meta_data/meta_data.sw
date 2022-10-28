library meta_data;

dep meta_data_structures;

use meta_data_structures::NFTMetaData;
use ::nft::{errors::InputError, nft_core::NFTCore, nft_storage::{META_DATA, TOKENS}};
use std::{hash::sha256, storage::{get, store}};

pub trait MetaData {
    #[storage(read)]
    fn meta_data(self) -> NFTMetaData;
    #[storage(write)]
    fn set_meta_data(self, value: u64);
}

impl MetaData for NFTCore {
    #[storage(read)]
    fn meta_data(self) -> NFTMetaData {
        get::<NFTMetaData>(sha256((META_DATA, self.token_id)))
    }

    #[storage(write)]
    fn set_meta_data(self, value: u64) {
        store(sha256((META_DATA, self.token_id)), ~NFTMetaData::new(value));
    }
}

#[storage(read)]
pub fn meta_data(token_id: u64) -> NFTMetaData {
    let nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id)));
    require(nft.is_some(), InputError::TokenDoesNotExist);
    nft.unwrap().meta_data()
}

#[storage(read, write)]
pub fn set_meta_data(token_id: u64, value: u64) {
    let nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id)));
    require(nft.is_some(), InputError::TokenDoesNotExist);
    nft.unwrap().set_meta_data(value);
}
