library nft_core;

dep errors;
dep events;
dep nft_storage;

use errors::{AccessError, InputError};
use events::{ApprovalEvent, MintEvent, OperatorEvent, TransferEvent};
use std::{auth::msg_sender, hash::sha256, logging::log, storage::{get, store}};
use nft_storage::{BALANCES, OPERATOR_APPROVAL, TOKENS, TOKENS_MINTED};

pub struct NFTCore {
    approved: Option<Identity>,
    owner: Identity,
    token_id: u64,
}

impl NFTCore {
    /// Gives approval to the `approved` user to transfer this token on the owner's behalf.
    ///
    /// To revoke approval the approved user should be `None`.
    ///
    /// # Arguments
    ///
    /// * `approved` - The user which will be allowed to transfer the token on the owner's behalf.
    ///
    /// # Reverts
    ///
    /// * When the sender is not the token's owner.
    #[storage(write)]
    fn approve(self, approved: Option<Identity>) {
        let mut nft = self;
        let sender = msg_sender().unwrap();
        require(nft.owner == sender, AccessError::SenderNotOwner);

        // Set and store the `approved` `Identity`
        nft.approved = approved;
        store(sha256((TOKENS, self.token_id)), Option::Some(nft));

        log(ApprovalEvent {
            owner: nft.owner,
            approved,
            token_id: nft.token_id,
        });
    }

    /// Returns the user which is approved to transfer this token.
    pub fn approved(self) -> Option<Identity> {
        self.approved
    }

    /// Returns whether the `operator` user is approved to transfer all tokens on this owner's behalf.
    ///
    /// # Arguments
    ///
    /// * `operator` - The user which may or may not transfer all tokens on the owner`s behalf.
    #[storage(read)]
    pub fn is_approved_for_all(self, operator: Identity) -> bool {
        get::<bool>(sha256((OPERATOR_APPROVAL, self.owner, operator)))
    }

    /// Mints a token to the `to` Identity with a id.
    ///
    /// # Arguments
    ///
    /// * `to` - The user which will own the minted token.
    /// * `token_id` - The id the new token will have.
    ///
    /// # Reverts
    ///
    /// * When the `token_id` is used by another token
    #[storage(read, write)]
    pub fn mint(to: Identity, token_id: u64) -> Self {
        require(get::<Option<NFTCore>>(sha256((TOKENS, token_id))).is_none(), InputError::TokenAlreadyExists);

        let nft = NFTCore {
            approved: Option::None(),
            owner: to,
            token_id,
        };

        store(sha256((TOKENS, token_id)), Option::Some(nft));
        store(TOKENS_MINTED, get::<u64>(TOKENS_MINTED) + 1);
        store(sha256((BALANCES, to)), get::<u64>(sha256((BALANCES, to))) + 1);

        log(MintEvent {
            owner: to,
            token_id,
        });

        nft
    }

    /// Returns the user which owns this token.
    pub fn owner(self) -> Identity {
        self.owner
    }

    /// Gives the `operator` approval to transfer ALL tokens owned by this owner.
    ///
    /// This can be dangerous. If a malicous user is set as an operator to another user, they could
    /// drain their wallet.
    ///
    /// # Arguments
    ///
    /// * `approve` - Represents whether the user is giving or revoking operator status.
    /// * `operator` - The user which may or may not transfer all tokens on this owner's behalf.
    ///
    /// # Reverts
    ///
    /// * When the sender is not the owner of this token
    #[storage(write)]
    pub fn set_approval_for_all(self, approve: bool, operator: Identity) {
        let sender = msg_sender().unwrap();
        require(self.owner == sender, AccessError::SenderNotOwner);

        store(sha256((OPERATOR_APPROVAL, self.owner, operator)), approve);

        log(OperatorEvent {
            approved: approve,
            owner: self.owner,
            operator,
        });
    }

    /// Transfers ownership of this token from one user to another.
    ///
    /// Transfers can occur under one of three conditions:
    /// 1. This token's owner is transfering the token.
    /// 2. This token's approved user is transfering the token.
    /// 3. This token's owner has a user set as an operator and is transfering the token.
    ///
    /// # Arguments
    ///
    /// * `to` - The user which the ownership of this token should be set to.
    ///
    /// # Reverts
    ///
    /// * When the sender is not the owner of this token.
    /// * When the sender is not approved to transfer this token on the owner's behalf.
    /// * When the sender is not approved to transfer all tokens on the owner's behalf.
    #[storage(read, write)]
    pub fn transfer(self, to: Identity) -> Self {
        let mut nft = self;
        let from = nft.owner;
        let sender = msg_sender().unwrap();
        let operator_approved = get::<bool>(sha256((OPERATOR_APPROVAL, from, sender)));

        // Ensure that the sender is either:
        // 1. The owner of this token
        // 2. Approved for transfer of this token
        // 3. Has operator approval from the owner and this token belongs to the sender identity
        require(sender == from || (self.approved.is_some() && sender == self.approved.unwrap()) || operator_approved, AccessError::SenderNotOwnerOrApproved);

        // Set the new owner of this token and reset the approved Identity
        nft.owner = to;
        if self.approved.is_some() {
            nft.approved = Option::None();
        }

        store(sha256((TOKENS, self.token_id)), Option::Some(nft));

        let from_balance = get::<u64>(sha256((BALANCES, from)));
        let to_balance = get::<u64>(sha256((BALANCES, to)));
        store(sha256((BALANCES, from)), from_balance - 1);
        store(sha256((BALANCES, to)), to_balance + 1);

        log(TransferEvent {
            from,
            sender,
            to,
            token_id: self.token_id,
        });

        nft
    }
}
