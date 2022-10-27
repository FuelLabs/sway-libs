library meta_data;

dep meta_data_structures;

use meta_data_structures::NFTMetaData;
use ::nft::{nft_core::NFTCore, nft_storage::META_DATA};
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
