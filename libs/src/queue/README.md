<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".docs/queue-logo-dark-theme.png">
        <img alt="SwayApps logo" width="400px" src=".docs/queue-logo-light-theme.png">
    </picture>
</p>


# Overview

A Queue is a linear structure which follows the First-In-First-Out (FIFO) principle. This means that the elements added first are the ones that get removed first.

For more information about implementation and specifications, please see the [SPECIFICATION.md](./SPECIFICATION.md).

# Using the Library

## Getting Started

In order to use the Queue library, Sway Libs must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [README.md](../../README.md).

You may then import the Queue library's functionalities like so:

```sway
use sway_libs::queue::Queue;
```

Once the `Queue` has been imported, you can create a new queue instance by calling the `new` function.

```sway
let mut queue = Queue::new();
```

## Basic Functionality

Adding elements to the `Queue` can be done using the `enqueue` function.

```sway
// Enqueue an element to the queue
queue.enqueue(10u8);
```

To remove elements from the `Queue`, the `dequeue` function is used. This function follows the FIFO principle.

```sway
// Dequeue the first element and unwrap the value
let first_item = queue.dequeue().unwrap();
```

To retrieve the element at the head of the `Queue` without removing it, you can use the `peek` function.

```sway
// Peek at the head of the queue
let head_item = queue.peek();
```

The `is_empty` and `len` functions can be used to check if the queue is empty and to get the number of elements in the queue respectively.

```sway
// Checks if queue is empty (returns True or False)
let is_queue_empty = queue.is_empty();

// Returns length of queue
let queue_length = queue.len();
```

For more information please see the [specification](./SPECIFICATION.md).
