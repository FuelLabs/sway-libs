contract;

use std::string::String;

// ANCHOR: setting_src7_attributes
use sway_libs::asset::metadata::*;
use standards::src7::Metadata;

storage {
    metadata: StorageMetadata = StorageMetadata {},
}

impl SetAssetMetadata for Contract {
    #[storage(read, write)]
    fn set_metadata(asset: AssetId, key: String, metadata: Metadata) {
        _set_metadata(storage.metadata, asset, key, metadata);
    }
}
// ANCHOR_END: setting_src7_attributes
