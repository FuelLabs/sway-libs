# Upgradability Library

The Upgradability Library provides functions that can be used to implement contract upgrades via simple upgradable proxies. The Upgradability Library implements the required and optional functionality from [SRC-14](https://docs.fuel.network/docs/sway-standards/src-14-simple-upgradeable-proxies/) as well as additional functionality for ownership of the proxy contract.

For implementation details on the Upgradability Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/upgradability/upgradability/).

## Importing the Upgradability Library

In order to use the Upgradability Library, the Upgradability Library and the [SRC-14](https://docs.fuel.network/docs/sway-standards/src-14-simple-upgradeable-proxies/) Standard must be added to your `Forc.toml` file and then imported into your Sway project.

To add the Upgradability Library and the [SRC-14](https://docs.fuel.network/docs/sway-standards/src-14-simple-upgradeable-proxies/) Standard as a dependency to your `Forc.toml` file in your project, use the `forc add` command.

```bash
forc add upgradability@0.26.0
forc add src14@0.8.0
```

> **NOTE:** Be sure to set the version to the latest release.

To import the Upgradability Library and  Standard to your Sway Smart Contract, add the following to your Sway file:

```sway
use upgradability::*;
use src14::*;
use src5::*;
```

## Integrating the Upgradability Library into the SRC-14 Standard

To implement the [SRC-14](https://docs.fuel.network/docs/sway-standards/src-14-simple-upgradeable-proxies/) standard with the Upgradability library, be sure to add the Sway Standards dependency to your contract. The following demonstrates the integration of the Ownership library with the SRC-14 standard.

```sway
use upgradability::{_proxy_owner, _proxy_target, _set_proxy_target};
use src14::{SRC14, SRC14Extension};
use src5::State;

storage {
    SRC14 {
        /// The [ContractId] of the target contract.
        ///
        /// # Additional Information
        ///
        /// `target` is stored at sha256("storage_SRC14_0")
        target in 0x7bb458adc1d118713319a5baa00a2d049dd64d2916477d2688d76970c898cd55: Option<ContractId> = None,
        /// The [State] of the proxy owner.
        ///
        /// # Additional Information
        ///
        /// `proxy_owner` is stored at sha256("storage_SRC14_1")
        proxy_owner in 0xbb79927b15d9259ea316f2ecb2297d6cc8851888a98278c0a2e03e1a091ea754: State = State::Uninitialized,
    },
}

impl SRC14 for Contract {
    #[storage(read, write)]
    fn set_proxy_target(new_target: ContractId) {
        _set_proxy_target(new_target);
    }

    #[storage(read)]
    fn proxy_target() -> Option<ContractId> {
        _proxy_target()
    }
}

impl SRC14Extension for Contract {
    #[storage(read)]
    fn proxy_owner() -> State {
        _proxy_owner()
    }
}
```

> **NOTE** An initialization method must be implemented to initialize the proxy target or proxy owner.

## Basic Functionality

### Setting and getting a Proxy Target

Once imported, the Upgradability Library's functions will be available. Use them to change the proxy target for your contract by calling the `set_proxy_target()` function.

```sway
#[storage(read, write)]
fn set_proxy_target(new_target: ContractId) {
    _set_proxy_target(new_target);
}
```

Use the `proxy_target()` method to get the current proxy target.

```sway
#[storage(read)]
fn proxy_target() -> Option<ContractId> {
    _proxy_target()
}
```

### Setting and getting a Proxy Owner

To change the proxy target for your contract use the `set_proxy_owner()` function.

```sway
#[storage(write)]
fn set_proxy_owner(new_proxy_owner: State) {
    _set_proxy_owner(new_proxy_owner);
}
```

Use the `proxy_owner()` method to get the current proxy owner.

```sway
#[storage(read)]
fn proxy_owner() -> State {
    _proxy_owner()
}
```

### Proxy access control

To restrict a function to only be callable by the proxy's owner, call the `only_proxy_owner()` function.

```sway
#[storage(read)]
fn only_proxy_owner_may_call() {
    only_proxy_owner();
    // Only the proxy's owner may reach this line.
}
```
