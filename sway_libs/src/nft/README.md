## Overview

A non-fungible token (NFT) is a unique token that has an identifier which distinguishes itself from other tokens within the same token contract. Unlike Fuel's Native Assets, these tokens are not fungible with one another and may contain metadata or other traits giving them distinctive characteristics.

Some common applications of an NFT include artwork / collectibles, DeFi short positions, deeds, and more.

For more information please see the [specification](./SPECIFICATION.md).

# Using the Library

## Getting Started

In order to use the `NFT` library, Sway-libs must be added as a dependency to the project's Forc.toml file. To add Sway-libs as a dependency to the Forc.toml file in your project please see the [README.md](../../../README.md). Once this has been done, you may import the `NFT` library using the `use` keyword and explicitly state which functions you will be using. For a list of all functions please see the [specification](./SPECIFICATION.md).

```rust
use sway_libs::nft::{
    approve,
    mint,
    owner_of,
    transfer,
};
```

## Basic Functionality

Once imported, a `NFT` can be minted by calling the `mint` function.

```rust
// The user which shall own the newly minted NFT
let new_owner = msg_sender().unwrap();
// The id of the newly minted token
let token_id = 1;

NFTCore::mint(new_owner, token_id);
```

Tokens may be transferred by calling the `transfer` function.

```rust
// The user which the token shall be transferred to
let new_owner = msg_sender().unwrap();
// The id of the token which will be transferred
let token_id = 1;

transfer(new_owner, token_id);
```

You may check the owner of a token by calling the `owner_of` function.

```rust
let token_id: = 1;
let owner = owner_of(token_id).unwrap();
```

Other users may be approved to transfer a token on another's behalf by calling the `approve` function.

```rust
// The user which may transfer the token
let approved_user = msg_sender().unwrap();
// The id of the token which they may transfer
let token_id = 1;

approve(approved_user, token_id);
```

## Extensions

There are a number of different extensions which you may use to further enchance your non-fungible tokens. 

These include:
1. [Metadata](./extensions/meta_data/meta_data.sw)
2. [Burning functionality](./extensions/burnable/burnable.sw)
3. [Administrative capabilities](./extensions/administrator/administrator.sw)
4. [Supply limits](./extensions/supply/supply.sw)

For more information please see the [specification](./SPECIFICATION.md).
