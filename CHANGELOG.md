# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Added

- [#318](https://github.com/FuelLabs/sway-libs/pull/318) Adds further documentation and examples for the `signed_integers` library.
- [#319](https://github.com/FuelLabs/sway-libs/pull/319) Adds further documentation and examples for the ownership library.

### Changed

### Fixed

### Breaking

## [Version 0.24.1]

### Added v0.24.1

- [#309](https://github.com/FuelLabs/sway-libs/pull/309) Adds fallback function test cases to the Reentrancy Guard Library.
- [#310](https://github.com/FuelLabs/sway-libs/pull/310) Adds proxy tests cases to the Reentrancy Guard Library.

### Changed v0.24.1

- [#305](https://github.com/FuelLabs/sway-libs/pull/305) Updates to forc `v0.66.2`, fuel-core `v0.40.0`, and fuels-rs `v0.66.9`.
- [#306](https://github.com/FuelLabs/sway-libs/pull/306) Updates the SRC-7 naming to Onchain Native Asset Metadata Standard.
- [#308](https://github.com/FuelLabs/sway-libs/pull/308) Removes comments on Cross-Contract Reentrancy vulnerability.
- [#314](https://github.com/FuelLabs/sway-libs/pull/314) Prepares for the v0.24.1 release.
- [#317](https://github.com/FuelLabs/sway-libs/pull/317) Updates the CI rust version to v1.83.0.

### Fixed v0.24.1

- [#297](https://github.com/FuelLabs/sway-libs/pull/297) Fixes docs anchor in basic SRC-7 example.
- [#298](https://github.com/FuelLabs/sway-libs/pull/298) Fixes the README headers on Upgradability Libraries from an `h2` to an `h4`.
- [#302](https://github.com/FuelLabs/sway-libs/pull/302) Fixes typos in documentation.
- [#303](https://github.com/FuelLabs/sway-libs/pull/304) Fixes links in the Upgradability Library documentation.
- [#311](https://github.com/FuelLabs/sway-libs/pull/311) Fixes links in README.

#### Breaking v0.24.1

- None

## [Version 0.24.0]

### Added v0.24.0

- [#293](https://github.com/FuelLabs/sway-libs/pull/293) Adds the `BytecodeRoot` and `ContractConfigurables` types to the Bytecode Library.
- [#286](https://github.com/FuelLabs/sway-libs/pull/286) Adds the `_metadata()` function to the Asset Library.

### Changed v0.24.0

- [#286](https://github.com/FuelLabs/sway-libs/pull/286) Updates the repository to Sway-Standards v0.6.0 and implements the new SRC-20 and SRC-7 logging specifications.
- [#286](https://github.com/FuelLabs/sway-libs/pull/286) `_set_metadata()`, `_set_name()` and `_set_symbol()` now revert if the metadata is an empty string.
- [#286](https://github.com/FuelLabs/sway-libs/pull/286) `_set_metadata()` now reverts if the metadata is empty bytes.
- [#286](https://github.com/FuelLabs/sway-libs/pull/286) `_mint()` and `_burn()` now revert if the `amount` argument is zero.
- [#289](https://github.com/FuelLabs/sway-libs/pull/289) Bumps Sway-Libs to forc `v0.63.3`, fuel-core `v0.34.0`, and fuels `v0.66.2`.
- [#290](https://github.com/FuelLabs/sway-libs/pull/290) Update the Upgradeability library to use a specific storage slot for owner functionality.
- [#291](https://github.com/FuelLabs/sway-libs/pull/291) Prepares for the `v0.24.0` release.

### Breaking v0.24.0

- [#290](https://github.com/FuelLabs/sway-libs/pull/290) The `_proxy_owner()`, `only_proxy_owner()` and `_set_proxy_owner()` functions no longer take `storage.proxy_owner` as a parameter. Instead they directly read and write to the storage slot `0xbb79927b15d9259ea316f2ecb2297d6cc8851888a98278c0a2e03e1a091ea754` which is `sha256("storage_SRC14_1")`.

Before:

```sway
fn foo() {
    let stored_proxy_owner = _proxy_owner(storage.proxy_owner);
    only_proxy_owner(storage.proxy_owner);
    _set_proxy_owner(new_proxy_owner, storage.proxy_owner);
}
```

After:

```sway
fn foo() {
    let stored_proxy_owner = _proxy_owner();
    only_proxy_owner();
    _set_proxy_owner(new_proxy_owner);
}
```

## [Version 0.23.1]

### Added v0.23.1

- None

### Changed v0.23.1

- [#281](https://github.com/FuelLabs/sway-libs/pull/281) Prepares for `v0.23.1` release.
- [#281](https://github.com/FuelLabs/sway-libs/pull/281) Updates repository to use sway-standards `v0.5.2`.

### Fixed v0.23.1

- None

### Breaking v0.23.1

- None

## [Version 0.23.0]

### Added v0.23.0

- [#259](https://github.com/FuelLabs/sway-libs/pull/259) Adds a new upgradability library, including associated tests and documentation.
- [#265](https://github.com/FuelLabs/sway-libs/pull/265) Adds the `SetMetadataEvent` and emits `SetMetadataEvent` when the `_set_metadata()` function is called.
- [#270](https://github.com/FuelLabs/sway-libs/pull/270) Adds `OrdEq` functionality to Signed Integers.
- [#272](https://github.com/FuelLabs/sway-libs/pull/272) Adds the `TryFrom` implementation from signed integers to unsigned integers.

### Changed v0.23.0

- [#265](https://github.com/FuelLabs/sway-libs/pull/265) Enables the metadata events now that the Rust SDK supports wrapped heap types.
- [#269](https://github.com/FuelLabs/sway-libs/pull/269) Hashes the string "admin" and with the bits of an Identity when creating a storage slot to storage an admin in the Admin Library.
- [#276](https://github.com/FuelLabs/sway-libs/pull/276) Prepares for v0.23.0 release.
- [#278](https://github.com/FuelLabs/sway-libs/pull/278) Deprecates the Fixed Point number library.

### Fixed v0.23.0

- [#258](https://github.com/FuelLabs/sway-libs/pull/258) Fixes incorrect instructions on how to run tests in README and docs hub.
- [#262](https://github.com/FuelLabs/sway-libs/pull/262) Fixes incorrect ordering comparison for IFP64, IFP128 and IFP256.
- [#263](https://github.com/FuelLabs/sway-libs/pull/263) Fixes `I256`'s returned bits.
- [#263](https://github.com/FuelLabs/sway-libs/pull/263) Fixes `I128` and `I256`'s zero or "indent" value.
- [#268](https://github.com/FuelLabs/sway-libs/pull/268) Fixes subtraction involving negative numbers for `I8`, `I16`, `I32`, `I64`, `I128`, and `I256`.
- [#272](https://github.com/FuelLabs/sway-libs/pull/272) Fixes `From` implementations for Signed Integers with `TryFrom`.
- [#273](https://github.com/FuelLabs/sway-libs/pull/273) Fixes negative from implementations for Signed Integers.
- [#274](https://github.com/FuelLabs/sway-libs/pull/274) Fixes the `swap_configurables()` function to correctly handle the case where the bytecode is too large to fit in the buffer.
- [#275](https://github.com/FuelLabs/sway-libs/pull/275) Fixes an infinite loop in the Bytecode root library's `_compute_bytecode_root()` function.

### Breaking v0.23.0

- [#263](https://github.com/FuelLabs/sway-libs/pull/263) Removes the `TwosComplement` trait in favor of `WrappingNeg`.

The following demonstrates the breaking change. While this example code uses the `I8` type, the same logic may be applied to the `I16`, `I32`, `I64`, `I128`, and `I256` types.

Before:

```sway
let my_i8 = i8::zero();
let twos_complement = my_i8.twos_complement();
```

After:

```sway
let my_i8 = i8::zero();
let wrapping_neg = my_i8.wrapping_neg();
```

- [#272](https://github.com/FuelLabs/sway-libs/pull/272) The `From` implementation for all signed integers to their respective unsigned integer has been removed. The `TryFrom` implementation has been added in its place.

Before:

```sway
let my_i8: I8 = I8::from(1u8);
```

After:

```sway
let my_i8: I8 = I8::try_from(1u8).unwrap();
```

- [#273](https://github.com/FuelLabs/sway-libs/pull/273) The `neg_from` implementation for all signed integers has been removed. The `neg_try_from()` implementation has been added in its place.

The following demonstrates the breaking change. While this example code uses the `I8` type, the same logic may be applied to the `I16`, `I32`, `I64`, `I128`, and `I256` types.

Before:

```sway
let my_negative_i8: I8 = I8::neg_from(1u8);
```

After:

```sway
let my_negative_i8: I8 = I8::neg_try_from(1u8).unwrap();
```

- [#278](https://github.com/FuelLabs/sway-libs/pull/278) Deprecates the Fixed Point number library. The Fixed Point number library is no longer available.
