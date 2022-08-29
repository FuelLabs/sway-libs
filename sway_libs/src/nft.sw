library nft;

dep NFT/data_structures;
dep NFT/errors;

use errors::{AccessError, InitError, InputError};
use std::{
    chain::auth::msg_sender,
    hash::sha256,
    identity::Identity,
    logging::log,
    option::Option,
    result::Result,
    revert::require,
    storage::{get, store}
};

// TODO: These are temporary storage keys for manual storage management. These should be updated once
// https://github.com/FuelLabs/sway/issues/2585 is resolved.
const ACCESS_CONTROL: b256 = 0x1000000000000000000000000000000000000000000000000000000000000000;
const ADMIN: b256 = 0x2000000000000000000000000000000000000000000000000000000000000000;
const APPROVED: b256 = 0x3000000000000000000000000000000000000000000000000000000000000000;
const BALANCES: b256 = 0x4000000000000000000000000000000000000000000000000000000000000000;
const MAX_SUPPLY: b256 = 0x5000000000000000000000000000000000000000000000000000000000000000;
const META_DATA: b256 = 0x6000000000000000000000000000000000000000000000000000000000000000;
const OPERATOR_APPROVAL: b256 = 0x7000000000000000000000000000000000000000000000000000000000000000;
const OWNERS: b256 = 0x8000000000000000000000000000000000000000000000000000000000000000;
const TOKENS_MINTED: b256 = 0x9000000000000000000000000000000000000000000000000000000000000000;
const TOTAL_SUPPLY: b256 = 0xa000000000000000000000000000000000000000000000000000000000000000;

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
