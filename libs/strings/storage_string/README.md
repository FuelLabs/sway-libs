<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".docs/storage-string-logo-dark-theme.png">
        <img alt="SwayApps logo" width="400px" src=".docs/storage-string-logo-light-theme.png">
    </picture>
</p>

# Overview

The StorageString library provides an interface to store UTF-8 encoded strings of dynamic length in Sway. The `StorageString` can be used in combination with the `String` type.

The `StorageString` stores the underlying data of the `String` type. This differs from Sway's built in `str` because the size cannot be known at compile time and the length is dynamic. 

For more information please see the [specification](./SPECIFICATION.md).

## Known Issues

Until https://github.com/FuelLabs/fuels-rs/issues/940 is resolved, developers must use the `Bytes` type to return a `String` from a contract.

# Using the Library

## Getting Started

In order to use the `StorageString` library it must be added to the Forc.toml file and then imported into your Sway project. To add Sway-libs as a dependency to the Forc.toml in your project, please see the [README.md](../../../README.md).

```rust
use storage_string::StorageString;
```

Once imported, a `StorageString` must be defined in a storage block.

```rust
storage {
    stored_string: StorageString = StorageString {},
}
```

## Basic Functionality

Storing a `String` type can be done by calling the `store` function.

```rust
// Create a new string
let mut my_string = String::new();
my_string.push(0u8);

// Store the string
storage.stored_string.write_slice(my_string);
```

Retrieving a `String` from storage can be done with the `load` function.

```rust
// Get a string from storage
let my_string: String = storage.stored_string.read_slice();
```

For more information please see the [specification](./SPECIFICATION.md).
