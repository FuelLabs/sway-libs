# Overview

This document provides an overview of the Merkle Proof library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

# Use Cases

Merkle trees allow for on-chain verification of off-chain data. With the root posted on-chain, the generation of proofs off-chain can provide verifibly true data. 

An example of a common use case is airdrops. An airdrop is a method of distribution a set amount of tokens to a specified number of users. These often include a list of addresses and amounts. By posting the root hash, users can provide a proof and claim their airdrop.

# Specification

All cryptographic primitives follow the [Fuel Specs](https://github.com/FuelLabs/fuel-specs/blob/master/specs/protocol/cryptographic_primitives.md).

## Hashing 

All hashing is done with SHA-2-256 (also known as SHA-256), defined in [FIPS 180-4](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.180-4.pdf).

> **NOTE** The current implementation of the Fuel VM will pad copy types of size less than one word to a full word. The copy type will be padded with zeros. As a result, hashing of smaller sized copy types may result in unexpected behavior. For example, the `sha-256(0u8)` will result in the same hash as `sha-256(0u64)`.

## Merkle Trees

Currently only one tree structure is support, the Binary Merkle Tree. Implementation for a Binary Merkle Sum Tree and Sparse Merkle Tree found in the [fuel-merkle](https://github.com/FuelLabs/fuel-merkle) repository will be added soon. 

### Binary Merkle Tree

Binary Merkle trees are constructed in the same fashion as described in [Certificate Transparency (RFC-6962)](https://tools.ietf.org/html/rfc6962). Leaves are hashed once to get leaf node values and internal node values are the hash of the concatenation of their children (either leaf nodes or other internal nodes).

For more information please check out the offical [Fuel Specs](https://github.com/FuelLabs/fuel-specs/blob/master/specs/protocol/cryptographic_primitives.md#binary-merkle-tree).

> **NOTE** Due to the Fuel VM padding of copy types smaller than one word, the current hashing of the leaf and node values do not match RFC-6962. The present implementation is the equavalent of hashing a `u64` as opposed to the standard `u8`. This will cause an incompatability with the [Fuel-Merkle](https://github.com/FuelLabs/fuel-merkle) repository. The issue regarding this can be tracked [here](https://github.com/FuelLabs/sway/issues/2594).
