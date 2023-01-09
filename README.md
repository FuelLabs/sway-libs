<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".docs/sway_libraries_white.png">
        <img alt="SwayApps logo" width="400px" src=".docs/sway_libraries_black.png">
    </picture>
</p>

<p align="center">
    <a href="https://github.com/FuelLabs/sway-libs/actions/workflows/ci.yml" alt="CI">
        <img src="https://github.com/FuelLabs/sway-libs/actions/workflows/ci.yml/badge.svg" />
    </a>
    <a href="https://crates.io/crates/forc/0.32.2" alt="forc">
        <img src="https://img.shields.io/badge/forc-v0.32.2-orange" />
    </a>
    <a href="./LICENSE" alt="forc">
        <img src="https://img.shields.io/github/license/FuelLabs/sway-libs" />
    </a>
    <a href="https://discord.gg/xfpK4Pe">
        <img src="https://img.shields.io/discord/732892373507375164?color=6A7EC2&logo=discord&logoColor=ffffff&labelColor=6A7EC2&label=Discord" />
    </a>
</p>

## Overview

The purpose of this repository is to contain libraries which users can import and use that are not part of the standard library. 

These libraries contain helper functions, generalized standards, and other tools valuable to blockchain development.

> **Note**
> Sway is a language under heavy development therefore the libraries may not be the most ergonomic. Over time they should receive updates / improvements in order to demonstrate how Sway can be used in real use cases.

### Libraries

- [Binary Merkle Proof](./sway_libs/src/merkle_proof/) is used to verify Binary Merkle Trees computed off-chain.
- [Non-Fungible Token (NFT)](./sway_libs/src/nft/) is a token library which provides unqiue collectibles, identified and differentiated by token IDs.
- [String](./sway_libs/src/string/) is an interface to implement dynamic length strings that are UTF-8 encoded.
- [Signed Integers](./sway_libs/src/signed_integers/) is an interface to implement signed integers.
- [Unsigned Fixed Point 64 bit](./sway_libs/src/fixed_point/ufp/ufp64) is an interface to implement fixed-point 64 bit numbers.
- [StorageMapVec](./sway_libs/src/storagemapvec/) is a temporary workaround for a StorageMap<K, StorageVec<V>> type

## Using a library

To import the Merkle Proof library the following should be added to the project's `Forc.toml` file under `[dependencies]` with the most recent release:

```rust
sway_libs = { git = "https://github.com/FuelLabs/sway-libs", tag = "v0.1.0" }
```

You may then import your desired library in your Sway Smart Contract as so:

```rust
use sway_libs::<library_name>::<library_function>;
```

For example, to import the Merkle Proof library use the following statement:

```rust
sway_libs::binary_merkle_proof::verify_proof;
```

> **Note**
> All projects currently use `forc v0.32.2`, `fuels-rs v0.33.0` and `fuel-core 0.15.1`.

## Contributing

Check [CONTRIBUTING.md](./CONTRIBUTING.md) for more info!
