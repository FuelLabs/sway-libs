# Overview

This document provides an overview of the String library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

## Use Cases

The String library can be used anytime a string's length is unknown at compile time. Further methods can then be implemented to provide additional features building off of the `String` struct.

> **Note** There is no guarantee in the validity of the UTF-8 encoded `String` and should be used with caution. For more information, please see the [known issues](./README.md#known-issues).

## Public Functions

### `as_bytes()`

Convert the `String` struct to the `Bytes` type. 

### `as_vec()`

Convert the `String` struct to a `Vec` of `u8` bytes. 

### `capacity()`

Returns the total amount of memory on the heap allocated to the `String` which can be filled with bytes. 

> **Note** Capacity and length are not the same. A `String` may have a length of 0 but any positive capacity.

### `clear()`

Truncates the `String` to a length of 0 and will appear empty. This does not clear the capacity of the `String`.

### `from_bytes()`

A new instance of a `String` will be created from the `Bytes` type.

### `from_utf8()`

A new instance of a `String` will be created from a vector of `u8`'s.

### `insert()`

Inserts a new byte at the specified index in the `String`. 

### `is_empty()`

Returns a boolean indicating whether the length of the `String` is zero.

### `join()`

Joins two `String` instances into a single larger `String`.

### `len()`

Returns the total number of bytes in the `String`. 

### `new()`

Creates a new instance of the `String` struct.

### `nth()`

Returns the byte at the specified index in the `String`. If the index is out of bounds, `None` is returned.

### `pop()`

Removes the last byte in the `String` and returns it. If the `String` does not have any bytes, `None` is returned. 

### `push()`

Appends a byte to the end of the `String`.

### `set()`

Replaces a byte for another byte within the `String`.

### `split()`

Splits a single `String` into two `String`s at a given index.

### `swap()`

Swaps a byte at one index for a byte at another index within the existing `String`.

### `remove()`

Remove and return the specified byte in the `String`. 

### `with_capacity()`

Creates a new instance of the `String` struct with a specified amount of memory allocated on the heap.
