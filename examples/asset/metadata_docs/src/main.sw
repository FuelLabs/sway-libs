contract;

use std::{bytes::Bytes, string::String};

// ANCHOR: import
use sway_libs::asset::metadata::{_metadata, _set_metadata, SetAssetMetadata, StorageMetadata};
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
        _set_metadata(storage.metadata, asset, key, metadata);
    }
}
// ANCHOR_END: src7_set_metadata
