# Queue Library

A Queue is a linear structure which follows the First-In-First-Out (FIFO) principle. This means that the elements added first are the ones that get removed first.

For implementation details on the Queue Library please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/queue/queue/).

## Importing the Queue Library

In order to use the Queue Library, the Queue Library must be added to your `Forc.toml` file and then imported into your Sway project.

To add the Queue Library as a dependency to your `Forc.toml` file in your project, use the `forc add` command.

```bash
forc add queue@0.26.0
```

> **NOTE:** Be sure to set the version to the latest release.

To import the Queue Library to your Sway Smart Contract, add the following to your Sway file:

```sway
{{#include ../../../../examples/queue/src/main.sw:import}}
```

## Basic Functionality

### Instantiating a New Queue

Once the `Queue` has been imported, you can create a new queue instance by calling the `new` function.

```sway
{{#include ../../../../examples/queue/src/main.sw:instantiate}}
```

## Enqueuing elements

Adding elements to the `Queue` can be done using the `enqueue` function.

```sway
{{#include ../../../../examples/queue/src/main.sw:enqueue}}
```

### Dequeuing Elements

To remove elements from the `Queue`, the `dequeue` function is used. This function follows the FIFO principle.

```sway
{{#include ../../../../examples/queue/src/main.sw:dequeue}}
```

### Fetching the Head Element

To retrieve the element at the head of the `Queue` without removing it, you can use the `peek` function.

```sway
{{#include ../../../../examples/queue/src/main.sw:peek}}
```

### Checking the Queue's Length

The `is_empty` and `len` functions can be used to check if the queue is empty and to get the number of elements in the queue respectively.

```sway
{{#include ../../../../examples/queue/src/main.sw:length}}
```
