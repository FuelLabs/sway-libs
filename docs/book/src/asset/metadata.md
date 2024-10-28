# Metadata Functionality

For implementation details on the Asset Library metadata functionality please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/asset/metadata/index.html).

## Importing the Asset Library Metadata Functionality

In order to use the Asset Library, Sway Libs and [Sway Standards](https://docs.fuel.network/docs/sway-standards/) must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../getting_started/index.md). To add Sway Standards as a dependency please see the [Sway Standards Book](https://docs.fuel.network/docs/sway-standards/#using-a-standard).

To import the Asset Library Base Functionality and [SRC-7](https://docs.fuel.network/docs/sway-standards/src-7-asset-metadata/) Standard to your Sway Smart Contract, add the following to your Sway file:

```sway
{{#include ../../../../examples/asset/metadata_docs/src/main.sw:import}}
```

## Integration with the SRC-7 Standard

The [SRC-7](https://docs.fuel.network/docs/sway-standards/src-7-asset-metadata/) definition states that the following abi implementation is required for any Native Asset on Fuel:

```sway
{{#include ../../../../examples/asset/metadata_docs/src/main.sw:src7_abi}}
```

The Asset Library has the following complimentary data type for the [SRC-7](https://docs.fuel.network/docs/sway-standards/src-7-asset-metadata/) standard:

- `StorageMetadata`

## Setting Up Storage

Once imported, the Asset Library's metadata functionality should be available. To use them, be sure to add the storage block below to your contract which enables the [SRC-7](https://docs.fuel.network/docs/sway-standards/src-7-asset-metadata/) standard.

```sway
{{#include ../../../../examples/asset/metadata_docs/src/main.sw:src7_storage}}
```

## Using the `StorageMetadata` Type

### Setting Metadata

To set some metadata for an Asset, use the `SetAssetMetadata` ABI provided by the Asset Library with the `_set_metadata()` function. Be sure to follow the [SRC-9](https://docs.fuel.network/docs/sway-standards/src-9-metadata-keys/) standard for your `key`. It is recommended that the [Ownership Library](../ownership/index.md) is used in conjunction with the `SetAssetMetadata` ABI to ensure only a single user has permissions to set an Asset's metadata.

The `_set_metadata()` function follows the SRC-7 standard for logging and will emit the `SetMetadataEvent` when called.

```sway
{{#include ../../../../examples/asset/setting_src7_attributes/src/main.sw:setting_src7_attributes}}
```

> **NOTE** The `_set_metadata()` function will set the metadata of an asset *unconditionally*. External checks should be applied to restrict the setting of metadata.

### Implementing the SRC-7 Standard with StorageMetadata

To use the `StorageMetadata` type, simply get the stored metadata with the associated `key` and `AssetId` using the provided `_metadata()` convenience function. The example below shows the implementation of the [SRC-7](https://docs.fuel.network/docs/sway-standards/src-7-asset-metadata/) standard in combination with the Asset Library's `StorageMetadata` type and the `_metadata()` function with no user defined restrictions or custom functionality.

```sway
{{#include ../../../../examples/asset/basic_src7/src/main.sw:basic_src7}}
```
