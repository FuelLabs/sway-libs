library meta_data;

dep meta_data_structures;

use meta_data_structures::NFTMetaData;
use ::nft::{errors::InputError, nft_core::NFTCore, nft_storage::{META_DATA, TOKENS}};
use std::{hash::sha256, storage::{get, store}};

pub trait MetaData {
    #[storage(read)]
    fn meta_data(self) -> NFTMetaData;
    #[storage(write)]
    fn set_meta_data(self, meta_data: NFTMetaData);
}

impl MetaData for NFTCore {
    #[storage(read)]
    fn meta_data(self) -> NFTMetaData {
        get::<NFTMetaData>(sha256((META_DATA, self.token_id)))
    }

    #[storage(write)]
    fn set_meta_data(self, meta_data: NFTMetaData) {
        store(sha256((META_DATA, self.token_id)), meta_data);
    }
}

#[storage(read)]
pub fn meta_data(token_id: u64) -> NFTMetaData {
    let nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id)));
    require(nft.is_some(), InputError::TokenDoesNotExist);
    nft.unwrap().meta_data()
}

#[storage(read, write)]
pub fn set_meta_data(meta_data: NFTMetaData, token_id: u64) {
    let nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id)));
    require(nft.is_some(), InputError::TokenDoesNotExist);
    nft.unwrap().set_meta_data(meta_data);
}
