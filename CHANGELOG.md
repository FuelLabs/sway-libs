# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Added

- Something new here 1
- Something new here 2

### Changed

- Something changed here 1
- Something changed here 2

### Fixed

- Some fix here 1
- Some fix here 2

### Breaking

- Some breaking change here 1
- Some breaking change here 2

## [v0.23.1]

### Added v0.23.1

- None

### Changed v0.23.1

- [#281](https://github.com/FuelLabs/sway-libs/pull/281) Prepares for `v0.23.1` release.
- [#281](https://github.com/FuelLabs/sway-libs/pull/281) Updates repository to use forc `v0.62.0`.
- [#281](https://github.com/FuelLabs/sway-libs/pull/281) Updates repository to use fuel-core `v0.31.0`.
- [#281](https://github.com/FuelLabs/sway-libs/pull/281) Updates repository to use sway-standards `v0.5.2`.

### Fixed v0.23.1

- None

### Breaking v0.23.1

- None

## [v0.23.0]

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
