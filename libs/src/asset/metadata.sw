library;

use standards::src7::{Metadata, SetMetadataEvent};
use std::{
    auth::msg_sender,
    bytes::Bytes,
    hash::{
        Hash,
        sha256,
    },
    storage::{
        storage_api::{
            read,
            write,
        },
        storage_bytes::*,
        storage_string::*,
    },
    string::String,
};
use ::asset::errors::SetMetadataError;

/// A persistent storage type to store the SRC-7; Metadata Standard type.
///
/// # Additional Information
///
/// This type should only be used if metadata changes or cannot be set at contract deployment time.
pub struct StorageMetadata {}

impl StorageKey<StorageMetadata> {
    /// Stores metadata for a specific asset and key pair.
    ///
    /// # Arugments
    ///
    /// * `asset`: [AssetId] - The asset for the metadata to be stored.
    /// * `key`: [String] - The key for the metadata to be stored.
    /// * `metadata`: [Metadata] - The metadata which to be stored.
    ///
    /// # Reverts
    ///
    /// * When the metadata is an empty string.
    /// * When the metadata is an empty bytes.
    ///
    /// # Number of Storage Accesses
    ///
    /// * Writes: `2`
    ///
    /// # Example
    ///
    /// ```sway
    /// use standards::src7::Metadata;
    /// use sway_libs::asset::metadata::*;
    /// use std::string::String;
    ///
    /// storage {
    ///     metadata: StorageMetadata = StorageMetadata {}
    /// }
    ///
    /// fn foo(asset: AssetId, key: String, metadata: Metadata) {
    ///     storage.metadata.insert(asset, key, metadata);
    /// }
    /// ```
    #[storage(read, write)]
    pub fn insert(self, asset: AssetId, metadata: Option<Metadata>, key: String) {
        let hashed_key = sha256((asset, key));

        match metadata {
            Some(Metadata::Int(data)) => {
                write(hashed_key, 0, data);
                write(sha256((hashed_key, self.slot())), 0, 1);
            },
            Some(Metadata::B256(data)) => {
                write(hashed_key, 0, data);
                write(sha256((hashed_key, self.slot())), 0, 2);
            },
            Some(Metadata::String(data)) => {
                require(!data.is_empty(), SetMetadataError::EmptyString);

                let storage_string: StorageKey<StorageString> = StorageKey::new(hashed_key, 0, hashed_key);
                storage_string.write_slice(data);
                write(sha256((hashed_key, self.slot())), 0, 3);
            },
            Some(Metadata::Bytes(data)) => {
                require(!data.is_empty(), SetMetadataError::EmptyBytes);

                let storage_bytes: StorageKey<StorageBytes> = StorageKey::new(hashed_key, 0, hashed_key);
                storage_bytes.write_slice(data);
                write(sha256((hashed_key, self.slot())), 0, 4);
            },
            None => {
                write(sha256((hashed_key, self.slot())), 0, 0);
            }
        }

        log(SetMetadataEvent {
            asset,
            metadata: metadata,
            key,
            sender: msg_sender().unwrap(),
        });
    }

    /// Returns metadata for a specific asset and key pair.
    ///
    /// # Arugments
    ///
    /// * `asset`: [AssetId] - The asset for the metadata to be queried.
    /// * `key`: [String] - The key for the metadata to be queried.
    ///
    /// # Returns
    ///
    /// * [Option<Metadata>] - The stored metadata or `None`.
    ///
    /// # Number of Storage Accesses
    ///
    /// * Reads: `2`
    ///
    /// # Example
    ///
    /// ```sway
    /// use standards::src7::Metadata;
    /// use sway_libs::asset::metadata::*;
    /// use std::string::String;
    ///
    /// storage {
    ///     metadata: StorageMetadata = StorageMetadata {}
    /// }
    ///
    /// fn foo(asset: AssetId, key: String) {
    ///     let returned_metadata = storage.metadata.get(asset, key, metadata);
    ///     assert(returned_metadata.is_some());
    /// }
    /// ```
    #[storage(read)]
    pub fn get(self, asset: AssetId, key: String) -> Option<Metadata> {
        let hashed_key = sha256((asset, key));

        match read::<u64>(sha256((hashed_key, self.slot())), 0) {
            Some(1) => {
                Some(Metadata::Int(read::<u64>(hashed_key, 0).unwrap()))
            },
            Some(2) => {
                Some(Metadata::B256(read::<b256>(hashed_key, 0).unwrap()))
            },
            Some(3) => {
                let storage_string: StorageKey<StorageString> = StorageKey::new(hashed_key, 0, hashed_key);
                Some(Metadata::String(storage_string.read_slice().unwrap_or(String::new())))
            },
            Some(4) => {
                let storage_bytes: StorageKey<StorageBytes> = StorageKey::new(hashed_key, 0, hashed_key);
                Some(Metadata::Bytes(storage_bytes.read_slice().unwrap_or(Bytes::new())))
            },
            _ => None,
        }
    }
}

