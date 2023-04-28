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

This function will store a new owner if there has never been one set.

### `transfer_ownership()`

Only callable by the current owner, this function will transfer ownership to another user.

### `uninitialized()`

Creates a new ownership in the `Uninitalized` state.

### `initalized()`

Creates a new ownership in the `Initalized` state.

### `revoked()`

Creates a new ownership in the `Revkoed` state.

> **Note** Once the ownership has been revoked it cannot be set or transfered again.
