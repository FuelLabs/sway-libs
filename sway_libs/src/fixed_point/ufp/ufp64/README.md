# Overview

The Unsigned Fixed Point 64 bit library provides a library to use signed numbers in Sway. It has 1 distinct type: `UFP64`. This type is stack allocated.

This type is stored as a `u64` under the hood. Therefore the size can be known at compile time and the length is static. 

For more information please see the [specification](./SPECIFICATION.md).

# Using the Library

## Getting Started

In order to use the `UFP64` type it must be added to the Forc.toml file and then imported into your Sway project. To add Sway-libs as a dependency to the Forc.toml in your project, please see the [README.md](../../../../../README.md).

```rust
use sway_libs::ufp64::UFP64;
```

Once imported, a `UFP64` type can be instantiated defining a new variable and calling the `from` function.

```rust
let mut ufp64_value = UFP64::from(0);
```

## Basic Functionality

Basic arithmetic operations are working as usual

```rust
// Add 2 signed values
let ufp64_value_3 = ufp64_value_1 + ufp64_value_2;

// Subtract one signed value from another
let ufp64_value_3 = ufp64_value_1 - ufp64_value_2;
```

Mathematical functions

Exponential Function
```
let ten = UFP64::from_uint(10);
res = UFP64::exp(ten);
```

Square Root function
```
let ufp64_169 = UFP64::from_uint(169);
res = UFP64::sqrt(ufp64_169);
```

Power Function
```
let three = UFP64::from_uint(3);
let five = UFP64::from_uint(5);
res = five.pow(three);
```