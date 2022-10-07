# Overview

This document provides an overview of the String library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

## Use Cases

The String library can be used anytime a string's length is unknown at compile time and as such lives on the heap. Further methods can then be implemented to provide additional features building off of the `String` struct.

> **Note** There is no guarantee in the validity of the UTF-8 encoded `String` and should be used with caution. For more information, please see the [known issues](./README.md#known-issues).

## Public Functions

### `as_bytes()`

Used to convert the `String` struct to a `Vec` of `u8` bytes. 

### `capacity()`

Returns the total amount of memory on the heap allocated to the `String` which can be filled with bytes. 

> **Note** Capacity and length are not the same. A `String` may have a length of 0 but any arbitrary capacity.

### `clear()`

Truncates the `String` to a length of 0 and will appear empty. This does not clear the capacity of the `String`.

### `from_utf8()`

Given a vector of `u8`'s a new `String` instance will be returned.

### `insert()`

Inserts a new byte at the specified index in the `String`. 

### `is_empty()`

Returns a boolean indicating whether the length of the `String` is zero.

### `len()`

Returns the total number of bytes in the `String`. 

### `new()`

Creates a new instance of the `String` struct.

### `nth()`

Returns the byte at the specified index in the `String`. If the index is out of bounds, `None` is returned.

### `pop()`

Removes the last byte in the `String` and returns it. If the `String` does not have any bytes, `None` is returned. 

### `remove()`

Will both remove and return the specified byte in the `String`. 

### `with_capacity()`

Creates a new instance of the `String` struct with a specified amount of memory allocated on the heap.
