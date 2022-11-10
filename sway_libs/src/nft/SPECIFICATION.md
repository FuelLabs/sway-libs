Table of Contents
- [Overview](#overview)
- [Use Cases](#use-cases)
    - [Core Public Functions](#core-public-functions)
        - [`approve()`](#approve)
        - [`approved()`](#approved)
        - [`balance_of()`](#balance_of)
        - [`is_approved_for_all()`](#is-approved-for-all)
        - [`mint()`](#mint)
        - [`owner_of()`](#owner-of)
        - [`set_approval_for_all()`](#set_approval-for-all)
        - [`tokens_minted()`](#tokens-minted)
        - [`transfer()`](#transfer)
    - [Extension Public Functions](#extension-public-functions)
        - [Administrator](#administrator)
            - [`admin()`](#admin)
            - [`set_admin()`](#set-admin)
        - [Burnable](#burnable)
            - [`burn()`](#burn)
        - [Metadata](#metadata)
            - [`meta_data()`](#meta-data)
            - [`set_meta_data()`](#set-meta-data)
        - [Supply](#supply)
            - [`max_supply()`](#max-supply)
            - [`set_max_supply()`](#set-max-supply)

# Overview

This document provides an overview of the NFT library.

It outlines the use cases, i.e. specification, and describes how to implement the library.

# Use Cases

The NFT library can be used anytime individual tokens with distictive characteritics are needed. 

Traits can be implemented to provide additional features to the `NFTCore` struct. Some traits are already provided in the extensions portion of this NFT library.

## Core Public Functions

These core functions are basic functionality that should be added to all NFTs, regardless of extensions. It is expected that these functions can be called from any other contract. 

### `approve()`

Gives permission to another user to transfer a single, specific token on the owner's behalf. 

### `approved()`

Returns the user which is permissioned to transfer the token on the owner's behalf.

### `balance_of()`

Returns the number of tokens owned by a user.

### `is_approved_for_all()`

Returns whether a user is approved to transfer **all** tokens on another user's behalf.

### `mint()`

Creates a new token with an owner and an id.

### `owner_of()`

Returns the owner of a specific token.

### `set_approval_for_all()`

Give permission to a user to transfer **all** tokens owned by another user's behalf.

### `tokens_minted()`

The total number of tokens that have been minted.

### `transfer()`

Transfers ownership of the token from one user to another.

## Extension Public Functions

These extensions are optional and not all NFTs will have these implemented. Whether they should be used is a case-by-case basis.

### Administrator

#### `admin()`

Returns the adiminstrator of the `NFT` library.

#### `set_admin()`

Sets the administrator of the `NFT` library.

### Burnable

#### `burn()`

Deletes the specified token.

### Metadata

#### `meta_data()`

Returns the stored data associated with the specified token.

#### `set_meta_data()`

Stores a struct containing information / data particular to an individual token.

### Supply

#### `max_supply()`

Returns the maximum number of tokens that may be minted.

#### `set_max_supply()`

Sets the maximum number of tokens that may be minted.
