# Overview

This document provides an overview of the Token library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

## Use Cases

The Token library can be used anytime a contract needs a basic implementation of the [SRC-20](https://github.com/FuelLabs/sway-standards/tree/master/standards/src_20) and [SRC-3](https://github.com/FuelLabs/sway-standards/tree/master/standards/src_3) standards.

## Public Functions

### SRC-20

#### `_total_assets()`

This function will return the total number of individual assets for a contract.

#### `_total_supply()`

This function will return the total supply of tokens for an asset.

#### `_name()`

This function will return the name of an asset, such as “Ether”.

#### `_symbol()`

This function will return the symbol of an asset, such as “ETH”.

#### `_decimals()`

This function will return the number of decimals an asset uses.

#### `_set_name()`

This function will unconditionally set the name of an asset.

#### `_set_symbol()`

This function will unconditionally set the symbol of an asset.

#### `_set_decimals`

This function will unconditionally set the decimals of an asset.

### SRC-3

#### `_mint()`

This function will unconditionally mint new tokens using a sub-identifier.

#### `_burn()`

This function will burns tokens with the given sub-identifier.

### SRC-7

#### `as_string()`

This function will return the metadata as a string.

#### `as_int()`

This function will return the metadata as an int.


#### `as_bytes()`

This function will return the metadata as bytes.

#### `is_string()`

This function will return whether the metadata is a string or not.

#### `is_int()`

This function will return the whether metadata is an int or not.


#### `is_bytes()`

This function will return the whether metadata are bytes or not.

