# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Added

- [#285](https://github.com/FuelLabs/sway-libs/pull/285) Adds the `BytecodeRoot` and `ContractConfigurables` types to the Bytecode Library.
- [#286](https://github.com/FuelLabs/sway-libs/pull/286) Adds the `_metadata()` function to the Asset Library.

### Changed

- [#286](https://github.com/FuelLabs/sway-libs/pull/286) Updates the repository to Sway-Standards v0.6.0 and implements the new SRC-20 and SRC-7 logging specifications.
- [#286](https://github.com/FuelLabs/sway-libs/pull/286) `_set_metadata()`, `_set_name()` and `_set_symbol()` now revert if the metadata is an empty string.
- [#286](https://github.com/FuelLabs/sway-libs/pull/286) `_set_metadata()` now reverts if the metadata is empty bytes.
- [#286](https://github.com/FuelLabs/sway-libs/pull/286) `_mint()` and `_burn()` now revert if the `amount` argument is zero.

### Fixed

- Some fix here 1
- Some fix here 2

### Breaking

- [#285](https://github.com/FuelLabs/sway-libs/pull/285) Removes `_with_configurables()` functions from Bytecode Library in favor of using an `Option`.

The following demonstrates the breaking change.

Before:

```sway
// Compute bytecode root
let root_no_configurables: BytecodeRoot = compute_bytecode_root(my_bytecode);
let root_with_configurables: BytecodeRoot = compute_bytecode_root_with_configurables(my_bytecode, my_configurables);

// Compute predicate address
let address_no_configurables: Address = compute_predicate_address(my_bytecode);
let address_with_configurables: Address = compute_predicate_address_with_configurables(my_bytecode, my_configurables);

// Verify contract bytecode
verify_contract_bytecode(my_contract_id, my_bytecode); // No configurables
verify_contract_bytecode_with_configurables(my_contract_id, my_bytecode, my_configurables); // With configurables

// Verify predicate address
verify_predicate_address(my_predicate_address, my_bytecode); // No configurables
verify_predicate_address_with_configurables(my_predicate_address, my_bytecode, my_configurables); // With configurables
```

After:

```sway
// Compute bytecode root
let root_no_configurables: BytecodeRoot = compute_bytecode_root(my_bytecode, None);
let root_with_configurables: BytecodeRoot = compute_bytecode_root(my_bytecode, Some(my_configurables));

// Compute predicate address
let address_no_configurables: Address = compute_predicate_address(my_bytecode, None);
let address_with_configurables: Address = compute_predicate_address(my_bytecode, Some(my_configurables));

// Verify contract bytecode
verify_contract_bytecode(my_contract_id, my_bytecode, None); // No configurables
verify_contract_bytecode(my_contract_id, my_bytecode, Some(my_configurables)); // With configurables

// Verify predicate address
verify_predicate_address(my_predicate_address, my_bytecode, None); // No configurables
verify_predicate_address(my_predicate_address, my_bytecode, Some(my_configurables)); // With configurables
```

- [#286](https://github.com/FuelLabs/sway-libs/pull/286) The support functions for `Metadata` have been removed. They have been moved to sway-standards.

Before:

```sway
use sway_libs::asset::metadata::*;

fn foo(my_metadata: Metadata) {
     let res: bool = my_metadata.is_b256(); 
     let res: bool = my_metadata.is_string(); 
     let res: bool = my_metadata.is_bytes(); 
     let res: bool = my_metadata.is_uint();
}
```

After: 

```sway
use standards::src7::*;

fn foo(my_metadata: Metadata) {
     let res: bool = my_metadata.is_b256(); 
     let res: bool = my_metadata.is_string(); 
     let res: bool = my_metadata.is_bytes(); 
     let res: bool = my_metadata.is_uint();
}
```

- [#286](https://github.com/FuelLabs/sway-libs/pull/286) The `SetMetadata` abi `set_metadata` function definition has changed. The `metadata` argument is now an `Option<Metadata>` and the argument order has changed.

Before:

```sway
abi SetAssetMetadata {
    #[storage(read, write)]
    fn set_metadata(asset: AssetId, key: String, metadata: Metadata);
}
```

After:

```sway
abi SetAssetMetadata {
    #[storage(read, write)]
    fn set_metadata(asset: AssetId, metadata: Option<Metadata>, key: String);
}
```

- [#286](https://github.com/FuelLabs/sway-libs/pull/286) The `_set_name()`, `_set_symbol()`, `_mint()`, and `_set_metdata()` functions `name`, `symbol`, `sub_id`, and `metadata` arguments are now `Option`s.

Before: 

```sway
fn foo(asset: AssetId, recipient: Identity, amount: u64, key: String, metadata: Metadata) {
    _set_name(storage.name, asset, String::from_ascii_str("Ether"));
    _set_symbol(storage.symbol, asset, String::from_ascii_str("ETH"));
    _mint(storage.total_assets, storage.total_supply, recipient, SubId::zero(), amount);
    _set_metadata(storage.metadata, asset, key, metadata);
}
```

After: 

```sway
fn foo(asset: AssetId, recipient: Identity, amount: u64, metadata: Metadata, key: String) {
    _set_name(storage.name, asset, Some(String::from_ascii_str("Ether")));
    _set_symbol(storage.symbol, asset, Some(String::from_ascii_str("ETH")));
    _mint(storage.total_assets, storage.total_supply, recipient, Some(SubId::zero()), amount);
    // Note: Ordering of arguments has changed for `_set_metadata()`
    _set_metadata(storage.metadata, asset, Some(metadata), key);
}
```

## [v0.23.1]

### Added v0.23.1

- None

### Changed v0.23.1

- [#281](https://github.com/FuelLabs/sway-libs/pull/281) Prepares for `v0.23.1` release.
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
