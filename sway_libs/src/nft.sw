library nft;

dep NFT/data_structures;
dep NFT/errors;
dep NFT/events;

use errors::{AccessError, InitError, InputError};
use events::{AdminEvent, ApprovalEvent, BurnEvent, MintEvent, OperatorEvent, TransferEvent};
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

