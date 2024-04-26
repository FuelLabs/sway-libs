contract;

use std::{bytes::Bytes, string::String};

// ANCHOR: import
use sway_libs::asset::metadata::*;
use standards::src7::*;
// ANCHOR_END: import

// ANCHOR: src7_abi
abi SRC7 {
    #[storage(read)]
    fn metadata(asset: AssetId, key: String) -> Option<Metadata>;
}
// ANCHOR_END: src7_abi

// ANCHOR: src7_storage
storage {
    metadata: StorageMetadata = StorageMetadata {},
}
// ANCHOR_END: src7_storage

// ANCHOR: metadata_enum
pub enum Metadata {
    B256: b256,
    Bytes: Bytes,
    Int: u64,
    String: String,
}
// ANCHOR_END: metadata_enum

// ANCHOR: as_b256
fn b256_type(my_metadata: Metadata) {
    assert(my_metadata.is_b256());

    let my_b256: b256 = my_metadata.as_b256().unwrap();
}
// ANCHOR_END: as_b256

// ANCHOR: as_bytes
fn bytes_type(my_metadata: Metadata) {
    assert(my_metadata.is_bytes());

    let my_bytes: Bytes = my_metadata.as_bytes().unwrap();
}
// ANCHOR_END: as_bytes

// ANCHOR: as_u64
fn u64_type(my_metadata: Metadata) {
    assert(my_metadata.is_u64());

    let my_u64: u64 = my_metadata.as_u64().unwrap();
}
// ANCHOR_END: as_u64

// ANCHOR: as_string
fn string_type(my_metadata: Metadata) {
    assert(my_metadata.is_string());

    let my_string: String = my_metadata.as_string().unwrap();
}
// ANCHOR_END: as_string
