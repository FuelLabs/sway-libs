library;

use src_7::Metadata;
use std::string::String;

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
    /// use token::src_7::*;
    /// use src_7::{SRC7, Metadata};
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, key: String) {
    ///     let metadata_abi = abi(SRC7, contract_id);
    ///     let metadata = metadata_abi.metadata(asset, key);
    ///
    ///     let string = metadata.unwrap().as_string();
    ///     assert(string.len() != 0);
    /// }
    /// ```
    fn as_string(self) -> Option<String> {
        match self {
            StringData(data) => Option::Some(data),
            _ => Option::None(),
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
    /// use token::src_7::*;
    /// use src_7::{SRC7, Metadata};
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, key: String) {
    ///     let metadata_abi = abi(SRC7, contract_id);
    ///     let metadata = metadata_abi.metadata(asset, key);
    ///
    ///     assert(metadata.unwrap().is_string());
    /// }
    /// ```
    fn is_string(self) -> bool {
        match self {
            StringData(data) => true,
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
    /// use token::src_7::*;
    /// use src_7::{SRC7, Metadata};
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, key: String) {
    ///     let metadata_abi = abi(SRC7, contract_id);
    ///     let metadata = metadata_abi.metadata(asset, key);
    ///
    ///     let int = metadata.unwrap().as_u64();
    ///     assert(int != 0);
    /// }
    /// ```
    fn as_u64(self) -> Option<u64> {
        match self {
            IntData(data) => Option::Some(data),
            _ => Option::None(),
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
    /// use token::src_7::*;
    /// use src_7::{SRC7, Metadata};
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, key: String) {
    ///     let metadata_abi = abi(SRC7, contract_id);
    ///     let metadata = metadata_abi.metadata(asset, key);
    ///
    ///     assert(metadata.unwrap().is_u64());
    /// }
    /// ```
    fn is_u64(self) -> bool {
        match self {
            IntData(data) => true,
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
    /// use token::src_7::*;
    /// use src_7::{SRC7, Metadata};
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, key: String) {
    ///     let metadata_abi = abi(SRC7, contract_id);
    ///     let metadata = metadata_abi.metadata(asset, key);
    ///
    ///     let bytes = metadata.unwrap().as_bytes();
    ///     assert(bytes.len() != 0);
    /// }
    /// ```
    fn as_bytes(self) -> Option<Bytes> {
        match self {
            BytesData(data) => Option::Some(data),
            _ => Option::None(),
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
    /// use token::src_7::*;
    /// use src_7::{SRC7, Metadata};
    ///
    /// fn foo(contract_id: ContractId, asset: AssetId, key: String) {
    ///     let metadata_abi = abi(SRC7, contract_id);
    ///     let metadata = metadata_abi.metadata(asset, key);
    ///
    ///     assert(metadata.unwrap().is_bytes());
    /// }
    /// ```
    fn is_bytes(self) -> bool {
        match self {
            BytesData(data) => true,
            _ => false,
        }
    }
}
