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
    fn set_metadata(asset: AssetId, metadata: Option<Metadata>, key: String) {
        _set_metadata(storage.metadata, asset, metadata, key);
    }
}
// ANCHOR_END: setting_src7_attributes
