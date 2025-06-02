contract;

use std::{bytes::Bytes, string::String};

// ANCHOR: import
use asset::metadata::{_metadata, _set_metadata, SetAssetMetadata, StorageMetadata};
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

// ANCHOR: src7_metadata_convenience_function
impl SRC7 for Contract {
    #[storage(read)]
    fn metadata(asset: AssetId, key: String) -> Option<Metadata> {
        _metadata(storage.metadata, asset, key)
    }
}
// ANCHOR_END: src7_metadata_convenience_function

// ANCHOR: src7_set_metadata
impl SetAssetMetadata for Contract {
    #[storage(read, write)]
    fn set_metadata(asset: AssetId, key: String, metadata: Metadata) {
        // add your authentication logic here
        // eg. only_owner()
        _set_metadata(storage.metadata, asset, key, metadata);
    }
}
// ANCHOR_END: src7_set_metadata

#[storage(read)]
fn get_metadata(asset: AssetId, key: String) {
    // ANCHOR: get_metadata
    use asset::metadata::*; // To access trait implementations you must import everything using the glob operator.
    let metadata: Option<Metadata> = storage.metadata.get(asset, key);
    // ANCHOR_END: get_metadata

    // ANCHOR: get_metadata_match
    match metadata.unwrap() {
        Metadata::B256(b256) => {
        // do something with b256
},
        Metadata::Bytes(bytes) => {
        // do something with bytes
},
        Metadata::Int(int) => {
        // do something with int
},
        Metadata::String(string) => {
        // do something with string
},
    }
    // ANCHOR_END: get_metadata_match

    // ANCHOR: get_metadata_as
    let metadata: Metadata = storage.metadata.get(asset, key).unwrap();

    if metadata.is_b256() {
        let b256: b256 = metadata.as_b256().unwrap();
        // do something with b256
    } else if metadata.is_bytes() {
        let bytes: Bytes = metadata.as_bytes().unwrap();
        // do something with bytes
    } else if metadata.is_u64() {
        let int: u64 = metadata.as_u64().unwrap();
        // do something with int
    } else if metadata.is_string() {
        let string: String = metadata.as_string().unwrap();
        // do something with string
    }
    // ANCHOR_END: get_metadata_as
}
