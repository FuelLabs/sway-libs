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

This function will store a new owner upon initalization.

### `state()`

This function will return the current state of ownership, whether it be initialized, uninitialized, or revoked.

### `transfer_ownership()`

Only callable by the current owner, this function will transfer ownership to another user.
