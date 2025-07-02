# Big Integers Library

<!--Include BigInt when BigInt is available-->
The Big Integers library provides a library to use extremely large numbers in Sway. It has 1 distinct types: `BigUint`. These types are heap allocated.

Internally the library uses the `Vec<u64>` type to represent the underlying values of the big integers.

For implementation details on the Big Integers Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/big_int/big_int/).

## Importing the Big Integers Library

In order to use the Big Integers Library, the Big Integers Library must be added to your `Forc.toml` file and then imported into your Sway project.

To add the Big Integers Library as a dependency to your `Forc.toml` file in your project, use the `forc add` command.

```bash
forc add big_int@0.26.0
```

> **NOTE:** Be sure to set the version to the latest release.

To import the Big Integers Library to your Sway Smart Contract, add the following to your Sway file:

```sway
use big_int::*;
```

In order to use any of the Big Integer types, import them into your Sway project like so:

```sway
use big_int::BigUint;
```

## Basic Functionality

<!--Uncomment when BigInt is available-->
<!--All the functionality is demonstrated with the `BigUint` type, but all of the same functionality is available for the other types as well.-->

### Minimum and Maximum Values

For the `BigUint` type, the minimum value is zero. There is no maximum value and the `BigUint` will grow to accommodate as large of a number as needed.

### Instantiating a Big Integer

#### Zero value

Once imported, a `Big Integer` type can be instantiated defining a new variable and calling the `new` function.

```sway
let mut big_int = BigUint::new();
```

this newly initialized variable represents the value of `0`.

The `new` function is functionally equivalent to the `zero` function.

```sway
let zero = BigUint::zero();
```

<!--#### Positive and Negative Values

As the signed variants can only represent half as high a number as the unsigned variants (but with either a positive or negative sign), the `try_from` and `neg_try_from` functions will only work with half of the maximum value of the unsigned variant.

You can use the `try_from` function to create a new positive `Big Integer` from a its unsigned variant.

```sway
{{#include ../../../../examples/big_integers/src/main.sw:positive_conversion}}
```

You can use the `neg_try_from` function to create a new negative `Big Integer` from a its unsigned variant.

```sway
{{#include ../../../../examples/big_integers/src/main.sw:negative_conversion}}
```
-->

### Basic Mathematical Functions

Basic arithmetic operations are working as usual.

```sway
let big_uint_1 = BigUint::from(1u64);
let big_uint_2 = BigUint::from(2u64);

// Add
let result: BigUint = big_uint_1 + big_uint_2;

// Multiply
let result: BigUint = big_uint_1 * big_uint_2;

// Subtract
let result: BigUint = big_uint_2 - big_uint_1;

// Eq
let result: bool = big_uint_1 == big_uint_2;

// Ord
let result: bool = big_uint_1 < big_uint_2;
```

#### Checking if a Big Integer is Zero

The library also provides a helper function to easily check if a `Big Integer` is zero.

```sway
fn is_zero() {
    let big_int = BigUint::zero();
    assert(big_int.is_zero());
}
```

### Type Conversions

The Big Integers Library offers a number of different conversions between mathematical types. These include the following:

- `u8`
- `u16`
- `u32`
- `u64`
- `U128`
- `u256`
- `Bytes`

To convert any of the above type to a Big Integer, you may use the `From` implementation.

```sway
// u8
let u8_big_int = BigUint::from(u8::max());

// u16
let u16_big_int = BigUint::from(u16::max());

// u32
let u32_big_int = BigUint::from(u32::max());

// u64
let u64_big_int = BigUint::from(u64::max());

// U128
let u128_big_int = BigUint::from(U128::max());

// u256
let u256_big_int = BigUint::from(u256::max());

// Bytes
let bytes_big_int = BigUint::from(Bytes::new());
```

To convert back to any of the above types, the `TryInto` implementation will be needed. If the Bit Integer does not fit into the conversion type, `None` will be returned.

```sway
let big_uint = BigUint::zero();

// u8
let u8_result: Option<u8> = <BigUint as TryInto<u8>>::try_into(big_uint);

// u16
let u16_result: Option<u16> = <BigUint as TryInto<u16>>::try_into(big_uint);

// u32
let u32_result: Option<u32> = <BigUint as TryInto<u32>>::try_into(big_uint);

// u64
let u64_result: Option<u64> = <BigUint as TryInto<u64>>::try_into(big_uint);

// U128
let u128_big_int: Option<U128> = <BigUint as TryInto<U128>>::try_into(big_uint);

// u256
let u256_big_int: Option<u256> = <BigUint as TryInto<u256>>::try_into(big_uint);
```

The only exception is the `Bytes` type, which uses `Into`.

```sway
// Bytes
let bytes_big_int: Bytes = <BigUint as Into<Bytes>>::into(big_uint);
```

### Underlying Values

As mentioned previously, the big integers are internally represented by a `Vec<u64>`. To introspect these underlying values you may either get a copy of the data, inspect individual elements, or get the length.

To get a copy of the underlying data, you may call the `limbs()` function. Please note that modifying the copy will have no impact on the Big Integer.

```sway
let limbs: Vec<u64> = big_int.limbs();
```

To introspect an individual element, you may use the `get_limb()` function.

```sway
let limb: Option<u64> = big_int.get_limb(0);
```

To get the length of the underlying `Vec<u64>`, call the `number_of_limbs()` function.

```sway
let number_of_limbs: u64 = big_int.number_of_limbs();
```

And to check whether two Big Integers have the same number of limbs, you may use the `equal_limb_size()` function.

```sway
let result: bool = big_int_1.equal_limb_size(big_int_2);
```
