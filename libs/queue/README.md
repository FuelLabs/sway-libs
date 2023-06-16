# Overview

A Queue is a linear structure which follows the First-In-First-Out (FIFO) principle. This means that the elements added first are the ones that get removed first.

For more information about implementation and specifications, please see the [SPECIFICATION.md](./SPECIFICATION.md).

# Using the Library

## Getting Started

To use the Queue library, you need to add it to the Forc.toml file and then import it into your Sway project. For more details on how to add Sway-libs as a dependency to your Forc.toml, refer to the [README.md](../../README.md).

```rust
use queue::Queue;
```

Once the `Queue` has been imported, you can create a new queue instance by calling the `new` function.

```rust
let mut queue = Queue::new();
```

## Basic Functionality

Adding elements to the `Queue` can be done using the `enqueue` function.

```rust
// Enqueue an element to the queue
queue.enqueue(10u8);
```

To remove elements from the `Queue`, the `dequeue` function is used. This function follows the FIFO principle.

```rust
// Dequeue the first element and unwrap the value
let first_item = queue.dequeue().unwrap();
```

To retrieve the element at the head of the `Queue` without removing it, you can use the `peek` function.

```rust
// Peek at the head of the queue
let head_item = queue.peek();
```

The `is_empty` and `len` functions can be used to check if the queue is empty and to get the number of elements in the queue respectively.

```rust
// Checks if queue is empty (returns True or False)
let is_queue_empty = queue.is_empty();

// Returns length of queue
let queue_length = queue.len();
```

For more information please see the [specification](./SPECIFICATION.md).
