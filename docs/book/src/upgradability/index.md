# Upgradability Library

The Upgradability Library provides functions that can be used to implement contract upgrades via simple upgradable proxies. The Upgradability Library implements the required and optional functionality from [SRC-14](https://docs.fuel.network/docs/sway-standards/src-14-simple-upgradable-proxies/) as well as additional functionality for ownership of the proxy contract.

For implementation details on the Upgradability Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/upgradability/index.html).

## Importing the Upgradability Library

In order to use the Upgradability library, Sway Libs and [Sway Standards](https://docs.fuel.network/docs/sway-standards/) must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../getting_started/index.md). To add Sway Standards as a dependency please see the [Sway Standards Book](https://docs.fuel.network/docs/sway-standards/#using-a-standard).

To import the Upgradability Library and [SRC-14](https://docs.fuel.network/docs/sway-standards/src-14-simple-upgradeable-proxies/) Standard to your Sway Smart Contract, add the following to your Sway file:

```sway
{{#include ../../../../examples/upgradability/src/main.sw:import}}
```

## Integrating the Upgradability Library into the SRC-14 Standard

To implement the [SRC-14](https://docs.fuel.network/docs/sway-standards/src-14-simple-upgradeable-proxies/) standard with the Upgradability library, be sure to add the Sway Standards dependency to your contract. The following demonstrates the integration of the Ownership library with the SRC-14 standard.

```sway
{{#include ../../../../examples/upgradability/src/main.sw:integrate_with_src14}}
```

> **NOTE** An initialization method must be implemented to initialize the proxy target or proxy owner.

## Basic Functionality

### Setting and getting a Proxy Target

Once imported, the Upgradability Library's functions will be available. Use them to change the proxy target for your contract by calling the `set_proxy_target()` function.

```sway
{{#include ../../../../examples/upgradability/src/main.sw:set_proxy_target}}
```

Use the `proxy_target()` method to get the current proxy target.

```sway
{{#include ../../../../examples/upgradability/src/main.sw:proxy_target}}
```

### Setting and getting a Proxy Owner

To change the proxy target for your contract use the `set_proxy_owner()` function.

```sway
{{#include ../../../../examples/upgradability/src/main.sw:set_proxy_owner}}
```

Use the `proxy_owner()` method to get the current proxy owner.

```sway
{{#include ../../../../examples/upgradability/src/main.sw:proxy_owner}}
```

### Proxy access control

To restrict a function to only be callable by the proxy's owner, call the `only_proxy_owner()` function.

```sway
{{#include ../../../../examples/upgradability/src/main.sw:only_proxy_owner}}
```
