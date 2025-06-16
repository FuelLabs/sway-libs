contract;

use std::hash::*;

// ANCHOR: basic_src3
use asset::supply::{_burn, _mint};
use src3::SRC3;

storage {
    total_assets: u64 = 0,
    total_supply: StorageMap<AssetId, u64> = StorageMap {},
}

// Implement the SRC-3 Standard for this contract
impl SRC3 for Contract {
    #[storage(read, write)]
    fn mint(recipient: Identity, sub_id: Option<SubId>, amount: u64) {
        // Pass the StorageKeys to the `_mint()` function from the Asset Library.
        _mint(
            storage
                .total_assets,
            storage
                .total_supply,
            recipient,
            sub_id
                .unwrap_or(b256::zero()),
            amount,
        );
    }

    // Pass the StorageKeys to the `_burn_()` function from the Asset Library.
    #[payable]
    #[storage(read, write)]
    fn burn(sub_id: SubId, amount: u64) {
        _burn(storage.total_supply, sub_id, amount);
    }
}
// ANCHOR_END: basic_src3
