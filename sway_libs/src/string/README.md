# Overview

The String library allows for developers to use valid UTF-8 encoded strings in Sway. This is differs from Sway's `str` as the size must not be known at compile time. `String` is heap allocated, growable, and not null terminated.

The `String` is stored as vector of bytes.

For more information please see the [specification](./SPECIFICATION.md).

> **Note** There is currently no way to convert a `str` to a `String`.

# Using the Library

## Using the String Library in Sway

Import `String` by adding the Sway-Libs to your Forc.toml and appending the following to your Sway file.

```rust
use sway_libs::string::String;
```

Once imported, using the String library is as simple as defining a new variable and calling the `new` function.

```rust
let mut string = ~String::new();
```

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
