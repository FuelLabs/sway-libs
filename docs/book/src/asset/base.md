# Base Functionality

For implementation details on the Asset Library base functionality please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/asset/base/index.html).

## Importing the Asset Library Base Functionality

In order to use the Asset Library, Sway Libs and [Sway Standards](https://docs.fuel.network/docs/sway-standards/) must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../getting_started/index.md). To add Sway Standards as a dependency please see the [Sway Standards Book](https://docs.fuel.network/docs/sway-standards/#using-a-standard).

To import the Asset Library Base Functionality and [SRC-20](https://docs.fuel.network/docs/sway-standards/src-20-native-asset/) Standard to your Sway Smart Contract, add the following to your Sway file:

```sway
{{#include ../../../../examples/asset/base_docs/src/main.sw:import}}
```

## Integration with the SRC-20 Standard

The [SRC-20](https://docs.fuel.network/docs/sway-standards/src-20-native-asset/) definition states that the following abi implementation is required for any Native Asset on Fuel:

```sway
{{#include ../../../../examples/asset/base_docs/src/main.sw:src20_abi}}
```

The Asset Library has the following complimentary functions for each function in the `SRC20` abi:

- `_total_assets()`
- `_total_supply()`
- `_name()`
- `_symbol()`
- `_decimals()`

The following ABI and functions are also provided to set your [SRC-20](https://docs.fuel.network/docs/sway-standards/src-20-native-asset/) standard storage values:

```sway
{{#include ../../../../examples/asset/base_docs/src/main.sw:set_attributes}}
```

- `_set_name()`
- `_set_symbol()`
- `_set_decimals()`

> **NOTE** The `_set_name()`, `_set_symbol()`, and `_set_decimals()` functions will set the attributes of an asset *unconditionally*. External checks should be applied to restrict the setting of attributes.

## Setting Up Storage

Once imported, the Asset Library's base functionality should be available. To use them, be sure to add the storage block below to your contract which enables the [SRC-20](https://docs.fuel.network/docs/sway-standards/src-20-native-asset/) standard.

```sway
{{#include ../../../../examples/asset/base_docs/src/main.sw:src20_storage}}
```

## Implementing the SRC-20 Standard with the Asset Library

To use the Asset Library's base functionly, simply pass the `StorageKey` from the prescribed storage block. The example below shows the implementation of the [SRC-20](https://docs.fuel.network/docs/sway-standards/src-20-native-asset/) standard in combination with the Asset Library with no user defined restrictions or custom functionality.

```sway
{{#include ../../../../examples/asset/basic_src20/src/main.sw:basic_src20}}
```

## Setting an Asset's SRC-20 Attributes

To set some the asset attributes for an Asset, use the `SetAssetAttributes` ABI provided by the Asset Library. The example below shows the implementation of the `SetAssetAttributes` ABI with no user defined restrictions or custom functionality. It is recommended that the [Ownership Library](../ownership/index.md) is used in conjunction with the `SetAssetAttributes` ABI to ensure only a single user has permissions to set an Asset's attributes.

The `_set_name()`, `_set_symbol()`, and `_set_decimals()` functions follows the SRC-20 standard for logging and will emit their respective log when called.

```sway
{{#include ../../../../examples/asset/setting_src20_attributes/src/main.sw:setting_src20_attributes}}
```

> **NOTE** The `_set_name()`, `_set_symbol()`, and `_set_decimals()` functions will set the attributes of an asset *unconditionally*. External checks should be applied to restrict the setting of attributes.
