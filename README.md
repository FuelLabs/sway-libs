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
    <a href="https://crates.io/crates/forc/0.49.1" alt="forc">
        <img src="https://img.shields.io/badge/forc-v0.49.1-orange" />
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

## Sway Libs Book

Please refer to the [Sway Libs Book](https://fuellabs.github.io/sway-libs/book/index.html) for documentation for a general overview on Sway Libs and how to implement libraries.

## Sway Docs

For implementation details on the libraries please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/).

## Libraries

#### Assets

- [Native Asset](https://fuellabs.github.io/sway-libs/book/documentation/libraries/asset/index.html) provides helper functions for the [SRC-20](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-20.md), [SRC-3](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-3.md), and [SRC-7](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-7.md) standards.

#### Access Control and Security

- [Ownership](https://fuellabs.github.io/sway-libs/book/documentation/libraries/ownership/index.html) is used to apply restrictions on functions such that only a **single** user may call them.
- [Admin](https://fuellabs.github.io/sway-libs/book/documentation/libraries/admin/index.html) is used to apply restrictions on functions such that only a select few users may call them like a whitelist.
- [Pausable](https://fuellabs.github.io/sway-libs/book/documentation/libraries/pausable/index.html) allows contracts to implement an emergency stop mechanism.
- [Reentrancy](https://fuellabs.github.io/sway-libs/book/documentation/libraries/reentrancy/index.html) is used to detect and prevent reentrancy attacks.

#### Cryptography

- [Bytecode](https://fuellabs.github.io/sway-libs/book/documentation/libraries/bytecode/index.html) is used for on-chain verification and computation of bytecode roots for contracts and predicates. 
- [Merkle Proof](https://fuellabs.github.io/sway-libs/book/documentation/libraries/merkle/index.html) is used to verify Binary Merkle Trees computed off-chain.

#### Math

- [Fixed Point Number](https://fuellabs.github.io/sway-libs/book/documentation/libraries/fixed_point/index.html) is an interface to implement fixed-point numbers.
- [Signed Integers](https://fuellabs.github.io/sway-libs/book/documentation/libraries/signed_integers/index.html) is an interface to implement signed integers.

#### Data Structures

- [Queue](https://fuellabs.github.io/sway-libs/book/documentation/libraries/queue/index.html) is a linear data structure that provides First-In-First-Out (FIFO) operations. 

## Using a library

To import a library, the following dependency should be added to the project's `Forc.toml` file under `[dependencies]`.

```rust
sway_libs = { git = "https://github.com/FuelLabs/sway-libs", tag = "v0.1.0" }
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

For more information about implementation please refer to the [Sway Libs Book](https://fuellabs.github.io/sway-libs/book/index.html)

## Running Tests

There are two sets of tests that should be run: inline tests and sdk-harness tests.

In order to run the inline tests, make sure you are in the `libs/` folder of this repository `sway-libs/libs/<you are here>`.

Run the tests:

```bash
forc test
```

Once these tests have passed, make sure you are in the `tests/` folder of this repository `sway-libs/tests/<you are here>`.

Run the tests:

```bash
forc test && cargo test
```

> **NOTE:**
> This may take a while depending on your hardware, future improvements to Sway will decrease build times. After this has been run once, individual test projects may be built on their own to save time.

Any instructions related to using a specific library should be found within the README.md of that library.

> **NOTE:**
> All projects currently use `forc v0.50.0`, `fuels-rs v0.53.0` and `fuel-core 0.22.0`.

## Contributing

Check out the [book](https://fuellabs.github.io/sway-libs/contributing-book/index.html) for more info!
