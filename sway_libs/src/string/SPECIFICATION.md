# Overview

This document provides an overview of the String library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

# Use Cases

The String library can be used anytime a string's length is unknown at compile time and as such lives on the heap. Further methods can then be implemented to provide additional features building off of the `String` struct.

## Public Functions

### `as_bytes`

The `as_bytes` function is used to convert the `String` struct back to a `Vec` of `u8` bytes. 

### `capacity`

The `capacity` function will return the current amount of memory on the heap allocated to the `String`. 

> **Note** Capacity and length are not the same. A `String` may have a length of 0 but any arbitrary capacity.

### `clear`

The `clear` function will truncate the `String` to a length of 0. This does not clear the capacity of the `String`.

### `from_utf8`

The `from_utf8` function will return a `String` from a `Vec` of `u8` bytes.

### `insert`

The `insert` function will insert a new element at the specified index in the `String`. 

### `is_empty`

The `is_emtpy` function will return a `bool` as to whether there are elements in the `String`. This does not check the capacity of the `String`.

### `len`

The `len` function will return the length or number of elements in the `String`. This does not check the capacity of the `String`.

### `new`

The `new` function will construct an empty `String` struct.

### `nth`

The `nth` function will return the element at the specified index in the `String`. If the index is out of bounds, `None` is returned.

### `pop`

The `pop` function will both return the last element in the `String` and remove it. If the `String` does not have any elements, `None` is returned. This does not change it's capacity.

### `remove`

The `remove` function with both return and remove the specified element in the `String`. This does not change it's capacity.

### `with_capacity`

The `with_capacity` function will construct an empty `String` struct with a specified amount of memory allocated on the heap.
