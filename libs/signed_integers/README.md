# Overview

The Signed Integers library provides a library to use signed numbers in Sway. It has 6 distinct types: `I8`, `I16`, `I32`, `I64`, `I128`, `I256`. These types are stack allocated.

These types are stored as unsigned integers, therefore either `u64` or a number of them. Therefore the size can be known at compile time and the length is static. 

For more information please see the [specification](./SPECIFICATION.md).

# Using the Library

## Getting Started

In order to use the `Signed Integers` type it must be added to the Forc.toml file and then imported into your Sway project. To add Sway-libs as a dependency to the Forc.toml in your project, please see the [README.md](../../../README.md).

```rust
use signed_integers::i8::I8;
```

Once imported, a `Signed Integer` type can be instantiated defining a new variable and calling the `new` function.

```rust
let mut i8_value = I8::new();
```

## Basic Functionality

Basic arithmetic operations are working as usual

```rust
// Add 2 signed values
let i8_value_3 = i8_value_1 + i8_value_2;

// Subtract one signed value from another
let i8_value_3 = i8_value_1 - i8_value_2;
```

Helper functions

```rust
// To get a negative value from an unsigned value 
let neg_value = I8::neg_from();

// Maximum value
let max_i8_value = I8::max();
```

## Known Issues
The current implementation of `U128` and `U256` will compile large bytecode sizes when performing mathematical computations. As a result, `I128` and `I256` inherit the same issue and could cause high transaction costs. This should be resolved with future optimizations of the Sway compiler.