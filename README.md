<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset="docs/sway-libs-logo-dark-theme.png">
        <img alt="SwayLibs logo" width="400px" src="docs/sway-libs-logo-light-theme.png">
    </picture>
</p>

<p align="center">
    <a href="https://github.com/FuelLabs/sway-libs/actions/workflows/ci.yml" alt="CI">
        <img src="https://github.com/FuelLabs/sway-libs/actions/workflows/ci.yml/badge.svg" />
    </a>
    <a href="https://crates.io/crates/forc/0.60.0" alt="forc">
        <img src="https://img.shields.io/badge/forc-v0.60.0-orange" />
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

These libraries contain helper functions and other tools valuable to blockchain development.

> **NOTE:**
> Sway is a language under heavy development therefore the libraries may not be the most ergonomic. Over time they should receive updates / improvements in order to demonstrate how Sway can be used in real use cases.

## Sway Libs Docs Hub

Please refer to the [Sway Libs Docs Hub](https://docs.fuel.network/docs/sway-libs/) for documentation for a general overview on Sway Libs and how to implement libraries.

## Library Docs

For implementation details on the libraries please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/).

## Libraries

#### Assets

- [Native Asset](https://docs.fuel.network/docs/sway-libs/asset/) provides helper functions for the [SRC-20](https://docs.fuel.network/docs/sway-standards/src-20-native-asset/), [SRC-3](https://docs.fuel.network/docs/sway-standards/src-3-minting-and-burning/), and [SRC-7](https://docs.fuel.network/docs/sway-standards/src-7-asset-metadata/) standards.

#### Access Control and Security

- [Ownership](https://docs.fuel.network/docs/sway-libs/ownership/) is used to apply restrictions on functions such that only a **single** user may call them.
- [Admin](https://docs.fuel.network/docs/sway-libs/admin/) is used to apply restrictions on functions such that only a select few users may call them like a whitelist.
- [Pausable](https://docs.fuel.network/docs/sway-libs/pausable/) allows contracts to implement an emergency stop mechanism.
- [Reentrancy](https://docs.fuel.network/docs/sway-libs/reentrancy/) is used to detect and prevent reentrancy attacks.

#### Cryptography

- [Bytecode](https://docs.fuel.network/docs/sway-libs/bytecode/) is used for on-chain verification and computation of bytecode roots for contracts and predicates.
- [Merkle Proof](https://docs.fuel.network/docs/sway-libs/merkle/) is used to verify Binary Merkle Trees computed off-chain.

#### Math

- [Signed Integers](https://docs.fuel.network/docs/sway-libs/queue/) is an interface to implement signed integers.

> **NOTE:**
> The Fixed Point Number library has been deprecated pending a re-write.

#### Data Structures

- [Queue](https://docs.fuel.network/docs/sway-libs/queue/) is a linear data structure that provides First-In-First-Out (FIFO) operations.

## Upgradability Libraries

- [Upgradability](https://docs.fuel.network/docs/sway-libs/upgradability/) provides functions that can be used to implement contract upgrades via simple upgradable proxies.

## Using a library

To import a library, the following dependency should be added to the project's `Forc.toml` file under `[dependencies]`.

```rust
sway_libs = { git = "https://github.com/FuelLabs/sway-libs", tag = "v0.22.0" }
```

> **NOTE:**
> Be sure to set the tag to the latest release.

You may then import your desired library in your Sway Smart Contract as so:

```sway
use sway_libs::<library>::<library_function>;
```

For example, to import the `only_owner()` function use the following statement:

```sway
use sway_libs::ownership::only_owner;
```

For more information about implementation please refer to the [Sway Libs Docs Hub](https://docs.fuel.network/docs/sway-libs/)

## Running Tests

There are two sets of tests that should be run: inline tests and sdk-harness tests. Please make sure you are using `forc v0.60.0` and `fuel-core v0.26.0`. You can check what version you are using by running the `fuelup show` command.

Make sure you are in the source directory of this repository `sway-libs/<you are here>`.

Run the inline tests:

```bash
forc test --path libs --release --locked
```

Once these tests have passed, run the sdk-harness tests:

```bash
forc test --path tests --release --locked && cargo test --manifest-path tests/Cargo.toml
```

> **NOTE:**
> This may take a while depending on your hardware, future improvements to Sway will decrease build times. After this has been run once, individual test projects may be built on their own to save time.

Any instructions related to using a specific library should be found within the README.md of that library.

> **NOTE:**
> All projects currently use `forc v0.60.0`, `fuels-rs v0.62.0` and `fuel-core v0.26.0`.

## Contributing

Check out the [contributing book](https://fuellabs.github.io/sway-libs/contributing-book/index.html) for more info!