/// Unconditionally stores metadata for a specific asset and key pair.
///
/// # Arguments
///
/// * `metadata_key`: [StorageKey<StorageMetadata>] - The storage location for metadata.
/// * `asset`: [AssetId] - The asset for the metadata to be stored.
/// * `metadata`: [Option<Metadata>] - The metadata which to be stored.
/// * `key`: [String] - The key for the metadata to be stored.
///
/// # Number of Storage Accesses
///
/// * Writes: `2`
///
/// # Example
///
/// ```sway
/// use standards::src7::Metadata;
/// use sway_libs::asset::metadata::*;
/// use std::string::String;
///
/// storage {
///     metadata: StorageMetadata = StorageMetadata {}
/// }
///
/// fn foo(asset: AssetId, key: String, metadata: Option<Metadata>) {
///     _set_metadata(storage.metadata, asset, metadata, key);
/// }
/// ```
#[storage(read, write)]
pub fn _set_metadata(
    metadata_key: StorageKey<StorageMetadata>,
    asset: AssetId,
    metadata: Option<Metadata>,
    key: String,
) {
    metadata_key.insert(asset, metadata, key);
}

/// Returns metadata for a specific asset and key pair.
///
/// # Arguments
///
/// * `metadata_key`: [StorageKey<StorageMetadata>] - The storage location for metadata.
/// * `asset`: [AssetId] - The asset for the metadata to be read.
/// * `metadata`: [Option<Metadata>] - The metadata which to be read.
/// * `key`: [String] - The key for the metadata to be read.
///
/// # Number of Storage Accesses
///
/// * Reads: `2`
///
/// # Example
///
/// ```sway
/// use standards::src7::Metadata;
/// use sway_libs::asset::metadata::*;
/// use std::string::String;
///
/// storage {
///     metadata: StorageMetadata = StorageMetadata {}
/// }
///
/// fn foo(asset: AssetId, key: String) {
///     let result: Option<Metadata> = _metadata(storage.metadata, asset, key);
/// }
/// ```
#[storage(read)]
pub fn _metadata(
    metadata_key: StorageKey<StorageMetadata>, 
    asset: AssetId, 
    key: String
) -> Option<Metadata> {
    metadata_key.get(asset, key)
} 

abi SetAssetMetadata {
    /// Stores metadata for a specific asset and key pair.
    ///
    /// # Arguments
    ///
    /// * `asset`: [AssetId] - The asset for the metadata to be stored.
    /// * `metadata`: [Option<Metadata>] - The metadata which to be stored.
    /// * `key`: [String] - The key for the metadata to be stored.
    ///
    /// # Example
    ///
    /// ```sway
    /// use standards::src7::{SRC7, Metadata};
    /// use sway_libs::asset::metadata::*;
    /// use std::string::String;
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, metadata: Option<Metadata>, key: String) {
    ///     let contract_abi = abi(SetAssetMetadata, contract_id.bits());
    ///     contract_abi.set_metadata(asset, metadata, key);
    ///     assert(contract_abi.metadata(asset, key).unwrap() == Metadata);
    /// }
    /// ```
    #[storage(read, write)]
    fn set_metadata(asset: AssetId, metadata: Option<Metadata>, key: String);
}
