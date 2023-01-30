# Overview

StorageMapVec is a temporary workaround for implementing a StorageMap<K, StorageVec<V>>. See why you cannot use StorageMap<K, StorageVec<V>> directly in [this issue](https://github.com/FuelLabs/sway/issues/2639). This library will be deprecated when that issue is resolved.

More information can be found in the [specification](./SPECIFICATION.md).

## Known Issues

StorageMapVec, like its predecessors (StorageMap, StorageVec) cannot be used recursively or multiple times (in a struct) for the same storage variable, or else it will overwrite its previous values.

# Using the Library

## Using the StorageMapVec library In Sway

Once imported, using the StorageMapVec library is as simple as making a storage variable and then calling the methods on it. [Here is an example](##Example). For more information please see the [specification](./SPECIFICATION.md).

## Example

```rust
use storagemapvec::StorageMapVec;

storage {
    mapvec: StorageMapVec<u64, u64> = StorageMapVec {},
}

abi MyContract {
    #[storage(read, write)]
    fn push(key: u64, value: u64);

    #[storage(read)]
    fn get(key: u64, index: u64);
}

impl MyContract for Contract {
    #[storage(read, write)]
    fn push(key: u64, value: u64) {
        // this will push the value to the vec, which is accessible with the key
        storage.mapvec.push(key, value);
    }

    #[storage(read)]
    fn get(key: u64, index: u64) {
        // this will retrieve the vec at given key, and then retrieve the value at given index from that vec
        storage.mapvec.get(key, index)
    }
}
```