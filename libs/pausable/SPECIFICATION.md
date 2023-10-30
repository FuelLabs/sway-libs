# Overview

This document provides an overview of the Pausable library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

## Use Cases

The Pausable library can be used anytime a contract needs a basic paused and unpased state, such as in the case of an emergency when a major bug is found.

## Public Functions

### `_pause()`

This function will unconditionally set the contract to the paused state.

### `_unpause()`

This function will unconditionally set the contract to the unpaused state.

### `_is_paused()`

This function will return whether the contract is in the paused state.

### `require_paused()`

This function will ensure the contract is in the paused state before continuing.

### `require_not_paused()`

This function will ensure the contract is in the unpaused state before continuing.
