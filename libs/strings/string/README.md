<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".docs/string-logo-dark-theme.png">
        <img alt="SwayApps logo" width="400px" src=".docs/string-logo-light-theme.png">
    </picture>
</p>

# Overview

The String library provides an interface to use UTF-8 encoded strings of dynamic length in Sway. The `String` is heap allocated, growable, and not null terminated.

The `String` is stored as a collection of tightly packed bytes. This differs from Sway's built in `str` because the size cannot be known at compile time and the length is dynamic. 

For more information please see the [specification](./SPECIFICATION.md).

> **Note** There is no way to convert a `str` to a `String`.

## Known Issues

Until https://github.com/FuelLabs/sway/issues/4158 is resolved, developers must directly access the underlying `Bytes` type to make modifications to the `String` type.

It is important to note that unlike Rust's `String`, this `String` library does **not** guarantee a valid UTF-8 string. The `String` currently behaves only as a `vec` and does not perform any validation. This intended to be supported in the future with the introduction of [`char`](https://github.com/FuelLabs/sway/issues/2937) to the Sway language.

# Using the Library

## Getting Started

In order to use the `String` library it must be added to the Forc.toml file and then imported into your Sway project. To add Sway-libs as a dependency to the Forc.toml in your project, please see the [README.md](../../../README.md).

```rust
use string::String;
```

Once imported, a `String` can be instantiated defining a new variable and calling the `new` function.

```rust
let mut string = String::new();
```

## Basic Functionality

Appending or adding bytes to the `String` can be done by calling the `push` and `insert` functions.

```rust
// Append to the end
string.push(0u8);

// Insert at index 0
string.insert(0u8, 0);
```

Removing bytes from the `String` can be done with either the `pop` or `remove` functions.

```rust
// Remove the last byte from the string, return the option that wraps the value and unwrap the byte
let last_byte = string.pop().unwrap();

// Remove and return the byte at index 0
let nth_byte = string.remove(0);
```

To retrieve a byte in the `String`, use the `nth` function.

```rust
// Retrieve the byte at index 0
let nth_byte = string.nth(0);
```

For more information please see the [specification](./SPECIFICATION.md).
