# Overview

This document provides an overview of the Queue library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

### Traits of the `Queue`

- The `Queue<T>` is a linear structure with a generic type parameter `T`.
- The elements in the queue are stored as a `Vec<T>`.
- Queues are growable, operate in a First-In-First-Out (FIFO) manner, and are created empty.

## Use Cases

The Queue library can be used as a data structure to retrieve items in the order that they were introduced. This is useful for preserving the chronological order of events such as server requests, scheduling tasks, or traversing Binary Search Trees (BST).

## Public Functions

### `new()`

- Creates a new instance of a `Queue`. 

### `is_empty()`

- Returns a boolean indicating whether the length of the `Queue` is zero. 

### `len()`

- Returns the number of elements in the `Queue`

### `enqueue()`

- Adds an item into the `Queue`

### `dequeue()`

- Removes an item from the `Queue`

### `peek()`

- Returns the next item in the `Queue`
