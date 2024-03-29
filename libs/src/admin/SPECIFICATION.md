# Overview

This document provides an overview of the Admin library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

## Use Cases

The Admin library can be used anytime a function should be restricted to **multiple** users.

## Public Functions

### `only_admin()`

This function will ensure that the current caller is an admin.

### `only_owner_or_admin()`

This function will ensure that the current caller is an admin or the contract's owner.

### `is_admin()`

Returns whether a user is an admin.

### `add_admin()`

Only callable by the current owner, this function will add a new admin.

### `revoke_admin()`

Only callable by the current owner, this function will remove an admin.
