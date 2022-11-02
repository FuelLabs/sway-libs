## Overview

A non-fungible token (NFT) is a unique token that has an identifier which distinguishes itself from other tokens within the same token contract. Unlike Fuel's Native Assets, these tokens are not fungible with one another and may contain metadata giving them distinctive characteristics.

While it is commonly associated with artwork / collectibles, there are many greater utilities beyond that which have yet to be written for the Fuel Network.

# Using the Library

## Getting Started

In order to use the `NFT` library, Sway-libs must be added to the Forc.toml file and then imported into your Sway project. To add Sway-libs as a dependency to the Forc.toml in your project please see the [README.md](../../../README.md).

```rust
use sway_libs::nft::*;
```

## Basic Functionality

Once imported, a `NFT` can be minted by calling the `mint` function.

```rust
let new_owner: Identity = msg_sender().unwrap();
let token_id: u64 = 1;
~NFTCore::mint(new_owner, token_id);
```

Tokens may be transfered by calling the `transfer` function.

```rust
let new_owner: Identity = msg_sender().unwrap();
let token_id: u64 = 1;
transfer(new_owner, token_id);
```

You may check the owner of a token by calling the `owner_of` function.

```rust
let token_id: u64 = 1;
let owner: Option<Identity> = owner_of(token_id);
```

Other users may be approved to transfer a token on another's behalf by calling the `approve` function.

```rust
let approved_user: Identity = msg_sender().unwrap();
let token_id: u64 = 1;
approve(approved_user, token_id);
```

## Extensions

There are a number of different extensions which you may use to further enchance your non-fungible tokens. 

These include:
1. Metadata
2. Burning functionality
3. Administrative capabilities
4. Supply limits

For more information please see the [specification](./SPECIFICATION.md).
