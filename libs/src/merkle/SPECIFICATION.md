# Overview

This document provides an overview of the Merkle Proof library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

# Use Cases

A common use case for Merkle Tree verification is airdrops. An airdrop is a method of distribution a set amount of assets to a specified number of users. These often include a list of addresses and amounts. By posting the root hash, users can provide a proof and claim their airdrop.

## Public Functions

### `leaf_digest`

The `leaf_digest` function is used to compute leaf hash of a Merkle Tree. Given the data provided, it returns the leaf hash following [RFC-6962](https://tools.ietf.org/html/rfc6962) as described by `MTH({d(0)}) = SHA-256(0x00 || d(0))`.

### `node_digest`

The `node_digest` function is used to complute a node within a Merkle Tree. Given a left and right node, it returns the node hash following [RFC-6962](https://tools.ietf.org/html/rfc6962) as described by `MTH(D[n]) = SHA-256(0x01 || MTH(D[0:k]) || MTH(D[k:n]))`.

### `process_proof`

The `process_proof` function will compute the Merkle root from a Merkle Proof. Given a leaf, the key for the leaf, the corresponding proof, and number of leaves in the Merkle Tree, the root of the Merkle Tree will be returned.

### `verify_proof`

The `verify_proof` function will verify a Merkle Proof against a Merkle root. Given a Merkle root, a leaf, the key for the leaf, the corresponding proof, and the number of leaves in the Merkle Tree, a `bool` will be returned as to whether the proof is valid.

# Specification

All cryptographic primitives follow the [Fuel Specs](https://github.com/FuelLabs/fuel-specs/blob/master/specs/protocol/cryptographic_primitives.md).

## Hashing 

All hashing is done with SHA-2-256 (also known as SHA-256), defined in [FIPS 180-4](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.180-4.pdf).

## Merkle Trees

Currently only one tree structure is supported, the Binary Merkle Tree. Implementation for a Binary Merkle Sum Tree and Sparse Merkle Tree found in the [fuel-merkle](https://github.com/FuelLabs/fuel-merkle) repository will be added soon. 

A Sparse Merkle Tree proof can be tracked [here](https://github.com/FuelLabs/sway-libs/issues/18) and Sum Merkle Tree proof can be tracked [here](https://github.com/FuelLabs/sway-libs/issues/17).

### Binary Merkle Tree

Binary Merkle trees are constructed in the same fashion as described in [Certificate Transparency (RFC-6962)](https://tools.ietf.org/html/rfc6962). Leaves are hashed once to get leaf node values and internal node values are the hash of the concatenation of their children (either leaf nodes or other internal nodes).

For more information please check out the offical [Fuel Specs](https://github.com/FuelLabs/fuel-specs/blob/master/specs/protocol/cryptographic_primitives.md#binary-merkle-tree).
