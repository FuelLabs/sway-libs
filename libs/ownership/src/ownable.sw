library ownable;

dep data_structures;
dep errors;
dep events;
dep ownable_storage;

use data_structures::State;
use errors::AccessError;
use events::{OwnershipRenounced, OwnershipSet, OwnershipTransferred};
use ownable_storage::OWNER;
use std::{auth::msg_sender, hash::sha256, logging::log, storage::{get, store}};

#[storage(read)]
pub fn only_owner() {
    let owner = get::<State>(OWNER).unwrap_or(State::Uninitialized);
    require(State::Initialized(msg_sender().unwrap()) == owner, AccessError::NotOwner);
}

#[storage(read)]
pub fn owner() -> State {
    get::<State>(OWNER).unwrap_or(State::Uninitialized)
}

#[storage(read, write)]
pub fn renounce_ownership() {
    only_owner();

    store(OWNER, State::Revoked);

    log(OwnershipRenounced {
        previous_owner: msg_sender().unwrap(),
    });
}

#[storage(read, write)]
pub fn set_ownership(new_owner: Identity) {
    require(get::<State>(OWNER).unwrap_or(State::Uninitialized) == State::Uninitialized, AccessError::CannotReinitialized);

    store(OWNER, State::Initialized(new_owner));

    log(OwnershipSet { new_owner });
}

#[storage(read, write)]
pub fn transfer_ownership(new_owner: Identity) {
    only_owner();
    store(OWNER, State::Initialized(new_owner));

    log(OwnershipTransferred {
        new_owner,
        previous_owner: msg_sender().unwrap(),
    });
}
