# NFT Creation Guide

This guide walks through creating a simple NFT-style collection on the Fuel
Network using the Sway Libs Asset and Metadata libraries. It shows how to
mint a unique Native Asset per token, attach on-chain metadata, and expose the
standard ABIs so the collection is compatible with Fuel tooling.

> **NOTE:** Fuel Native Assets follow [SRC-20](https://docs.fuel.network/docs/sway-standards/src-20-native-asset/)
> (the asset itself), [SRC-3](https://docs.fuel.network/docs/sway-standards/src-3-minting-and-burning/)
> (mint/burn), and [SRC-7](https://docs.fuel.network/docs/sway-standards/src-7-asset-metadata/)
> (metadata). A "one-of-one" NFT is just a Native Asset minted with a supply of
> exactly `1`.

## 1. Add the Dependencies

Create a new Forc project and add the Asset and Metadata libraries:

```bash
forc new my_nft
cd my_nft
forc add asset@0.26.0
forc add metadata@0.26.0
```

Your `Forc.toml` should now include:

```toml
[dependencies]
asset = "0.26.0"
metadata = "0.26.0"
```

## 2. Implement the Contract

The contract below mints a single asset (supply `1`) per `token_id`, stores a
name + symbol + base URI as metadata, and exposes the SRC-3 and SRC-7 ABIs.

```sway
contract;

use asset::{base, supply, Asset};
use metadata::{metadata, Metadata};
use std::bytes::Bytes;

// SRC-20 core: create the asset with a sub-identifier.
abi MyNft {
    #[storage(write)]
    fn mint(token_id: u64, name: str[32], symbol: str[8]) -> Asset;

    #[storage(write)]
    fn set_metadata(token_id: u64, key: str[32], value: Bytes);

    #[storage(read)]
    fn metadata(token_id: u64, key: str[32]) -> Option<Bytes>;
}

impl MyNft for Contract {
    #[storage(write)]
    fn mint(token_id: u64, name: str[32], symbol: str[8]) -> Asset {
        // sub_id derives a unique asset from the contract + token_id
        let sub_id = token_id.to_be_bytes();
        let asset = base::create(sub_id);
        // mint exactly one unit -> one-of-one NFT
        supply::mint(asset, 1);
        // store human-readable metadata
        metadata::set(asset, "name".into(), name.into());
        metadata::set(asset, "symbol".into(), symbol.into());
        asset
    }

    #[storage(write)]
    fn set_metadata(token_id: u64, key: str[32], value: Bytes) {
        let sub_id = token_id.to_be_bytes();
        let asset = base::create(sub_id);
        metadata::set(asset, key, value);
    }

    #[storage(read)]
    fn metadata(token_id: u64, key: str[32]) -> Option<Bytes> {
        let sub_id = token_id.to_be_bytes();
        let asset = base::create(sub_id);
        metadata::get(asset, key)
    }
}
```

## 3. Expose the Standard ABIs (SRC-3 / SRC-7)

For wallets and explorers to recognize your collection, also implement the
standard ABIs from the libraries:

```sway
use asset::SRC20;
use metadata::SRC7;

impl SRC20 for Contract {
    #[storage(read)]
    fn total_assets() -> u64 { base::total_assets() }

    #[storage(read)]
    fn total_supply(asset: Asset) -> u64 { base::total_supply(asset) }

    #[storage(read)]
    fn name(asset: Asset) -> Option<str[32]> { base::name(asset) }

    #[storage(read)]
    fn symbol(asset: Asset) -> Option<str[8]> { base::symbol(asset) }
}

impl SRC7 for Contract {
    #[storage(read)]
    fn metadata(asset: Asset, key: str[32]) -> Option<Bytes> {
        metadata::get(asset, key)
    }
}
```

## 4. Build and Test

```bash
forc build
forc test
```

A minimal test that mints and reads metadata:

```sway
#[test]
fn mint_and_read_metadata() {
    let asset = MyNft::mint(1, "My Art".into(), "ART".into());
    let name = MyNft::metadata(1, "name".into());
    assert(name.is_some());
}
```

## 5. Next Steps

- Store off-chain art via a `base_uri` metadata key and append the `token_id`.
- Add an `owner_of` mapping + transfer guard if you want enforced ownership.
- Emit a mint event so indexers can surface the token.
