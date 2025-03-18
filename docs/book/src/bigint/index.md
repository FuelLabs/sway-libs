# Big Integers Library

<!--Include BigInt when BigInt is available-->
The Big Integers library provides a library to use extremely large numbers in Sway. It has 1 distinct types: `BigUint`. These types are heap allocated.

Internally the library uses the `Vec<u64>` type to represent the underlying values of the big integers.

For implementation details on the Big Integers Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/bigint/index.html).

## Importing the Big Integers Library

In order to use the Big Integer Number Library, Sway Libs must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../getting_started/index.md).

To import the Big Integer Number Library to your Sway Smart Contract, add the following to your Sway file:

```sway
{{#include ../../../../examples/big_integers/src/main.sw:import}}
```

In order to use any of the Big Integer types, import them into your Sway project like so:

```sway
{{#include ../../../../examples/big_integers/src/main.sw:import_big_uint}}
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
{{#include ../../../../examples/big_integers/src/main.sw:initialize}}
```

this newly initialized variable represents the value of `0`.

The `new` function is functionally equivalent to the `zero` function.

```sway
{{#include ../../../../examples/big_integers/src/main.sw:zero}}
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
{{#include ../../../../examples/big_integers/src/main.sw:mathematical_ops}}
```

#### Checking if a Big Integer is Zero

The library also provides a helper function to easily check if a `Big Integer` is zero.

```sway
{{#include ../../../../examples/big_integers/src/main.sw:is_zero}}
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
{{#include ../../../../examples/big_integers/src/main.sw:from}}
```

To convert back to any of the above types, the `TryInto` implementation will be needed. If the Bit Integer does not fit into the conversion type, `None` will be returned.

```sway
{{#include ../../../../examples/big_integers/src/main.sw:try_into}}
```

The only exception is the `Bytes` type, which uses `Into`.

```sway
{{#include ../../../../examples/big_integers/src/main.sw:into}}
```

### Underlying Values

As mentioned previously, the big integers are internally represented by a `Vec<u64>`. To introspect these underlying values you may either get a copy of the data, inspect individual elements, or get the length.

To get a copy of the underlying data, you may call the `limbs()` function. Please note that modifying the copy will have no impact on the Big Integer.

```sway
{{#include ../../../../examples/big_integers/src/main.sw:limbs}}
```

To introspect an individual element, you may use the `get_limb()` function.

```sway
{{#include ../../../../examples/big_integers/src/main.sw:get_limb}}
```

To get the length of the underlying `Vec<u64>`, call the `number_of_limbs()` function.

```sway
{{#include ../../../../examples/big_integers/src/main.sw:number_of_limbs}}
```

And to check whether two Big Integers have the same number of limbs, you may use the `equal_limb_size()` function.

```sway
{{#include ../../../../examples/big_integers/src/main.sw:equal_limb_size}}
```
