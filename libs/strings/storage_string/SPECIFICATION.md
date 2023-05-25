# Overview

This document provides an overview of the StorageString library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

## Use Cases

The StorageString library can be used anytime a string's length is unknown at compile time and must be saved in storage. 

> **Note** To returned the `StorageString` from a contract you should use the `Bytes` type. For more information, please see the [known issues](./README.md#known-issues).

## Public Functions

### `write_slice()`

Stores a `String` in storage. 

### `read_slice()`

Retrieves a `String` from storage. 

### `len()`

Returns the length of the `String` stored in storage.

### `clear()`

Clears a stored `String` in storage.