# Overview

This document provides an overview of the Reentrancy library.

It outlines the use cases and specification.

## Use Cases

The reentrancy check is used to check if a contract ID has been called more than
once.

A reentrancy, or "recursive call" attack
([example here](https://swcregistry.io/docs/SWC-107) can cause some functions to
behave in unexpected ways. This can be prevented by asserting a contract has not
yet been called in the current transaction.

## Public Functions

### `reentrancy_guard()`

Reverts if the current call is reentrant.

### `is_reentrant()`

Returns true if the current contract ID is found in any prior contract calls.
