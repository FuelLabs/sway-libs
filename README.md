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
    <a href="https://crates.io/crates/forc" alt="forc">
        <img src="https://img.shields.io/crates/v/forc?color=orange&label=forc" />
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
- [String](./sway_libs/src/string.sw) is a Rust-like implementation of the utf-8 based String library.

## Using a library

To import the Merkle Proof library the following should be added to the project's `Forc.toml` file under `[dependencies]` with the most recent release:

```rust
sway_libs = { git = "https://github.com/FuelLabs/sway-libs", version = "0.1.0" }
```

You may then import your desired library in your Sway Smart Contract as so:

```rust
use sway_libs::<library_name>::<library_function>;
```

For example, to import the Merkle Proof library use the following statement:

```rust
sway_libs::binary_merkle_proof::verify_proof;
```

## Contributing

Check [CONTRIBUTING.md](./CONTRIBUTING.md) for more info!
