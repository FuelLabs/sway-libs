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

### Libraries

#### Assets

- [Token](./libs/token/) provides helper functions for the [SRC-20](https://github.com/FuelLabs/sway-standards/tree/master/standards/src_20), [SRC-3](https://github.com/FuelLabs/sway-standards/tree/master/standards/src_3), and [SRC-7](https://github.com/FuelLabs/sway-standards/tree/master/standards/src_7) standards.

#### Access Control and Security

- [Ownership](./libs/ownership/) is used to apply restrictions on functions such that only a **single** user may call them.
- [Admin](./libs/admin/) is used to apply restrictions on functions such that only a select few users may call them like a whitelist.
- [Pausable](./libs/pausable/) allows contracts to implement an emergency stop mechanism.
- [Reentrancy](./libs/reentrancy) is used to detect and prevent reentrancy attacks.

#### Cryptography

- [Merkle Proof](./libs/merkle_proof/) is used to verify Binary Merkle Trees computed off-chain.

#### Math

- [Fixed Point Number](./libs/fixed_point/) is an interface to implement fixed-point numbers.
- [Signed Integers](./libs/signed_integers/) is an interface to implement signed integers.

#### Data Structures

- [Queue](./libs/queue/) is a linear data structure that provides First-In-First-Out (FIFO) operations. 

## Using a library

To import a library, a dependency should be added to the project's `Forc.toml` file under `[dependencies]`. The following shows adding the Merkle Proof Library.

```rust
merkle_proof = { git = "https://github.com/FuelLabs/sway-libs", tag = "v0.1.0" }
```

> **NOTE:** 
> Be sure to set the tag to the latest release.

You may then import your desired library in your Sway Smart Contract as so:

```sway
use merkle_proof::<library_function>;
```

For example, to import the `verify_proof()` function use the following statement:

```sway
use merkle_proof::binary_merkle_proof::verify_proof;
```

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
> This may take a while depending on your hardware, future improvements to Sway will decrease build times. After this has been run once, indiviual test projects may be built on their own to save time.

Any instructions related to using a specific library should be found within the README.md of that library.

> **NOTE:**
> All projects currently use `forc v0.49.1`, `fuels-rs v0.53.0` and `fuel-core 0.22.0`.

## Contributing

Check out the [book](https://fuellabs.github.io/sway-libs/book/index.html) for more info!
