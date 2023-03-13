<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".docs/fixedpoint-logo-dark-theme.png">
        <img alt="SwayApps logo" width="400px" src=".docs/fixedpoint-logo-light-theme.png">
    </picture>
</p>

# Overview

The Fixed Point Number library provides a library to use fixed-point numbers in Sway. It has 3 distinct unsigned types: `UFP32`, `UFP64` and `UFP128` as well as 1 signed type - `IFP128`. This type is stack allocated.

This type is stored as a `u32`, `u64` or `U128` under the hood. Therefore the size can be known at compile time and the length is static. 

For more information please see the [specification](./SPECIFICATION.md).

# Using the Library

## Getting Started

First, add the `fixed_point` library as a dependency in your Forc.toml like so:

```toml
fixed_point = { git = "https://github.com/fuellabs/sway-libs", branch = "master" }
```

In order to use the `UFP32`, `UFP64` or `UFP128` types, import them into your Sway project like so.

```rust
use fixed_point::ufp32::UFP32;
use fixed_point::ufp64::UFP64;
use fixed_point::ufp128::UFP128;
```

Once imported, a `UFP64` or `UFP128` type can be instantiated by defining a new variable and calling the `from` function.

```rust
let mut ufp32_value = UFP32::from(0);
let mut ufp64_value = UFP64::from(0);
let mut ufp128_value = UFP128::from(0);
```

## Basic Functionality

Basic arithmetic operations are working as usual

```rust
// Add 2 signed values
let ufp_value_3 = ufp_value_1 + ufp_value_2;

// Subtract one signed value from another
let ufp_value_3 = ufp_value_1 - ufp_value_2;
```

Mathematical functions

Exponential Function
```rust
let ten = UFP64::from_uint(10);
let res = UFP64::exp(ten);
```

Square Root function
```rust
let ufp64_169 = UFP64::from_uint(169);
let res = UFP64::sqrt(ufp64_169);
```

Power Function
```rust
let three = UFP64::from_uint(3);
let five = UFP64::from_uint(5);
let res = five.pow(three);
```