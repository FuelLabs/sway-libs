# Supply Functionality

For implementation details on the Asset Library supply functionality please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/asset/supply/index.html).

## Importing the Asset Library Supply Functionality

In order to use the supply functionality of the Asset Library, the Asset Library and the [SRC-3](https://docs.fuel.network/docs/sway-standards/src-3-minting-and-burning/) Standard must be added to your `Forc.toml` file and then imported into your Sway project.

To add the Asset Library and the [SRC-3](https://docs.fuel.network/docs/sway-standards/src-3-minting-and-burning/) Standard as a dependency to your `Forc.toml` file in your project, use the `forc add` command.

```bash
forc add asset@0.8.0
forc add src3@0.8.0
```

> **NOTE:** Be sure to set the version to the latest release.

To import the Asset Library Supply Functionality and [SRC-3](https://docs.fuel.network/docs/sway-standards/src-3-minting-and-burning/) Standard to your Sway Smart Contract, add the following to your Sway file:

```sway
{{#include ../../../../examples/asset/supply_docs/src/main.sw:import}}
```

## Integration with the SRC-3 Standard

The [SRC-3](https://docs.fuel.network/docs/sway-standards/src-3-minting-and-burning/) definition states that the following abi implementation is required for any Native Asset on Fuel which mints and burns tokens:

```sway
{{#include ../../../../examples/asset/supply_docs/src/main.sw:src3_abi}}
```

The Asset Library has the following complimentary functions for each function in the `SRC3` abi:

- `_mint()`
- `_burn()`

> **NOTE** The `_mint()` and `_burn()` functions will mint and burn assets *unconditionally*. External checks should be applied to restrict the minting and burning of assets.

## Setting Up Storage

Once imported, the Asset Library's supply functionality should be available. To use them, be sure to add the storage block below to your contract which enables the [SRC-3](https://docs.fuel.network/docs/sway-standards/src-3-minting-and-burning/) standard.

```sway
{{#include ../../../../examples/asset/supply_docs/src/main.sw:src3_storage}}
```

## Implementing the SRC-3 Standard with the Asset Library

To use either function, simply pass the `StorageKey` from the prescribed storage block. The example below shows the implementation of the [SRC-3](https://docs.fuel.network/docs/sway-standards/src-3-minting-and-burning/) standard in combination with the Asset Library with no user defined restrictions or custom functionality. It is recommended that the [Ownership Library](../ownership/index.md) is used in conjunction with the Asset Library's supply functionality to ensure only a single user has permissions to mint an Asset.

The `_mint()` and `_burn()` functions follows the SRC-20 standard for logging and will emit the `TotalSupplyEvent` when called.

```sway
{{#include ../../../../examples/asset/basic_src3/src/main.sw:basic_src3}}
```

> **NOTE** The `_mint()` and `_burn()` functions will mint and burn assets *unconditionally*. External checks should be applied to restrict the minting and burning of assets.
