contract;

use std::string::String;

// ANCHOR: basic_src7
use asset::metadata::*;
use standards::src7::{Metadata, SRC7};

storage {
    metadata: StorageMetadata = StorageMetadata {},
}

// Implement the SRC-7 Standard for this contract
impl SRC7 for Contract {
    #[storage(read)]
    fn metadata(asset: AssetId, key: String) -> Option<Metadata> {
        // Return the stored metadata
        storage.metadata.get(asset, key)
    }
}
// ANCHOR_END: basic_src7
