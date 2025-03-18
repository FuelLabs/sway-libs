# Getting Started

## Adding Sway Libs as a Dependency

To import any library, the following dependency should be added to the project's `Forc.toml` file under `[dependencies]`.

```sway
sway_libs = { git = "https://github.com/FuelLabs/sway-libs", tag = "v0.25.0" }
```

For reference, here is a complete `Forc.toml` file:

```sway
[project]
authors = ["Fuel Labs <contact@fuel.sh>"]
entry = "main.sw"
license = "Apache-2.0"
name = "MyProject"

[dependencies]
sway_libs = { git = "https://github.com/FuelLabs/sway-libs", tag = "v0.25.0" }
```

> **NOTE:** Be sure to set the tag to the latest release.

## Importing Sway Libs to Your Project

Once Sway Libs is a dependency to your project, you may then import a library in your Sway Smart Contract as so:

```sway
use sway_libs::<library>::<library_function>;
```

For example, to import the `only_owner()` from the Ownership Library, use the following statement at the top of your Sway file:

```sway
use sway_libs::ownership::only_owner;
```

> **NOTE:**
> All projects currently use `forc 0.67.0`, `fuels-rs v0.70.0` and `fuel-core 0.41.4`.

## Using Sway Libs

Once the library you require has been imported to your project, you may call or use any functions and structures the library provides.

In the following example, we import the Pausable Library and implement the `Pausable` ABI with it's associated functions.

```sway
use sway_libs::pausable::{_is_paused, _pause, _unpause, Pausable};

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

For implementation details on the libraries please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/).
