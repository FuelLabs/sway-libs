# Getting Started

## Adding Sway Libs as a Dependency

To import any library, a dependency should be added to the project's `Forc.toml` file under `[dependencies]`.

```sway
[dependencies]
example = "0.0.0"
```

The library you wish to use may be added as a dependency with the `forc add` command. For example, to import the Ownership Library, use the following `forc` command:

```bash
forc add ownership@0.26.0
```

> **NOTE:** Be sure to set the version to the latest release.

## Importing Sway Libs to Your Project

Once Sway Libs is a dependency to your project, you may then import a library in your Sway Smart Contract as so:

```sway
use <library>::<library_function>;
```

For example, to import the `only_owner()` from the Ownership Library, use the following statement at the top of your Sway file:

```sway
use ownership::only_owner;
```

> **NOTE:**
> All projects currently use `forc v0.69.0`, `fuels-rs v0.70.0` and `fuel-core v0.44.0`.

## Using Sway Libs

Once the library you require has been imported to your project, you may call or use any functions and structures the library provides.

In the following example, we import the Pausable Library and implement the `Pausable` ABI with it's associated functions.

```sway
use pausable::{_is_paused, _pause, _unpause, Pausable};

// Implement the Pausable ABI for our contract
impl Pausable for Contract {
    #[storage(write)]
    fn pause() {
        _pause(); // Call the provided pause function.
    }

    #[storage(write)]
    fn unpause() {
        _unpause(); // Call the provided unpause function.
    }

    #[storage(read)]
    fn is_paused() -> bool {
        _is_paused() // Call the provided is paused function.
    }
}
```

Any instructions related to using a specific library should be found within the [libraries](../index.md) section of the Sway Libs Book.

<!--
Uncomment this when https://github.com/FuelLabs/sway/pull/7229 is merged.
For implementation details on the libraries please see the [Sway Libs Docs]().
-->
