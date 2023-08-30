# Overview

This document provides an overview of the Token library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

## Use Cases

The Token library can be used anytime a contract needs a basic implementation of the SRC-20 and SRC-3 standards.

## Public Functions

### `_total_assets()`

This function will return the total number of individual assets for a contract.

### `_total_supply()`

This function will return the total supply of tokens for an asset.

### `_name()`

This function will return the name of an asset, such as “Ether”.

### `_symbol()`

This function will return the symbol of an asset, such as “ETH”.

### `_decimals()`

This function will return the number of decimals an asset uses.

### `_mint()`

This function will unconditionally mint new tokens using a sub-identifier.

### `_burn()`

This function will burns tokens with the given sub-identifier.

### `set_name()`

This function will unconditionally sets the name of an asset.

### `set_symbol()`

This function will unconditionally sets the symbol of an asset.

### `set_decimals`

This function will unconditionally sets the decimals of an asset.
