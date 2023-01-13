library ownable;

dep errors;
dep events;
dep ownable_storage;

use errors::AccessError;
use events::{OwnershipRenounced, OwnershipSet, OwnershipTransferred};
use ownable_storage::OWNER;
use std::{auth::msg_sender, hash::sha256, logging::log, storage::{get, store}};

#[storage(read)]
pub fn only_owner() {
    let owner = get::<Option<Identity>>(OWNER);
    require(owner.is_some() && msg_sender().unwrap() == owner.unwrap(), AccessError::NotOwner);
}

#[storage(read)]
pub fn owner() -> Option<Identity> {
    get::<Option<Identity>>(OWNER)
}

#[storage(read, write)]
pub fn renounce_ownership() {
    only_owner();
    store(OWNER, Option::None::<Identity>());

    log(OwnershipRenounced {
        previous_owner: msg_sender().unwrap(),
    });
}

#[storage(read, write)]
pub fn set_ownership(new_owner: Identity) {
    require(get::<Option<Identity>>(OWNER).is_none(), AccessError::OwnerExists);
    store(OWNER, Option::Some(new_owner));

    log(OwnershipSet { new_owner });
}

#[storage(read, write)]
pub fn transfer_ownership(new_owner: Identity) {
    only_owner();
    store(OWNER, Option::Some(new_owner));

    log(OwnershipTransferred {
        new_owner,
        previous_owner: msg_sender().unwrap(),
    });
}
