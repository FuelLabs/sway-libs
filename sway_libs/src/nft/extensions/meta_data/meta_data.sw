library meta_data;

dep meta_data_structures;

use meta_data_structures::NFTMetaData;
use ::nft::{errors::InputError, nft_core::NFTCore, nft_storage::{META_DATA, TOKENS}};
use std::{hash::sha256, storage::{get, store}};

pub trait MetaData<T> {
    /// Returns the metadata for this token
    #[storage(read)]
    fn meta_data(self) -> Option<T>;

    /// Creates new metadata for this token.
    ///
    /// # Arguments
    ///
    /// * `metadata` - The new metadata to overwrite the existing metadata.
    #[storage(write)]
    fn set_meta_data(self, metadata: Option<T>);
}

impl<T> MetaData<T> for NFTCore {
    #[storage(read)]
    fn meta_data(self) -> Option<T> {
        get::<Option<T>>(sha256((META_DATA, self.token_id)))
    }

    #[storage(write)]
    fn set_meta_data(self, metadata: Option<T>) {
        store(sha256((META_DATA, self.token_id)), metadata);
    }
}

/// Returns the metadata for a specific token.
///
/// # Arguments
///
/// * `token_id` - The id of the token which the metadata should be returned
#[storage(read)]
pub fn meta_data(token_id: u64) -> Option<NFTMetaData> {
    let nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id)));
    match nft {
        Option::Some(nft) => {
            nft.meta_data()
        },
        Option::None(nft) => {
            Option::None()
        }
    }
}

/// Sets the metadata for the specified token.
///
/// # Arguments
///
/// * `metadata` - The metadata which should be set.
/// * `token_id` - The token which the metadata should be set for.
///
/// # Reverts
///
/// * When the `token_id` does not map to an existing token
#[storage(read, write)]
pub fn set_meta_data(metadata: Option<NFTMetaData>, token_id: u64) {
    let nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id)));
    require(nft.is_some(), InputError::TokenDoesNotExist);

    nft.unwrap().set_meta_data(metadata);
}
