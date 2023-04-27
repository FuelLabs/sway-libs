> **Note** This library has been deprecated. Use of nested storage types is now legal in Sway.

# Overview

This document provides an overview of the StorageMapVec library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

# Use Cases

Any situation where you would want to create a mapping of vectors in storage would be a good place to use StorageMapVec, eg usecase would be storing a list of orders for every Identity, which would require a StorageMap<Identity, StorageVec<Order>>. However as using StorageVecs inside StorageMaps is not possible yet due to an implementation detail, you must use StorageMapVec to do the same.

## Public Functions

### `push`
The `push` function is used to push an item to the end of the vector. It takes two arguments, the key to the vector and the item to push. 

### `pop`
The `pop` function is used to pop the last item from the vector. It takes one argument, the key to the vector.

### `get`
The `get` function is used to get an item from the vector. It takes two arguments, the key to the vector and the index of the item to get.

### `set`
The `set` function is used to set an item in the vector. It takes three arguments, the key to the vector, the index of the item to set and the item to set.

### `len`
The `len` function is used to get the length of the vector. It takes one argument, the key to the vector.

### `swap`
The `swap` function is used to swap the position of two items in the vector. It takes three arguments, the key to the vector, the index of the first item and the index of the second item.

### `swap_remove`
The `swap_remove` function is used to swap the position of the given item with the last item in the vector and then pop the last item. It takes two arguments, the key to the vector and the index of the item to remove.

### `remove`

WARNING: This function is very expensive with large vectors. It is recommended to use `swap_remove` instead.

The `remove` function is used to remove the item at the given index and then move all items after the given index to the left by one. It takes two arguments, the key to the vector and the index of the item to remove.

