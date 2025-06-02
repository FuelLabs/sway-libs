contract;

use std::hash::Hash;

// ANCHOR: import
use asset::supply::*;
use standards::src3::*;
// ANCHOR_END: import

// ANCHOR: src3_abi
abi SRC3 {
    #[storage(read, write)]
    fn mint(recipient: Identity, sub_id: Option<SubId>, amount: u64);
    #[payable]
    #[storage(read, write)]
    fn burn(vault_sub_id: SubId, amount: u64);
}
// ANCHOR_END: src3_abi

// ANCHOR: src3_storage
storage {
    total_assets: u64 = 0,
    total_supply: StorageMap<AssetId, u64> = StorageMap {},
}
// ANCHOR_END: src3_storage
