# Base Functionality

For implementation details on the Asset Library base functionality please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/asset/base/index.html).

## Importing the Asset Library Base Functionality

In order to use the Asset Library, Sway Libs and [Sway Standards](https://github.com/FuelLabs/sway-standards) must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../getting_started/index.md). To add Sway Standards as a dependency please see the [Sway Standards Book](https://github.com/FuelLabs/sway-standards).

To import the Asset Library Base Functionality and [SRC-20](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-20.md) Standard to your Sway Smart Contract, add the following to your Sway file:

```sway
use sway_libs::asset::base::*;
use standards::src20::*;
```

## Integration with the SRC-20 Standard

The [SRC-20](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-20.md) definition states that the following abi implementation is required for any Native Asset on Fuel:

```sway
abi SRC20 {
    #[storage(read)]
    fn total_assets() -> u64;
    #[storage(read)]
    fn total_supply(asset: AssetId) -> Option<u64>;
    #[storage(read)]
    fn name(asset: AssetId) -> Option<String>;
    #[storage(read)]
    fn symbol(asset: AssetId) -> Option<String>;
    #[storage(read)]
    fn decimals(asset: AssetId) -> Option<u8>;
}
```

The Asset Library has the following complimentary functions for each function in the `SRC20` abi:

- `_total_assets()`
- `_total_supply()`
- `_name()`
- `_symbol()`
- `_decimals()`

The following ABI and functions are also provided to set your [SRC-20](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-20.md) standard storage values:

```sway
abi SetAssetAttributes {
    #[storage(write)]
    fn set_name(asset: AssetId, name: String);
    #[storage(write)]
    fn set_symbol(asset: AssetId, symbol: String);
    #[storage(write)]
    fn set_decimals(asset: AssetId, decimals: u8);
}
```

- `_set_name()`
- `_set_symbol()`
- `_set_decimals()`

> **NOTE** The `_set_name()`, `_set_symbol()`, and `_set_decimals()` functions will set the attributes of an asset *unconditionally*. External checks should be applied to restrict the setting of attributes.

## Setting Up Storage

Once imported, the Asset Library's base functionality should be available. To use them, be sure to add the storage block bellow to your contract which enables the [SRC-20](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-20.md) standard.

```sway
storage {
    total_assets: u64 = 0,
    total_supply: StorageMap<AssetId, u64> = StorageMap {},
    name: StorageMap<AssetId, StorageString> = StorageMap {},
    symbol: StorageMap<AssetId, StorageString> = StorageMap {},
    decimals: StorageMap<AssetId, u8> = StorageMap {},
}
```

## Implementing the SRC-20 Standard with the Asset Library

To use the Asset Library's base functionly, simply pass the `StorageKey` from the prescribed storage block. The example below shows the implementation of the [SRC-20](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-20.md) standard in combination with the Asset Library with no user defined restrictions or custom functionality.

```sway
use sway_libs::asset::base::{
    _total_assets, 
    _total_supply,
    _name,
    _symbol,
    _decimals
};
use standards::src20::SRC20;
use std::{string::String, storage::storage_string::*};

// The SRC-20 storage block
storage {
    total_assets: u64 = 0,
    total_supply: StorageMap<AssetId, u64> = StorageMap {},
    name: StorageMap<AssetId, StorageString> = StorageMap {},
    symbol: StorageMap<AssetId, StorageString> = StorageMap {},
    decimals: StorageMap<AssetId, u8> = StorageMap {},
}

// Implement the SRC-20 Standard for this contract
impl SRC20 for Contract {
    #[storage(read)]
    fn total_assets() -> u64 {
        // Pass the `total_assets` StorageKey to `_total_assets()` from the Asset Library.
        _total_assets(storage.total_assets)
    }

    #[storage(read)]
    fn total_supply(asset: AssetId) -> Option<u64> {
        // Pass the `total_supply` StorageKey to `_total_supply()` from the Asset Library.
        _total_supply(storage.total_supply, asset)
    }

    #[storage(read)]
    fn name(asset: AssetId) -> Option<String> {
        // Pass the `name` StorageKey to `_name_()` from the Asset Library.
        _name(storage.name, asset)
    }

    #[storage(read)]
    fn symbol(asset: AssetId) -> Option<String> {
        // Pass the `symbol` StorageKey to `_symbol_()` function from the Asset Library.
        _symbol(storage.symbol, asset)
    }

    #[storage(read)]
    fn decimals(asset: AssetId) -> Option<u8> {
        // Pass the `decimals` StorageKey to `_decimals_()` function from the Asset Library.
        _decimals(storage.decimals, asset)
    }
}
```

## Setting an Asset's SRC-20 Attributes

To set some the asset attributes for an Asset, use the `SetAssetAttributes` ABI provided by the Asset Library. The example below shows the implementation of the `SetAssetAttributes` ABI with no user defined restrictions or custom functionality. It is recommended that the [Ownership Library](../ownership/index.md) is used in conjunction with the `SetAssetAttributes` ABI to ensure only a single user has permissions to set an Asset's attributes.

```sway
use sway_libs::asset::base::*;
use std::{string::String, storage::storage_string::*};

storage {
    name: StorageMap<AssetId, StorageString> = StorageMap {},
    symbol: StorageMap<AssetId, StorageString> = StorageMap {},
    decimals: StorageMap<AssetId, u8> = StorageMap {},
}

impl SetAssetAttributes for Contract {
    #[storage(write)]
    fn set_name(asset: AssetId, name: String) {
        _set_name(storage.name, asset, name);
    }

    #[storage(write)]
    fn set_symbol(asset: AssetId, symbol: String) {
        _set_symbol(storage.symbol, asset, symbol);
    }

    #[storage(write)]
    fn set_decimals(asset: AssetId, decimals: u8) {
        _set_decimals(storage.decimals, asset, decimals);
    }
}
```

> **NOTE** The `_set_name()`, `_set_symbol()`, and `_set_decimals()` functions will set the attributes of an asset *unconditionally*. External checks should be applied to restrict the setting of attributes.
