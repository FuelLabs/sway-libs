# Overview

This document provides an overview of the Bytecode Library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

## Use Cases

The Bytecode Library can be used anytime some contract or predicate bytecode must be verified, manipulated, or the bytecode root must be computed.

## Public Functions

### `compute_bytecode_root()`

Takes the bytecode of a contract or predicate and computes the bytecode root.

### `compute_bytecode_root_with_configurables()`

Takes the bytecode of a contract or predicate and configurables and computes the bytecode root.

### `compute_predicate_address()`

Takes the bytecode of a predicate and computes the address of a predicate.

### `compute_predicate_address_with_configurables()`

Takes the bytecode of a predicate and configurables and computes the address of a predicate.

### `predicate_address_from_root()`

Takes the bytecode root of predicate generates the address of a predicate.

### `swap_configurables()`

Swaps out configurable values in a contract or predicate's bytecode.

### `verify_contract_bytecode()`

Asserts that a contract's bytecode and the given bytecode match.

### `verify_contract_bytecode_with_configurables()`

Asserts that a contract's bytecode and the given bytecode and configurable values match.

### `verify_predicate_address()`

Asserts that a predicates's address from some bytecode and the given address match.

### `verify_predicate_address_with_configurables()`

Asserts that a predicates's address from some bytecode and configurables and the given address match.
