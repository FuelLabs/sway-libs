> **Note** This standard has moved to a new repository. Please visit the [Sway-Standards](https://github.com/FuelLabs/sway-standards) repository for the most up to date standards. 

<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".docs/frc-721-logo-dark-theme.png">
        <img alt="SwayApps logo" width="400px" src=".docs/frc-721-logo-light-theme.png">
    </picture>
</p>

## Overview

The FRC-721 standard defines and outlines NFTs on the Fuel Network. 

The official specification can be found in the [frc_721.sw](./src/frc_721.sw) file.

To jumpstart the deployment of your own NFTs, the [NFT Library](../../libs/nft/) provides an easy to use outline following the FRC-721 standard and uses structs and traits for it's implementation.

## Functions

### `transfer()`

Transfers ownership of an NFT from one Identity to another.

> **NOTE:** At the time of a transfer, the approved Identity for that NFT (if any) **MUST** be reset to Option::None.

### `approve()`

Sets or reafirms the approved Identity for an NFT.

> **NOTE:** The approved Identity for the specified NFT **MAY** transfer the token to a new owner.

### `set_approval_for_all()`

Enables or disables approval for a third party "Operator" to manage all of `msg_sender()`'s NFTs.

> **NOTE:** An operator for an Identity **MAY** transfer and MAY set approved Identities for all tokens owned by the `msg_sender()`.

### `approved()`

Gets the approved Identity for a single NFT.

> **NOTE:** Option::None indicates there is no approved Identity.

### `balance_of()`

Returns the number of NFTs owned by an Identity.

### `is_approved_for_all()`

Queries if an Identity is an authorized operator for another Identity.

### `owner_of()`

Queries the owner of an NFT.

> **NOTE:** Option::None indicates there is no owner Identity.

## Events

### `ApprovalEvent`

The `ApprovalEvent` event **MUST** be logged when the approved Identity for an NFT is changed or modified.
The approved Identity for the specified NFT **MAY** transfer the token to a new owner.
Option::None indicates there is no approved Identity.

### `OperatorEvent`

The `OperatorEvent` event **MUST** be logged when an operator is enabled or disabled for an owner.
The operator can manage all NFTs of the owner.

### `TransferEvent`

The `TransferEvent` event **MUST** be logged when ownership of any NFT changes between two Identities.

> **NOTE:** Exception: Cases where there is no new or previous owner, more formally known as minting and burning, the event **SHALL NOT** be logged.

## Extensions

### Metadata

The metadata extension specification can be found [here](./src/extensions/frc721_metadata.sw).
