library meta_data;

dep meta_data_structures;

use meta_data_structures::NFTMetaData;
use ::nft::{errors::InputError, nft_core::NFTCore, nft_storage::{META_DATA, TOKENS}};
use std::{hash::sha256, storage::{get, store}};

// TODO: Use trait constraints here to allow for any struct once 
// https://github.com/FuelLabs/sway/issues/970 is resovled
pub trait MetaData {
    /// Returns the metadata for this token
    #[storage(read)]
    fn meta_data(self) -> Option<NFTMetaData>;
    /// Creates new metadata for this token.
    ///
    /// # Arguments
    ///
    /// * `value` - The metadata value to be included in the new metadata.
    #[storage(write)]
    fn set_meta_data(self, value: u64);
}

impl MetaData for NFTCore {
    #[storage(read)]
    fn meta_data(self) -> Option<NFTMetaData> {
        get::<Option<NFTMetaData>>(sha256((META_DATA, self.token_id)))
    }

    #[storage(write)]
    fn set_meta_data(self, value: u64) {
        store(sha256((META_DATA, self.token_id)), Option::Some(~NFTMetaData::new(value)));
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
/// * `token_id` - The token which the metadata should be set for.
/// * `value` - The meatadata value which should be set
///
/// # Reverts
///
/// * When the `token_id` does not map to an existing token
#[storage(read, write)]
pub fn set_meta_data(token_id: u64, value: u64) {
    let nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id)));
    require(nft.is_some(), InputError::TokenDoesNotExist);
    nft.unwrap().set_meta_data(value);
}
