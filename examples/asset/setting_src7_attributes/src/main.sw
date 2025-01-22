contract;

use std::string::String;
use std::bytes::Bytes;

// ANCHOR: setting_src7_attributes
use sway_libs::asset::metadata::*;
use standards::src7::Metadata;

storage {
    metadata: StorageMetadata = StorageMetadata {},
}

impl SetAssetMetadata for Contract {
    #[storage(read, write)]
    fn set_metadata(asset: AssetId, key: String, metadata: Metadata) {
        // add your authentication logic here
        // eg. only_owner()
        _set_metadata(storage.metadata, asset, key, metadata);
    }
}
// ANCHOR_END: setting_src7_attributes

// ANCHOR: setting_src7_attributes_custom_abi
abi CustomSetAssetMetadata {
    #[storage(read, write)]
    fn set_metadata(
        asset: AssetId,
        key: String,
        bits256: b256,
        bytes: Bytes,
        int: u64,
        string: String,
    );
}

impl CustomSetAssetMetadata for Contract {
    #[storage(read, write)]
    fn set_metadata(
        asset: AssetId,
        key: String,
        bits256: b256,
        bytes: Bytes,
        int: u64,
        string: String,
    ) {
        let b256_metadata = Metadata::B256(bits256);
        let bytes_metadata = Metadata::Bytes(bytes);
        let int_metadata = Metadata::Int(int);
        let string_metadata = Metadata::String(string);

        // your authentication logic here

        // set whichever metadata you want
        storage.metadata.insert(asset, key, string_metadata);
    }
}
// ANCHOR_END: setting_src7_attributes_custom_abi
