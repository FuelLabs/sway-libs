library;

use src7::Metadata;
use std::{
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
    /// # Number of Storage Accesses
    ///
    /// * Writes: `2`
    ///
    /// # Example
    ///
    /// ```sway
    /// use src7::Metadata;
    /// use libraries::asset::metadata::*;
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
    pub fn insert(self, asset: AssetId, key: String, metadata: Metadata) {
        let hashed_key = sha256((asset, key));

        match metadata {
            Metadata::Int(data) => {
                write(hashed_key, 0, data);
                write(sha256((hashed_key, self.slot)), 0, 0);
            },
            Metadata::B256(data) => {
                write(hashed_key, 0, data);
                write(sha256((hashed_key, self.slot)), 0, 1);
            },
            Metadata::String(data) => {
                let storage_string: StorageKey<StorageString> = StorageKey::new(hashed_key, 0, hashed_key);
                storage_string.write_slice(data);
                write(sha256((hashed_key, self.slot)), 0, 2);
            },
            Metadata::Bytes(data) => {
                let storage_bytes: StorageKey<StorageBytes> = StorageKey::new(hashed_key, 0, hashed_key);
                storage_bytes.write_slice(data);
                write(sha256((hashed_key, self.slot)), 0, 3);
            }
        }
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
    /// use src7::Metadata;
    /// use libraries::asset::metadata::*;
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

        match read::<u64>(sha256((hashed_key, self.slot)), 0) {
            Option::Some(0) => {
                Option::Some(Metadata::Int(read::<u64>(hashed_key, 0).unwrap()))
            },
            Option::Some(1) => {
                Option::Some(Metadata::B256(read::<b256>(hashed_key, 0).unwrap()))
            },
            Option::Some(2) => {
                let storage_string: StorageKey<StorageString> = StorageKey::new(hashed_key, 0, hashed_key);
                Option::Some(Metadata::String(storage_string.read_slice().unwrap()))
            },
            Option::Some(3) => {
                let storage_bytes: StorageKey<StorageBytes> = StorageKey::new(hashed_key, 0, hashed_key);
                Option::Some(Metadata::Bytes(storage_bytes.read_slice().unwrap()))
            },
            _ => Option::None,
        }
    }
}

/// Unconditionally stores metadata for a specific asset and key pair.
///
/// # Arguments
///
/// * `metadata_key`: [StorageKey<StorageMetadata>] - The storage location for metadata.
/// * `asset`: [AssetId] - The asset for the metadata to be stored.
/// * `key`: [String] - The key for the metadata to be stored.
/// * `metadata`: [Metadata] - The metadata which to be stored.
///
/// # Number of Storage Accesses
///
/// * Writes: `2`
///
/// # Example
///
/// ```sway
/// use src7::Metadata;
/// use libraries::asset::metadata::*;
///
/// storage {
///     metadata: StorageMetadata = StorageMetadata {}
/// }
///
/// fn foo(asset: AssetId, key: String, metadata: Metadata) {
///     _set_metadata(storage.metadata, asset, key, metadata);
/// }
/// ```
#[storage(read, write)]
pub fn _set_metadata(
    metadata_key: StorageKey<StorageMetadata>,
    asset: AssetId,
    key: String,
    metadata: Metadata,
) {
    metadata_key.insert(asset, key, metadata);
}

abi SetAssetMetadata {
    #[storage(read, write)]
    fn set_metadata(asset: AssetId, key: String, metadata: Metadata);
}

