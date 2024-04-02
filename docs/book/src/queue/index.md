# Queue Library

A Queue is a linear structure which follows the First-In-First-Out (FIFO) principle. This means that the elements added first are the ones that get removed first.

For implementation details on the Queue Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/queue/index.html).

## Importing the Queue Library

In order to use the Queue Library, Sway Libs must be added to the `Forc.toml` file and then imported into your Sway project. To add Sway Libs as a dependency to the `Forc.toml` file in your project please see the [Getting Started](../../../getting_started/index.md).

To import the Queue Library to your Sway Smart Contract, add the following to your Sway file:

```sway
use sway_libs::queue::*;
```

## Basic Functionality

### Instantiating a New Queue

Once the `Queue` has been imported, you can create a new queue instance by calling the `new` function.

```sway
let mut queue = Queue::new();
```

## Enqueuing elements

Adding elements to the `Queue` can be done using the `enqueue` function.

```sway
// Enqueue an element to the queue
queue.enqueue(10u8);
```

### Dequeuing Elements

To remove elements from the `Queue`, the `dequeue` function is used. This function follows the FIFO principle.

```sway
// Dequeue the first element and unwrap the value
let first_item = queue.dequeue().unwrap();
```

### Fetching the Head Element

To retrieve the element at the head of the `Queue` without removing it, you can use the `peek` function.

```sway
// Peek at the head of the queue
let head_item = queue.peek();
```

### Checking the Queue's Length

The `is_empty` and `len` functions can be used to check if the queue is empty and to get the number of elements in the queue respectively.

```sway
// Checks if queue is empty (returns True or False)
let is_queue_empty = queue.is_empty();

// Returns length of queue
let queue_length = queue.len();
```
