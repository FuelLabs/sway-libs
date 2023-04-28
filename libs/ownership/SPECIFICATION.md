# Overview

This document provides an overview of the Ownership library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

## Use Cases

The Ownership library can be used anytime a function should be restricted to a single user.

## Public Functions

### `only_owner()`

This function will ensure that the current caller is the owner.

### `owner()`

Returns the owner stored in storage.

### `renounce_ownership()`

Only callable by the current owner, this function will remove the owner.

### `set_ownership()`

This function will store a new owner if one has not been set.

### `transfer_ownership()`

Only callable by the current owner, this function will transfer ownership to another user.

### `uninitialized()`

Creates a new ownership in the `Uninitialized` state.

### `initialized()`

Creates a new ownership in the `Initialized` state.

### `revoked()`

Creates a new ownership in the `Revoked` state.

> **Note** Once the ownership has been revoked it cannot be set or transferred again.
