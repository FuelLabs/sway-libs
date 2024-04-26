# Metadata Functionality

For implementation details on the Asset Library metadata functionality please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/asset/metadata/index.html).

## Importing the Asset Library Metadata Functionality

In order to use the Asset Library, Sway Libs and [Sway Standards](https://github.com/FuelLabs/sway-standards) must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../getting_started/index.md). To add Sway Standards as a dependency please see the [Sway Standards Book](https://github.com/FuelLabs/sway-standards).

To import the Asset Library Base Functionality and [SRC-7](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-7.md) Standard to your Sway Smart Contract, add the following to your Sway file:

```sway
{{#include ../../../../examples/asset/metadata_docs/src/main.sw:import}}
```

## Integration with the SRC-7 Standard

The [SRC-7](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-7.md) definition states that the following abi implementation is required for any Native Asset on Fuel:

```sway
{{#include ../../../../examples/asset/metadata_docs/src/main.sw:src7_abi}}
```

The Asset Library has the following complimentary data type for the [SRC-7](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-7.md) standard:

- `StorageMetadata`

The following additional functionality for the [SRC-7](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-7.md)'s `Metadata` type is provided:

- `as_string()`
- `is_string()`
- `as_u64()`
- `is_u64()`
- `as_bytes()`
- `is_bytes()`
- `as_b256()`
- `is_b256()`

## Setting Up Storage

Once imported, the Asset Library's metadata functionality should be available. To use them, be sure to add the storage block bellow to your contract which enables the [SRC-7](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-7.md) standard.

```sway
{{#include ../../../../examples/asset/metadata_docs/src/main.sw:src7_storage}}
```

## Using the `StorageMetadata` Type

### Setting Metadata

To set some metadata for an Asset, use the `SetAssetMetadata` ABI provided by the Asset Library. Be sure to follow the [SRC-9](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-9.md) standard for your `key`. It is recommended that the [Ownership Library](../ownership/index.md) is used in conjunction with the `SetAssetMetadata` ABI to ensure only a single user has permissions to set an Asset's metadata.

```sway
{{#include ../../../../examples/asset/setting_src7_attributes/src/main.sw:setting_src7_attributes}}
```

> **NOTE** The `_set_metadata()` function will set the metadata of an asset *unconditionally*. External checks should be applied to restrict the setting of metadata.

### Implementing the SRC-7 Standard with StorageMetadata

To use the `StorageMetadata` type, simply get the stored metadata with the associated `key` and `AssetId`. The example below shows the implementation of the [SRC-7](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-7.md) standard in combination with the Asset Library's `StorageMetadata` type with no user defined restrictions or custom functionality.

```sway
{{#include ../../../../examples/asset/basic_src7/src/main.sw:basic_src7}}
```

## Using the `Metadata` Extensions

The `Metadata` type defined by the [SRC-7](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-7.md) standard can be one of 4 states:

```sway
{{#include ../../../../examples/asset/metadata_docs/src/main.sw:metadata_enum}}
```

The Asset Library enables the following functionality for the `Metadata` type:

### `is_b256()` and `as_b256()`

The `is_b256()` check enables checking whether the `Metadata` type is a `b256`.
The `as_b256()` returns the `b256` of the `Metadata` type.

```sway
{{#include ../../../../examples/asset/metadata_docs/src/main.sw:as_b256}}
```

### `is_bytes()` and `as_bytes()`

The `is_bytes()` check enables checking whether the `Metadata` type is a `Bytes`.
The `as_bytes()` returns the `Bytes` of the `Metadata` type.

```sway
{{#include ../../../../examples/asset/metadata_docs/src/main.sw:as_bytes}}
```

### `is_u64()` and `as_u64()`

The `is_u64()` check enables checking whether the `Metadata` type is a `u64`.
The `as_u64()` returns the `u64` of the `Metadata` type.

```sway
{{#include ../../../../examples/asset/metadata_docs/src/main.sw:as_u64}}
```

### `is_string()` and `as_string()`

The `is_string()` check enables checking whether the `Metadata` type is a `String`.
The `as_string()` returns the `String` of the `Metadata` type.

```sway
{{#include ../../../../examples/asset/metadata_docs/src/main.sw:as_string}}
```
