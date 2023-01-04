# Overview

The Reentrancy library provides an API to check for and disallow reentrancy on a contract.

More information can be found in the [specification](./SPECIFICATION.md).

## Known Issues

## Using the Library

### Using the Reentrancy Guard

Once imported, using the Reentrancy Library can be done by calling one of the two functions. For
more information, see the [specification](./SPECIFICATION.md).

- `is_reentrant() -> bool`
- `reentrancy_guard()`

The `reentrancy_guard` function asserts `is_reentrant()` returns false.
