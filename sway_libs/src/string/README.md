# Overview

The String library allows for developers to use valid UTF-8 encoded strings of dynamic length in Sway. The `String` is heap allocated, growable, and not null terminated.

The `String` is stored as vector of bytes. This differs from Sway's built in `str` as the size must not be known at compile time and is not static.

For more information please see the [specification](./SPECIFICATION.md).

> **Note** There is currently no way to convert a `str` to a `String`.

# Using the Library

## Getting Started

In order to use the `String` library it must be added to the Forc.toml file and then imported into your Sway project. To add Sway-libs as a dependency to the Forc.toml in your project, please see the [source README.md](./README.md).

```rust
use sway_libs::string::String;
```

Once imported, a `String` can be instantiated defining a new variable and calling the `new` function.

```rust
let mut string = ~String::new();
```

## Basic Functionality

Appending or adding to the `String` can be done by calling the `push` and `insert` functions.

```rust
string.push(0u8);
string.insert(0u8, 0);
```

Removing from the `String` can be done with either the `pop` or `remove` functions.

```rust
let last_element = string.pop().unwrap();
let nth_element = string.remove(0);
```

To retrieve an element in the `String`, use the `nth` function.

```rust
let nth_element = string.nth(0);
```

For more information please see the [specification](./SPECIFICATION.md).
