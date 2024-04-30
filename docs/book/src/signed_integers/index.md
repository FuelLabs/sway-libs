# Signed Integers Library

The Signed Integers library provides a library to use signed numbers in Sway. It has 6 distinct types: `I8`, `I16`, `I32`, `I64`, `I128`, `I256`. These types are stack allocated.

These types are stored as unsigned integers, therefore either `u64` or a number of them. Therefore the size can be known at compile time and the length is static.

For implementation details on the Signed Integers Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/signed_integers/index.html).

## Importing the Signed Integer Library

In order to use the Signed Integer Number Library, Sway Libs must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../getting_started/index.md).

To import the Signed Integer Number Library to your Sway Smart Contract, add the following to your Sway file:

```sway
{{#include ../../../../examples/signed_integers/src/main.sw:import}}
```

In order to use the any of the Signed Integer types, import them into your Sway project like so:

```sway
{{#include ../../../../examples/signed_integers/src/main.sw:import_8}}
```

## Basic Functionality

### Instantiating a New Fixed Point Number

Once imported, a `Signed Integer` type can be instantiated defining a new variable and calling the `new` function.

```sway
{{#include ../../../../examples/signed_integers/src/main.sw:initialize}}
```

### Basic Mathematical Functions

Basic arithmetic operations are working as usual.

```sway
{{#include ../../../../examples/signed_integers/src/main.sw:mathematical_ops}}
```

## Known Issues

The current implementation of `U128` will compile large bytecode sizes when performing mathematical computations. As a result, `I128` and `I256` inherit the same issue and could cause high transaction costs. This should be resolved with future optimizations of the Sway compiler.
