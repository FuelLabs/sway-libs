library;

mod data_structures;
mod errors;
mod events;

use data_structures::State;
use errors::AccessError;
use events::{OwnershipRenounced, OwnershipSet, OwnershipTransferred};
use std::{auth::msg_sender, hash::sha256, storage::storage_api::{read, write}};

pub struct Ownership {}

impl StorageKey<Ownership> {
    /// Returns the owner.
    ///
    /// # Number of Storage Accesses
    ///
    /// * Reads: `1`
    ///
    /// # Examples
    ///
    /// ```sway
    /// use ownable::Ownership;
    ///
    /// storage {
    ///     owner: Ownership = Ownership {},
    /// }
    /// 
    /// fn foo() {
    ///     let stored_owner = storage.owner.owner();
    /// }
    /// ```
    #[storage(read)]
    pub fn owner(self) -> State {
        read::<State>(self.slot, 0).unwrap_or(State::Uninitialized)
    }
}

impl StorageKey<Ownership> {
    /// Ensures that the sender is the owner.
    ///
    /// # Number of Storage Accesses
    ///
    /// * Reads: `1`
    ///
    /// # Reverts
    ///
    /// * When the sender is not the owner.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use ownable::Ownership;
    /// 
    /// storage {
    ///     owner: Ownership = Ownership {},
    /// }
    ///
    /// fn foo() {
    ///     storage.owner.only_owner();
    ///     // Do stuff here
    /// }
    /// ```
    #[storage(read)]
    pub fn only_owner(self) {
        require(self.owner() == State::Initialized(msg_sender().unwrap()), AccessError::NotOwner);
    }
}

impl StorageKey<Ownership> {
    /// Revokes ownership of the current owner and disallows any new owners.
    ///
    /// # Number of Storage Accesses
    ///
    /// * Reads: `1`
    /// * Writes: `1`
    ///
    /// # Reverts
    ///
    /// * When the sender is not the owner.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use ownable::Ownership;
    /// 
    /// storage {
    ///     owner: Ownership = Ownership {},
    /// }
    ///
    /// fn foo(owner: Identity) {
    ///     storage.owner.set_ownership(owner);
    ///     assert(storage.owner.owner() == State::Initialized(owner));
    ///     storage.owner.renounce_ownership();
    ///     assert(storage.owner.owner() == State::Revoked);
    /// }
    /// ```
    #[storage(read, write)]
    pub fn renounce_ownership(self) {
        self.only_owner();

        write(self.slot, 0, State::Revoked);

        log(OwnershipRenounced {
            previous_owner: msg_sender().unwrap(),
        });
    }

    /// Sets the passed identity as the initial owner.
    ///
    /// # Number of Storage Acesses
    ///
    /// * Reads: `1`
    /// * Write: `1`
    ///
    /// # Reverts
    ///
    /// * When ownership has been set before.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use ownable::Ownership;
    ///
    /// storage {
    ///     owner: Ownership = Ownership {},
    /// }
    /// 
    /// fn foo(owner: Identity) {
    ///     assert(storage.owner.owner() == State::Uninitialized);
    ///     storage.owner.set_ownership(owner);
    ///     assert(storage.owner.owner() == State::Initialized(owner));
    /// }
    /// ```
    #[storage(read, write)]
    pub fn set_ownership(self, new_owner: Identity) {
        require(self.owner() == State::Uninitialized, AccessError::CannotReinitialized);

        write(self.slot, 0, State::Initialized(new_owner));

        log(OwnershipSet { new_owner });
    }

    /// Transfers ownership to the passed identity.
    ///
    /// # Number of Storage Acesses
    ///
    /// * Reads: `1`
    /// * Write: `1`
    ///
    /// # Reverts
    ///
    /// * When the sender is not the owner.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use ownable::Ownership;
    /// 
    /// storage {
    ///     owner: Ownership = Ownership {},
    /// }
    ///
    /// fn foo(owner: Identity, second_owner: Identity) {
    ///     storage.owner.set_ownership(owner);
    ///     assert(storage.owner.owner() == State::Initialized(owner));
    ///     storage.owner.transfer_ownership(second_owner);
    ///     assert(storage.owner.owner() == State::Initialized(second_owner));
    /// }
    /// ```
    #[storage(read, write)]
    pub fn transfer_ownership(self, new_owner: Identity) {
        self.only_owner();
        write(self.slot, 0, State::Initialized(new_owner));

        log(OwnershipTransferred {
            new_owner,
            previous_owner: msg_sender().unwrap(),
        });
    }
}
