<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".docs/sway-libs-logo-dark-theme.png">
        <img alt="SwayLibs logo" width="400px" src=".docs/sway-libs-logo-light-theme.png">
    </picture>
</p>

<p align="center">
    <a href="https://github.com/FuelLabs/sway-libs/actions/workflows/ci.yml" alt="CI">
        <img src="https://github.com/FuelLabs/sway-libs/actions/workflows/ci.yml/badge.svg" />
    </a>
    <a href="https://crates.io/crates/forc/0.37.0" alt="forc">
        <img src="https://img.shields.io/badge/forc-v0.37.0-orange" />
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

- [Binary Merkle Proof](./libs/merkle_proof/) is used to verify Binary Merkle Trees computed off-chain.
- [Non-Fungible Token (NFT)](./libs/nft/) is a token library which provides unqiue collectibles, identified and differentiated by token IDs.
- [Ownership](./libs/ownership/) is used to apply restrictions on functions such that only a single user may call them.
- [Reentrancy](./libs/reentrancy) is used to detect and prevent reentrancy attacks.
- [Signed Integers](./libs/signed_integers/) is an interface to implement signed integers.
- [String](./libs/strings/string/) is an interface to implement dynamic length strings that are UTF-8 encoded.
- [StorageMapVec](./libs/storagemapvec/) is a temporary workaround for a StorageMap<K, StorageVec<V>> type.
- [StorageString](./libs/strings/storage_string/) is used to store dynamic length strings that are UTF-8 encoded in storage.
- [Fixed Point Number](./libs/fixed_point/) is an interface to implement fixed-point numbers.

### Standards

- [Token Standard](./standards/frc20/) is used to add metadata to native assets on Fuel.
- [Non-Fungible Token(NFT) Standard](./standards/frc721/) is a standard ABI used to implement NFTs on Fuel.

## Using a library

To import the Merkle Proof library the following should be added to the project's `Forc.toml` file under `[dependencies]` with the most recent release:

```rust
merkle_proof = { git = "https://github.com/FuelLabs/sway-libs", tag = "v0.1.0" }
```

You may then import your desired library in your Sway Smart Contract as so:

```rust
use merkle_proof::<library_function>;
```

For example, to import the Merkle Proof library use the following statement:

```rust
merkle_proof::binary_merkle_proof::verify_proof;
```

## Running Tests

In order to run the tests make sure you are in the tests folder of this repository `sway-libs/tests/<you are here>`.

Build the test projects:

```rust
forc build
```

> **Note**
> This may take a while depending on your hardware, future improvements to Sway will decrease build times. After this has been run once, indiviual test projects may be built on their own to save time.

Run the tests:

```
cargo test
```

Any instructions related to using a specific library should be found within the README.md of that library.

> **Note**
> All projects currently use `forc v0.37.0`, `fuels-rs v0.41.0` and `fuel-core 0.17.8`.

## Contributing

Check out the [book](https://fuellabs.github.io/sway-libs/book/index.html) for more info!
