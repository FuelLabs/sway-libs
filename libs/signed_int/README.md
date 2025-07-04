# Signed Integers Library

The Signed Integers library provides a library to use signed numbers in Sway. It has 6 distinct types: `I8`, `I16`, `I32`, `I64`, `I128`, `I256`. These types are stack allocated.

Internally the library uses the `u8`, `u16`, `u32`, `u64`, `U128`, `u256` types to represent the underlying values of the signed integers.

For implementation details on the Signed Integers Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/signed_int/signed_int/).

## Importing the Signed Integer Library

In order to use the Signed Integers Library, the Signed Integers Library must be added to your `Forc.toml` file and then imported into your Sway project.

To add the Signed Integers Library as a dependency to your `Forc.toml` file in your project, use the `forc add` command.

```bash
forc add signed_int@0.26.0
```

> **NOTE:** Be sure to set the version to the latest release.

To import the Signed Integers Library to your Sway Smart Contract, add the following to your Sway file:

```sway
use signed_int::*;
```

In order to use any of the Signed Integer types, import them into your Sway project like so:

```sway
use signed_int::i8::I8;
```

## Basic Functionality

All the functionality is demonstrated with the `I8` type, but all of the same functionality is available for the other types as well.

### Instantiating a Signed Integer

#### Zero value

Once imported, a `Signed Integer` type can be instantiated defining a new variable and calling the `new` function.

```sway
let mut i8_value = I8::new();
```

this newly initialized variable represents the value of `0`.

The `new` function is functionally equivalent to the `zero` function.

```sway
let zero = I8::zero();
```

#### Positive and Negative Values

As the signed variants can only represent half as high a number as the unsigned variants (but with either a positive or negative sign), the `try_from` and `neg_try_from` functions will only work with half of the maximum value of the unsigned variant.

You can use the `try_from` function to create a new positive `Signed Integer` from a its unsigned variant.

```sway
let one = I8::try_from(1u8).unwrap();
```

You can use the `neg_try_from` function to create a new negative `Signed Integer` from a its unsigned variant.

```sway
let negative_one = I8::neg_try_from(1u8).unwrap();
```

#### With underlying value

As mentioned previously, the signed integers are internally represented by an unsigned integer, with its values divided into two halves, the bottom half of the values represent the negative values and the top half represent the positive values, and the middle value represents zero.

Therefore, for the lowest value representable by a i8, `-128`, the underlying value would be `0`.

```sway
let neg_128 = I8::from_uint(0u8);
```

For the zero value, the underlying value would be `128`.

```sway
let zero = I8::from_uint(128u8);
```

And for the highest value representable by a i8, `127`, the underlying value would be `255`.

```sway
let pos_127 = I8::from_uint(255u8);
```

#### Minimum and Maximum Values

To get the minimum and maximum values of a signed integer, use the `min` and `max` functions.

```sway
let min = I8::MIN;
```

```sway
let max = I8::MAX;
```

### Basic Mathematical Functions

Basic arithmetic operations are working as usual.

```sway
fn add_signed_int(val1: I8, val2: I8) {
    let result: I8 = val1 + val2;
}

fn subtract_signed_int(val1: I8, val2: I8) {
    let result: I8 = val1 - val2;
}

fn multiply_signed_int(val1: I8, val2: I8) {
    let result: I8 = val1 * val2;
}

fn divide_signed_int(val1: I8, val2: I8) {
    let result: I8 = val1 / val2;
}
```

#### Checking if a Signed Integer is Zero

The library also provides a helper function to easily check if a `Signed Integer` is zero.

```sway
fn is_zero() {
    let i8 = I8::zero();
    assert(i8.is_zero());
}
```

## Known Issues

The current implementation of `U128` will compile large bytecode sizes when performing mathematical computations. As a result, `I128` and `I256` inherit the same issue and could cause high transaction costs. This should be resolved with future optimizations of the Sway compiler.
