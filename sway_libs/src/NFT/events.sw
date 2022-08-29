library events;

use std::{identity::Identity, option::Option};

pub struct AdminEvent {
    /// The user which is now the admin of this contract.
    /// If there is no longer an admin then the `Option` will be `None`.
    admin: Option<Identity>,
}

pub struct ApprovalEvent {
    /// The user that has gotten approval to transfer the specified token.
    /// If an approval was revoked, the `Option` will be `None`.
    approved: Option<Identity>,

    /// The user that has given or revoked approval to transfer his/her tokens.
    owner: Identity,

    /// The unique identifier of the token which the approved may transfer.
    token_id: u64,
}

pub struct BurnEvent {
    /// The user that has burned their token.
    owner: Identity,

    /// The unique identifier of the token which has been burned.
    token_id: u64,
}

pub struct MintEvent {
    /// The owner of the newly minted tokens.
    owner: Identity,

    /// The starting range of token ids that have been minted in this transaction.
    token_id_start: u64,

    /// The total number of tokens minted in this transaction.
    total_tokens: u64,
}

pub struct OperatorEvent {
    /// Determines whether approval to transfer all of the owner's tokens has been given or revoked.
    approve: bool,

    /// The user which may or may not transfer all tokens on the owner's behalf.
    operator: Identity,

    /// The user which has given or revoked approval to the operator to transfer all of their
    /// tokens on their behalf.
    owner: Identity,
}

pub struct TransferEvent {
    /// The user which previously owned the token that has been transfered.
    from: Identity,

    // The user that made the transfer. This can be the owner, the approved user, or the operator.
    sender: Identity,

    /// The user which now owns the token that has been transfered.
    to: Identity,

    /// The unique identifier of the token which has transfered ownership.
    token_id: u64,
}
