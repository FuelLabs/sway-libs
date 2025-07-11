# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Added

- [#347](https://github.com/FuelLabs/sway-libs/pull/347) Adds examples on how to prevent ownership front-running.
- [#351](https://github.com/FuelLabs/sway-libs/pull/351) Adds CI job to run `forc publish` on version changes in the release branch.

### Changed

- [#348](https://github.com/FuelLabs/sway-libs/pull/348) Updates to forc `v0.68.5` and fuel-core `v0.43.2`.
- [#350](https://github.com/FuelLabs/sway-libs/pull/350) Updates documentation on adding libraries via `forc add`.
- [#352](https://github.com/FuelLabs/sway-libs/pull/352) Updates to forc `v0.69.0` and fuel-core `v0.44.0`.

### Fixed

- [#350](https://github.com/FuelLabs/sway-libs/pull/350) Fixes typos in inline documentation in the Asset Library.

### Breaking

- [#350](https://github.com/FuelLabs/sway-libs/pull/350) Refactors the repository such that each library is a separate project to be imported with `forc add`.

1. The dependencies in your `Forc.toml` file must be updated.

    Before:

    ```sway
    [dependencies]
    sway_libs = { git = "https://github.com/FuelLabs/sway-libs", tag = "v0.25.2" }
    ```

    After:

    ```sway
    [dependencies]
    admin = "0.26.0"
    ownership = "0.26.0"
    ```

2. The following imports have changed:

    Admin Library

    Before:

    ```sway
    use sway_libs::admin::*;
    ```

    After:

    ```sway
    use admin::*;
    ```

    Asset Library

    Before:

    ```sway
    use sway_libs::asset::*;
    ```

    After:

    ```sway
    use asset::*;
    ```

    Big Integers Library

    ```sway
    use sway_libs::bigint::*;
    ```

    After:

    ```sway
    use big_int::*;
    ```

    Bytecode Library

    Before:

    ```sway
    use sway_libs::bytecode::*;
    ```

    After:

    ```sway
    use bytecode::*;
    ```

    Merkle Library

    Before:

    ```sway
    use sway_libs::merkle::*;
    ```

    After:

    ```sway
    use merkle::*;
    ```

    Ownership Library

    Before:

    ```sway
    use sway_libs::ownership::*;
    ```

    After:

    ```sway
    use ownership::*;
    ```

    Pausable Library

    Before:

    ```sway
    use sway_libs::pausable::*;
    ```

    After:

    ```sway
    use pausable::*;
    ```

    Queue

    Before:

    ```sway
    use sway_libs::queue::*;
    ```

    After:

    ```sway
    use queue::*;
    ```

    Reentrancy Library

    Before:

    ```sway
    use sway_libs::reentrancy::*;
    ```

    After:

    ```sway
    use reentrancy::*;
    ```

    Signed Integers

    Before:

    ```sway
    use sway_libs::signed_integers::*;
    ```

    After:

    ```sway
    use signed_int::*;
    ```

    Upgradeability

    Before:

    ```sway
    use sway_libs::upgradeability::*;
    ```

    After:

    ```sway
    use upgradeability::*;
    ```

## [Version 0.25.2]

### Added v0.25.2

- None

### Changed v0.25.2

- [#343](https://github.com/FuelLabs/sway-libs/pull/343) Prepares for the `v0.25.2` release.

### Fixed v0.25.2

- [#341](https://github.com/FuelLabs/sway-libs/pull/341) Fixes anchors in examples for docs.
- [#342](https://github.com/FuelLabs/sway-libs/pull/342) Puts module comment on top of file since module comments after the file type are no longer allowed.

### Breaking v0.25.2

- None

## [Version 0.25.1]

### Added v0.25.1

- [#332](https://github.com/FuelLabs/sway-libs/pull/332) Adds additional arithmetic operation tests for signed integers.

### Changed v0.25.1

- [#332](https://github.com/FuelLabs/sway-libs/pull/332) Switches signed integer tests from SDK tests to inline tests.
- [#338](https://github.com/FuelLabs/sway-libs/pull/338) Updates the code owners from the SwayEx to the Onchain team.
- [#339](https://github.com/FuelLabs/sway-libs/pull/339) Prepares for the `v0.25.1` release.

### Fixed  v0.25.1

- [#332](https://github.com/FuelLabs/sway-libs/pull/332) Fixes signed integers to not revert when unsafe math and overflow is enabled.
- [#337](https://github.com/FuelLabs/sway-libs/pull/337) Fixes missing docs in the `BigUint` underlying type section.

### Breaking v0.25.1

- None

## [Version 0.25.0]

### Added v0.25.0

- [#312](https://github.com/FuelLabs/sway-libs/pull/312) Implements `TotalOrd` trait for `I8`, `I16`, `I32`, `I64`, `I128`, and `I256`.
- [#326](https://github.com/FuelLabs/sway-libs/pull/326) Introduces the Big Integers Library with the `BigUint` type.
- [#329](https://github.com/FuelLabs/sway-libs/pull/329) Introduce the Sparse Merkle Proof Library.
- [#333](https://github.com/FuelLabs/sway-libs/pull/333) Adds `BigInt` inline tests for expected behavior on overflow and unsafe math.

### Changed v0.25.0

- [#327](https://github.com/FuelLabs/sway-libs/pull/327) Updates the repository to forc `v0.66.7`, fuel-core `v0.41.4`, and fuels `v0.70.0`.
- [#334](https://github.com/FuelLabs/sway-libs/pull/334) Prepares for the `v0.25.0` release.

### Fixed v0.25.0

- None

### Breaking v0.25.0

- [#329](https://github.com/FuelLabs/sway-libs/pull/329) Breaks imports for the Binary Merkle Library.

Before:

```sway
use sway_libs::merkle::binary_poof::*;
```

After:

```sway
use sway_libs::merkle::binary::*;
```

- [#329](https://github.com/FuelLabs/sway-libs/pull/329) Breaks imports for the `LEAF`, `NODE`, `leaf_digest()`, and `node_disgest()` functions and constants.

Before:

```sway
use sway_libs::merkle::binary_proof::{LEAF, NODE, leaf_digest, node_digest};
```

After:

```sway
use sway_libs::merkle::common::{LEAF, NODE, node_digest};
use sway_libs::merkle::binary::{leaf_digest};
```

- [#330](https://github.com/FuelLabs/sway-libs/pull/330) Removes `_with_configurables()` functions from Bytecode Library in favor of using an `Option`.

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

- [#312](https://github.com/FuelLabs/sway-libs/pull/312) Breaks functionality of `I8`, `I16`, `I32`, `I64`, `I128`, and `I256`'s `::min()` and `::max()` functions. These functions are now used for comparison for two values of the type and return the higher or lower value respectively. To obtain the minimum and maximum values you must now use the `::MIN` and `::MAX` associated constants.

Before:

```sway
fn foo() -> I8 {
    let minimum_i8 = I8::min();
    let maximum_i8 = I8::max();
}
```

After:

```sway
fn foo() -> I8 {
    let minimum_i8 = I8::MIN;
    let maximum_i8 = I8::MAX;
}
```

- [#334](https://github.com/FuelLabs/sway-libs/pull/334) Updates to the forc `v0.67.0` release. Earlier versions are *not* compatible.

## [Version v0.24.2]

### Added v0.24.2

- [#318](https://github.com/FuelLabs/sway-libs/pull/318) Adds further documentation and examples for the `signed_integers` library.
- [#319](https://github.com/FuelLabs/sway-libs/pull/319) Adds further documentation and examples for the ownership library.
- [#322](https://github.com/FuelLabs/sway-libs/pull/320) Adds further documentation and examples for the asset metadata library.

### Changed v0.24.2

- [#323](https://github.com/FuelLabs/sway-libs/pull/323) Updates the repository to forc `v0.66.6`.
- [#324](https://github.com/FuelLabs/sway-libs/pull/324) Prepares for the `v0.24.2` release.

### Fixed v0.24.2

- None

### Breaking v0.24.2

- None

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
- [#303](https://github.com/FuelLabs/sway-libs/pull/304) Fixes links in the Upgradability Library documenation.
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
