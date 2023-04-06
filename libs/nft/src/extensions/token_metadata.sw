library;

mod token_metadata_structures;

use token_metadata_structures::NFTMetadata;
use ::nft_core::{errors::InputError, NFTCore, nft_storage::{TOKEN_METADATA, TOKENS}};
use std::{hash::sha256, storage::{get, store}};

pub trait TokenMetadata<T> {
    /// Returns the metadata for this token
    #[storage(read)]
    fn token_metadata(self) -> Option<T>;

    /// Creates new metadata for this token.
    ///
    /// # Arguments
    ///
    /// * `token_metadata` - The new metadata to overwrite the existing metadata.
    #[storage(write)]
    fn set_token_metadata(self, token_metadata: Option<T>);
}

impl<T> TokenMetadata<T> for NFTCore {
    #[storage(read)]
    fn token_metadata(self) -> Option<T> {
        get::<Option<T>>(sha256((TOKEN_METADATA, self.token_id))).unwrap_or(Option::None)
    }

    #[storage(write)]
    fn set_token_metadata(self, token_metadata: Option<T>) {
        store(sha256((TOKEN_METADATA, self.token_id)), token_metadata);
    }
}

/// Returns the metadata for a specific token.
///
/// # Arguments
///
/// * `token_id` - The id of the token which the metadata should be returned
///
/// # Number of Storage Accesses
///
/// * Reads: `2`
#[storage(read)]
pub fn token_metadata<T>(token_id: u64) -> Option<T> {
    let nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id))).unwrap_or(Option::None);
    match nft {
        Option::Some(nft) => {
            nft.token_metadata()
        },
        Option::None => {
            Option::None
        }
    }
}

/// Sets the metadata for the specified token.
///
/// # Arguments
///
/// * `token_metadata` - The metadata which should be set.
/// * `token_id` - The token which the metadata should be set for.
///
/// # Number of Storage Accesses
///
/// * Reads: `1`
/// * Writes: `1`
///
/// # Reverts
///
/// * When the `token_id` does not map to an existing token
#[storage(read, write)]
pub fn set_token_metadata<T>(token_metadata: Option<T>, token_id: u64) {
    let nft = get::<Option<NFTCore>>(sha256((TOKENS, token_id))).unwrap_or(Option::None);
    require(nft.is_some(), InputError::TokenDoesNotExist);

    nft.unwrap().set_token_metadata(token_metadata);
}
