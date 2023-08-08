library;

pub mod errors;
pub mod events;

use errors::AccessError;
use events::{OwnershipRenounced, OwnershipSet, OwnershipTransferred};
use std::{auth::msg_sender, hash::sha256, storage::storage_api::{read, write}};
use src_5::{Ownership, State};

impl Ownership {
    /// Returns the `Ownership` struct in the `Uninitalized` state.
    ///
    /// # Returns
    ///
    /// * [Ownership] - The struct in the `Uninitalized` state.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use ownership::Ownership;
    ///
    /// fn foo() {
    ///     let ownership = Ownership::uninitalized();
    ///     assert(ownership.state == State::Uninitalized);
    /// }
    /// ```
    pub fn uninitialized() -> Self {
        Self {
            state: State::Uninitialized,
        }
    }

    /// Returns the `Ownership` struct in the `Initalized` state.
    ///
    /// # Arguments
    ///
    /// * `identity`: [Identity] - The `Identity` which ownership is set to.
    ///
    /// # Returns
    ///
    /// * [Ownership] - The struct in the `Initialized` state.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use ownership::Ownership;
    /// use std::constants::ZERO_B256;
    ///
    /// fn foo() {
    ///     let identity = Identity::Address(Address::from(ZERO_B256));
    ///     let ownership = Ownership::initialized();
    ///     assert(ownership.state == State::Initialized(identity));
    /// }
    /// ```
    pub fn initialized(identity: Identity) -> Self {
        Self {
            state: State::Initialized(identity),
        }
    }

    /// Returns the `Ownership` struct in the `Revoked` state.
    ///
    /// # Additional Information
    ///
    /// Any ownership that is revoked is forever locked in that state. The ownership cannot be reset.
    ///
    /// # Returns
    ///
    /// * [Ownership] - The struct in the `Revoked` state.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use ownership::Ownership;
    ///
    /// fn foo() {
    ///     let ownership = Ownership::revoked();
    ///     assert(ownership.state == State::Revoked);
    /// }
    /// ```
    pub fn revoked() -> Self {
        Self {
            state: State::Revoked,
        }
    }
}

impl StorageKey<Ownership> {
    /// Returns the owner.
    ///
    /// # Returns
    ///
    /// * [State] - The state of the ownership.
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
    ///     owner: Ownership = Ownership::initalized(Identity::Address(Address::from(ZERO_B256))),
    /// }
    ///
    /// fn foo() {
    ///     let stored_owner = storage.owner.owner();
    /// }
    /// ```
    #[storage(read)]
    pub fn owner(self) -> State {
        self.read().state
    }
}

impl StorageKey<Ownership> {
    /// Ensures that the sender is the owner.
    ///
    /// # Reverts
    ///
    /// * When the sender is not the owner.
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
    ///     owner: Ownership = Ownership::initalized(Identity::Address(Address::from(ZERO_B256))),
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
    /// # Reverts
    ///
    /// * When the sender is not the owner.
    ///
    /// # Number of Storage Accesses
    ///
    /// * Reads: `1`
    /// * Writes: `1`
    ///
    /// # Examples
    ///
    /// ```sway
    /// use ownable::Ownership;
    ///
    /// storage {
    ///     owner: Ownership = Ownership::initalized(Identity::Address(Address::from(ZERO_B256))),
    /// }
    ///
    /// fn foo() {
    ///     assert(storage.owner.owner() == State::Initialized(Identity::Address(Address::from(ZERO_B256)));
    ///     storage.owner.renounce_ownership();
    ///     assert(storage.owner.owner() == State::Revoked);
    /// }
    /// ```
    #[storage(read, write)]
    pub fn renounce_ownership(self) {
        self.only_owner();

        self.write(Ownership::revoked());

        log(OwnershipRenounced {
            previous_owner: msg_sender().unwrap(),
        });
    }

    /// Sets the passed identity as the initial owner.
    ///
    /// # Arguments
    ///
    /// * `new_owner`: [Identity] - The `Identity` that will be the first owner.
    ///
    /// # Reverts
    ///
    /// * When ownership has been set before.
    ///
    /// # Number of Storage Acesses
    ///
    /// * Reads: `1`
    /// * Write: `1`
    ///
    /// # Examples
    ///
    /// ```sway
    /// use ownable::Ownership;
    ///
    /// storage {
    ///     owner: Ownership = Ownership::uninitialized(),
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

        self.write(Ownership::initialized(new_owner));

        log(OwnershipSet { new_owner });
    }

    /// Transfers ownership to the passed identity.
    ///
    /// # Arguments
    ///
    /// * `new_owner`: [Identity] - The `Identity` that will be the next owner.
    ///
    /// # Reverts
    ///
    /// * When the sender is not the owner.
    ///
    /// # Number of Storage Acesses
    ///
    /// * Reads: `1`
    /// * Write: `1`
    ///
    /// # Examples
    ///
    /// ```sway
    /// use ownable::Ownership;
    ///
    /// storage {
    ///     owner: Ownership = OwnershipOwnership::initalized(Identity::Address(Address::from(ZERO_B256))),
    /// }
    ///
    /// fn foo(new_owner: Identity) {
    ///     assert(storage.owner.owner() == State::Initialized(Identity::Address(Address::from(ZERO_B256)));
    ///     storage.owner.transfer_ownership(new_owner);
    ///     assert(storage.owner.owner() == State::Initialized(new_owner));
    /// }
    /// ```
    #[storage(read, write)]
    pub fn transfer_ownership(self, new_owner: Identity) {
        self.only_owner();
        self.write(Ownership::initialized(new_owner));

        log(OwnershipTransferred {
            new_owner,
            previous_owner: msg_sender().unwrap(),
        });
    }
}
