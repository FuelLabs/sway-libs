# Supply Functionality

For implementation details on the Asset Library supply functionality please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/asset/mint/index.html).

## Importing the Asset Library Supply Functionality

To import the Asset Library Supply Functionality and [SRC-3](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-3.md) Standard to your Sway Smart Contract, add the following to your Sway file:

```sway
use sway_libs::asset::supply::*;
use standards::src3::*;
```

## Integration with the SRC-3 Standard

The [SRC-3](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-3.md) definition states that the following abi implementation is required for any Native Asset on Fuel which mints and burns tokens:

```sway
abi SRC3 {
    #[storage(read, write)]
    fn mint(recipient: Identity, vault_sub_id: SubId, amount: u64);
    #[storage(read, write)]
    fn burn(vault_sub_id: SubId, amount: u64);
}
```

The Asset Library has the following complimentary functions for each function in the `SRC3` abi:

- `_mint()`
- `_burn()`

> **NOTE** The `_mint()` and `_burn()` functions will mint and burn assets *unconditionally*. External checks should be applied to restrict the minting and burning of assets.

## Setting Up Storage

Once imported, the Asset Library's supply functionality should be available. To use them, be sure to add the storage block bellow to your contract which enables the [SRC-3](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-3.md) standard.

```sway
storage {
    total_assets: u64 = 0,
    total_supply: StorageMap<AssetId, u64> = StorageMap {},
}
```

## Implementing the SRC-3 Standard with the Asset Library

To use a base function, simply pass the `StorageKey` from the prescribed storage block. The example below shows the implementation of the [SRC-3](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-3.md) standard in combination with the Asset Library with no user defined restrictions or custom functionality. It is recommended that the [Ownership Library](../../access_security/ownership/) is used in conjunction with the Asset Library;s supply functionality to ensure only a single user has permissions to mint an Asset.

```sway
use sway_libs::asset::supply::{_mint, _burn};
use standards::src3::SRC3;

storage {
    total_assets: u64 = 0,
    total_supply: StorageMap<AssetId, u64> = StorageMap {},
}

// Implement the SRC-3 Standard for this contract
impl SRC3 for Contract {
    #[storage(read, write)]
    fn mint(recipient: Identity, sub_id: SubId, amount: u64) {
        // Pass the StorageKeys to the `_mint()` function from the Asset Library.
        _mint(
            storage.total_assets,
            storage.total_supply,
            recipient,
            sub_id,
            amount,
        );
    }

    // Pass the StorageKeys to the `_burn_()` function from the Asset Library.
    #[storage(read, write)]
    fn burn(sub_id: SubId, amount: u64) {
        _burn(storage.total_supply, sub_id, amount);
    }
}
```

> **NOTE** The `_mint()` and `_burn()` functions will mint and burn assets *unconditionally*. External checks should be applied to restrict the minting and burning of assets.
