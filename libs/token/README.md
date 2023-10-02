<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".docs/token-logo-dark-theme.png">
        <img alt="SwayApps logo" width="400px" src=".docs/token-logo-light-theme.png">
    </picture>
</p>

# Overview

The Token library provides basic helper functions for the [SRC-20; Token Standard](https://github.com/FuelLabs/sway-standards/tree/master/standards/src_20), [SRC-3; Mint and Burn Standard](https://github.com/FuelLabs/sway-standards/tree/master/standards/src_3), and the [SRC-7; Arbitrary Asset Metadata Standard](https://github.com/FuelLabs/sway-standards/tree/master/standards/src_7). It is intended to make develpment of Native Assets using Sway quick and easy while following the standard's specifications.

For more information please see the [specification](./SPECIFICATION.md).

# Using the Library

## Getting Started

In order to use the Token library it must be added to the Forc.toml file and then imported into your Sway project. To add Sway-libs as a dependency to the Forc.toml file in your project please see the [README.md](../../README.md).

You may import the Token library's functionalities like so:

```rust
use token::*;
```

Once imported, the Token library's functions should be available. To use them, be sure to add the storage block bellow to your contract which enables the [SRC-20](https://github.com/FuelLabs/sway-standards/tree/master/standards/src_20) standard.

```rust
storage {
    total_assets: u64 = 0,
    total_supply: StorageMap<AssetId, u64> = StorageMap {},
    name: StorageMap<AssetId, StorageString> = StorageMap {},
    symbol: StorageMap<AssetId, StorageString> = StorageMap {},
    decimals: StorageMap<AssetId, u8> = StorageMap {},
}
```

## Basic Functionality

To use a function, simply pass the `StorageKey` from the prescribed storage block above. The example below shows the implementation of the [SRC-20](https://github.com/FuelLabs/sway-standards/tree/master/standards/src_20) standard in combination with the Token library with no user defined restrictions or custom functionality.

```rust
use token::base::{
    _total_assets, 
    _total_supply,
    _name,
    _symbol,
    _decimals
};
use src_20::SRC20;
use std::{hash::Hash, string::String, storage::storage_string::*};

storage {
    total_assets: u64 = 0,
    total_supply: StorageMap<AssetId, u64> = StorageMap {},
    name: StorageMap<AssetId, StorageString> = StorageMap {},
    symbol: StorageMap<AssetId, StorageString> = StorageMap {},
    decimals: StorageMap<AssetId, u8> = StorageMap {},
}

impl SRC20 for Contract {
    #[storage(read)]
    fn total_assets() -> u64 {
        _total_assets(storage.total_assets)
    }

    #[storage(read)]
    fn total_supply(asset: AssetId) -> Option<u64> {
        _total_supply(storage.total_supply, asset)
    }

    #[storage(read)]
    fn name(asset: AssetId) -> Option<String> {
        _name(storage.name, asset)
    }

    #[storage(read)]
    fn symbol(asset: AssetId) -> Option<String> {
        _symbol(storage.symbol, asset)
    }

    #[storage(read)]
    fn decimals(asset: AssetId) -> Option<u8> {
        _decimals(storage.decimals, asset)
    }
}
```

For more information please see the [specification](./SPECIFICATION.md).

> **NOTE** Until [Issue #5025](https://github.com/FuelLabs/sway/issues/5025) is resolved, in order to use the SRC-7 portion of the library, you must also add the [SRC-7](https://github.com/FuelLabs/sway-standards/tree/master/standards/src_7) standard as a dependency.
