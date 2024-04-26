# Fixed Point Number Library

The Fixed Point Number Library provides a library to use fixed-point numbers in Sway. It has 3 distinct unsigned types: `UFP32`, `UFP64` and `UFP128` as well as 3 signed types `IFP64`, `IFP128` and `IFP256`. These types are stack allocated.

This type is stored as a `u32`, `u64` or `U128` under the hood. Therefore the size can be known at compile time and the length is static.

For implementation details on the Fixed Point Number Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/fixed_point/index.html).

## Importing the Fixed Point Number Library

In order to use the Fixed Point Number Library, Sway Libs must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../getting_started/index.md).

To import the Fixed Point Number Library to your Sway Smart Contract, add the following to your Sway file:

```sway
{{#include ../../../../examples/fixed_point/src/main.sw:import}}
```

## Supported Fixed Point Numbers

### Signed Fixed Point Numbers

We currently support the following signed Fixed Point numbers:

- `IFP64`
- `IFP128`
- `IFP256`

In order to use the `IFP64`, `IFP128` or `IFP256` types, import them into your Sway project like so:

```sway
{{#include ../../../../examples/fixed_point/src/main.sw:import_ifp}}
```

### Unsigned Fixed Point Numbers

We currently support the following unsigned Fixed Point numbers:

- `UFP32`
- `UFP64`
- `UFP128`

In order to use the `UFP32`, `UFP64` or `UFP128` types, import them into your Sway project like so:

```sway
{{#include ../../../../examples/fixed_point/src/main.sw:import_ufp}}
```

## Basic Functionality

### Instantiating a New Fixed Point Number

Once imported, any signed or unsigned Fixed Point number type can be instantiated by defining a new variable and calling the `from` function.

```sway
{{#include ../../../../examples/fixed_point/src/main.sw:instantiating_ufp}}
```

### Basic mathematical Functions

Basic arithmetic operations are working as usual.

```sway
{{#include ../../../../examples/fixed_point/src/main.sw:mathematical_ops}}
```

### Advanced mathematical Functions Supported

We currently support the following advanced mathematical functions:

#### Exponential

```sway
{{#include ../../../../examples/fixed_point/src/main.sw:exponential}}
```

#### Square Root

```sway
{{#include ../../../../examples/fixed_point/src/main.sw:square_root}}
```

#### Power

```sway
{{#include ../../../../examples/fixed_point/src/main.sw:power}}
```
