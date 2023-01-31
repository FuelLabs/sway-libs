# Overview

The Reentrancy library provides an API to check for and disallow reentrancy on a contract.

More information can be found in the [specification](./SPECIFICATION.md).

## Known Issues

While this can protect against both single-function reentrancy and cross-function reentrancy
attacks, it WILL NOT PREVENT a cross-contract reentrancy attack.

## Using the Library

### Using the Reentrancy Guard

Once imported, using the Reentrancy Library can be done by calling one of the two functions. For
more information, see the [specification](./SPECIFICATION.md).

- `is_reentrant() -> bool`
- `reentrancy_guard()`

The `reentrancy_guard` function asserts `is_reentrant()` returns false.

## Example

```rust
use reentrancy::reentrancy_guard;

abi MyContract {
    fn my_non_reentrant_function();
}

impl MyContract for Contract {
    fn my_non_reentrant_function() {
        reentrancy_guard();

        // my code here
    }
}
```