impl Metadata {
    /// Returns the underlying metadata as a `String`.
    ///
    /// # Returns
    ///
    /// * [Option<String>] - `Some` if the underlying type is a `String`, otherwise `None`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use std::string::String;
    /// use libraries::asset::metadata::*;
    /// use src7::{SRC7, Metadata};
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, key: String) {
    ///     let metadata_abi = abi(SRC7, contract_id);
    ///     let metadata = metadata_abi.metadata(asset, key);
    ///
    ///     let string = metadata.unwrap().as_string();
    ///     assert(string.len() != 0);
    /// }
    /// ```
    pub fn as_string(self) -> Option<String> {
        match self {
            Self::String(data) => Option::Some(data),
            _ => Option::None,
        }
    }

    /// Returns whether the underlying metadata is a `String`.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` if the metadata is a `String`, otherwise `false`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use std::string::String;
    /// use libraries::asset::metadata::*;
    /// use src7::{SRC7, Metadata};
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, key: String) {
    ///     let metadata_abi = abi(SRC7, contract_id);
    ///     let metadata = metadata_abi.metadata(asset, key);
    ///
    ///     assert(metadata.unwrap().is_string());
    /// }
    /// ```
    pub fn is_string(self) -> bool {
        match self {
            Self::String(_) => true,
            _ => false,
        }
    }

    /// Returns the underlying metadata as a `u64`.
    ///
    /// # Returns
    ///
    /// * [Option<u64>] - `Some` if the underlying type is a `u64`, otherwise `None`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use std::string::String;
    /// use libraries::asset::metadata::*;
    /// use src7::{SRC7, Metadata};
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, key: String) {
    ///     let metadata_abi = abi(SRC7, contract_id);
    ///     let metadata = metadata_abi.metadata(asset, key);
    ///
    ///     let int = metadata.unwrap().as_u64();
    ///     assert(int != 0);
    /// }
    /// ```
    pub fn as_u64(self) -> Option<u64> {
        match self {
            Self::Int(data) => Option::Some(data),
            _ => Option::None,
        }
    }

    /// Returns whether the underlying metadata is a `u64`.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` if the metadata is a `u64`, otherwise `false`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use std::string::String;
    /// use libraries::asset::metadata::*;
    /// use src7::{SRC7, Metadata};
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, key: String) {
    ///     let metadata_abi = abi(SRC7, contract_id);
    ///     let metadata = metadata_abi.metadata(asset, key);
    ///
    ///     assert(metadata.unwrap().is_u64());
    /// }
    /// ```
    pub fn is_u64(self) -> bool {
        match self {
            Self::Int(_) => true,
            _ => false,
        }
    }

    /// Returns the underlying metadata as `Bytes`.
    ///
    /// # Returns
    ///
    /// * [Option<Bytes>] - `Some` if the underlying type is `Bytes`, otherwise `None`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use std::{bytes::Bytes, string::String};
    /// use libraries::asset::metadata::*;
    /// use src7::{SRC7, Metadata};
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, key: String) {
    ///     let metadata_abi = abi(SRC7, contract_id);
    ///     let metadata = metadata_abi.metadata(asset, key);
    ///
    ///     let bytes = metadata.unwrap().as_bytes();
    ///     assert(bytes.len() != 0);
    /// }
    /// ```
    pub fn as_bytes(self) -> Option<Bytes> {
        match self {
            Self::Bytes(data) => Option::Some(data),
            _ => Option::None,
        }
    }

    /// Returns whether the underlying metadata is `Bytes`.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` if the metadata is `Bytes`, otherwise `false`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use std::{bytes::Bytes, string::String};
    /// use libraries::asset::metadata::*;
    /// use src7::{SRC7, Metadata};
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, key: String) {
    ///     let metadata_abi = abi(SRC7, contract_id);
    ///     let metadata = metadata_abi.metadata(asset, key);
    ///
    ///     assert(metadata.unwrap().is_bytes());
    /// }
    /// ```
    pub fn is_bytes(self) -> bool {
        match self {
            Self::Bytes(_) => true,
            _ => false,
        }
    }

    /// Returns the underlying metadata as a `b256`.
    ///
    /// # Returns
    ///
    /// * [Option<u64>] - `Some` if the underlying type is a `b256`, otherwise `None`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use std::{constants::ZERO_B256, string::String};
    /// use libraries::asset::metadata::*;
    /// use src7::{SRC7, Metadata};
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, key: String) {
    ///     let metadata_abi = abi(SRC7, contract_id);
    ///     let metadata = metadata_abi.metadata(asset, key);
    ///
    ///     let val = metadata.unwrap().as_b256();
    ///     assert(val != ZERO_B256);
    /// }
    /// ```
    pub fn as_b256(self) -> Option<b256> {
        match self {
            Self::B256(data) => Option::Some(data),
            _ => Option::None,
        }
    }

    /// Returns whether the underlying metadata is a `b256`.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` if the metadata is a `b256`, otherwise `false`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use std::string::String;
    /// use libraries::asset::metadata::*;
    /// use src7::{SRC7, Metadata};
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, key: String) {
    ///     let metadata_abi = abi(SRC7, contract_id);
    ///     let metadata = metadata_abi.metadata(asset, key);
    ///
    ///     assert(metadata.unwrap().is_b256());
    /// }
    /// ```
    pub fn is_b256(self) -> bool {
        match self {
            Self::B256(_) => true,
            _ => false,
        }
    }
}
