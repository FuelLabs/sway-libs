# Overview

This document provides an overview of the Merkle Proof library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

# Use Cases

A common use case for Merkle Tree verification is airdrops. An airdrop is a method of distribution a set amount of tokens to a specified number of users. These often include a list of addresses and amounts. By posting the root hash, users can provide a proof and claim their airdrop.

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
