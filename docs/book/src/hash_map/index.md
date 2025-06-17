# HashMap Library

A heap-allocated hash map implementation for the Sway language. This data structure exists only in memory during contract execution and does not persist to storage. It's primarily used in predicates (where storage is unavailable) but can also be used for temporary data storage in smart contracts.

## Key Characteristics

- **Heap-allocated**: All data exists only in memory during execution
- **Non-persistent**: Data is not saved to storage between transactions
- **Collision handling**: Uses linear probing with hash randomization
- **Auto-resizing**: Capacity doubles when full (starting from 1)
- **Generic**: Supports any types implementing `Eq + Hash` traits

## When to Use

✅ **Ideal for**:

- Predicates (where storage is unavailable)
- Intermediate calculations in contracts
- Temporary data aggregation
- Caching frequently accessed computation results
- State machines during contract execution

❌ **Not suitable for**:

- Persistent data storage (use `StorageMap` instead)
- Large datasets exceeding block memory limits
- Long-term state management

## Performance Note

⚠️ Always use `with_capacity` when possible to pre-allocate memory. Reallocation during growth is expensive and involves repopulating the entire map.

## Methods

### `new() -> Self`

Creates an empty `HashMap` with capacity 0.

- Use Case: When the maximum size is unknown. For known sizes, with_capacity() is always preferred.
- Allocation Cost: Initial zero-allocation. First insertion triggers resize to capacity 1.

```sway
{{#include ../../../../examples/hash_map/src/main.sw:new}}
```

### `with_capacity(capacity: u16) -> Self`

Returns a new instance of a `HashMap` with a pre-allocated capacity to hold elements. This is the recommended function to use when creating a new `HashMap`.

```sway
{{#include ../../../../examples/hash_map/src/main.sw:with_capacity}}
```

### `insert(&mut self, key: K, val: V) -> Option<V>`

Inserts a key-value pair. If the map did not have this key present, `None` is returned. Otherwise `Some(V)`.

```sway
{{#include ../../../../examples/hash_map/src/main.sw:insert}}
```

### `try_insert(&mut self, key: K, val: V) -> Result<V, HashMapError<V>>`

Tries to insert a key-value pair into the map, and returns the value in the entry. If the map already had this key present, nothing is updated, and an error containing the occupied entry and the value is returned.

```sway
{{#include ../../../../examples/hash_map/src/main.sw:try_insert}}
```

### `remove(&mut self, key: K) -> Option<V>`

Removes a key-value pair. Returns the value at the key if the key was previously in the map.

```sway
{{#include ../../../../examples/hash_map/src/main.sw:remove}}
```

### `get(&self, key: K) -> Option<V>`

Returns the value associated with the key or `None`.

```sway
{{#include ../../../../examples/hash_map/src/main.sw:get}}
```

### `contains_key(&self, key: K) -> bool`

Checks if key exists in map.

```sway
{{#include ../../../../examples/hash_map/src/main.sw:contains_key}}
```

### `keys(&self) -> Vec<K>`

Returns the list of keys present in the `HashMap`. The list return is unordered and is not guaranteed to be in the order inserted into the `HashMap`.

```sway
{{#include ../../../../examples/hash_map/src/main.sw:keys}}
```

### `values(&self) -> Vec<V>`

Returns the list of values present in the `HashMap`. The list return is unordered and is not guaranteed to be in the order inserted into the `HashMap`.

```sway
{{#include ../../../../examples/hash_map/src/main.sw:values}}
```

### `len(&self) -> u16`

Returns number of elements.

```sway
{{#include ../../../../examples/hash_map/src/main.sw:len}}
```

### `capacity(&self) -> u16`

Returns current capacity.

```sway
{{#include ../../../../examples/hash_map/src/main.sw:capacity}}
```

### `is_empty(&self) -> bool`

Checks if map has no elements.

```sway
{{#include ../../../../examples/hash_map/src/main.sw:is_empty}}
```

### `iter(&self) -> HashMapIter<K, V>`

Returns an iterator over key-value pairs.

```sway
{{#include ../../../../examples/hash_map/src/main.sw:iter}}
```

## Iterators

### `HashMapIter<K, V>`

Iterator over key-value pairs.

```sway
{{#include ../../../../examples/hash_map/src/main.sw:for}}
```

## Error Types

### `HashMapError<V>`

Error variants for hash map operations.

#### Variants

`OccupiedError(V)`: Returned by try_insert when key exists (contains existing value)

## Memory Layout

The map uses three contiguous memory regions:

1. Keys: Array of keys
2. Values: Array of values
3. Indexes: Status array tracking

Collisions are resolved using linear probing.

## Limitations

- Maximum capacity: `u16::MAX` (65,535 elements)
- No persistent storage
- Keys/values must implement Eq + Hash

## Best Practices

- Always use `with_capacity()` for known sizes
- Prefer `try_insert()` when checking for existing keys
- Use `iter()` for efficient traversal
- Avoid storing large datasets (heap memory constrained)
