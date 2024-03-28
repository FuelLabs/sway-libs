# Fixed Point Number Library

The Fixed Point Number Library provides a library to use fixed-point numbers in Sway. It has 3 distinct unsigned types: `UFP32`, `UFP64` and `UFP128` as well as 3 signed types `IFP64`, `IFP128` and `IFP256`. These types are stack allocated.

This type is stored as a `u32`, `u64` or `U128` under the hood. Therefore the size can be known at compile time and the length is static. 

For more information please see the [specification](../../../../../../../libs/fixed_point/SPECIFICATION.md).

# Using the Library

## Importing the Fixed Point Number Library

In order to use the Fixed Point Number Library, Sway Libs must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../../../getting_started/index.md).

To import the Fixed Point Number Library to your Sway Smart Contract, add the following to your Sway file:

```sway
use sway_libs::fixed_point::*;
```

## Supported Fixed Point Numbers

### Signed Fixed Point Numbers

We currently support the following signed Fixed Point numbers:

- `IFP64`
- `IFP128`
- `IFP256`

In order to use the `IFP64`, `IFP128` or `IFP256` types, import them into your Sway project like so:

```sway
use sway_libs::fixed_point::{
    ifp64::IFP64,
    ifp128::IFP128,
    ifp256::IFP256,
};
```

### Unsigned Fixed Point Numbers

We currently support the following unsigned Fixed Point numbers:

- `UFP32`
- `UFP64`
- `UFP128`

In order to use the `UFP32`, `UFP64` or `UFP128` types, import them into your Sway project like so:

```sway
use sway_libs::fixed_point::{
    ufp32::UFP32,
    ufp64::UFP64,
    ufp128::UFP128,
};
```

## Basic Functionality

### Instantiating a New Fixed Point Number

Once imported, any signed or unsigned Fixed Point number type can be instantiated by defining a new variable and calling the `from` function.

```sway
let mut ufp32_value = UFP32::from(0);
let mut ufp64_value = UFP64::from(0);
let mut ufp128_value = UFP128::from(0);
```

### Basic Mathematical Functions

Basic arithmetic operations are working as usual.

```sway
fn add_ufp(val1: UFP64, val2: UFP64) {
    let result: UFP64 = val1 + val2;
}

fn subtract_ufp(val1: UFP64, val2: UFP64) {
    let result: UFP64 = val1 - val2;
}

fn multiply_ufp(val1: UFP64, val2: UFP64) {
    let result: UFP64 = val1 * val2;
}

fn divide_ufp(val1: UFP64, val2: UFP64) {
    let result: UFP64 = val1 / val2;
}
```

### Advanced Mathematical Functions Supported

We currently support the following advanced mathematical functions:

#### Exponential 

```sway
let ten = UFP64::from_uint(10);
let res = UFP64::exp(ten);
```

#### Square Root

```sway
let ufp64_169 = UFP64::from_uint(169);
let res = UFP64::sqrt(ufp64_169);
```

#### Power

```sway
let three = UFP64::from_uint(3);
let five = UFP64::from_uint(5);
let res = five.pow(three);
```