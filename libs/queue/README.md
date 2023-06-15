# Overview

This document provides an overview of the Queue library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

## Use Cases

The Queue library can be used as a traditional queue or first in first out data structure.

## Public Functions

### `new()`

Creates a new instance of a `Queue`. 

### `is_empty()`

Returns a boolean indicating whether the length of the `Queue` is zero. 

### `len()`

Returns the number of elements in the `Queue`

### `enqueue()`

Adds the passed element to the `Queue`

### `dequeue()`

Removes an element to the `Queue`

### `peek()`

Returns the head of the `Queue`
