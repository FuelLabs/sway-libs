library frc721;

/**
The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”,
“SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be
interpreted as described in RFC 2119: https://www.ietf.org/rfc/rfc2119.txt
*/

/// This event MUST be logged when the approved Identity for an NFT is changed or modified.
/// Option::None indicates there is no approved Identity.
pub struct ApprovalEvent {
    approved: Option<Identity>,
    owner: Identity,
    token_id: u64,

}

/// This event MUST be logged when an operator is enabled or disabled for an owner.
/// The operator can manage all NFTs of the owner.
pub struct OperatorEvent {
    approved: bool,
    operator: Identity,
    owner: Identity,
}

/// This event MUST be logged when ownership of any NFT changes.
/// Exception: Cases where there is no new or previous owner, formally known as minting and burning,
/// the event SHALL NOT be logged.
pub struct TransferEvent {
    from: Identity,
    sender: Identity,
    to: Identity,
    token_id: u64,
}

abi FRC721 {
    /// Transfer ownership of an NFT from on Identity to another.
    /// At the time of a transfer, the approved Identity for that NFT (if any) MUST be reset to Option::None.
    ///
    /// -- THE CALLER IS RESPONSIBLE
    /// FOR CONFIRMING THAT `to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    /// THEY MAY BE PERMANENTLY LOST! --
    ///
    /// # Arguments
    ///
    /// * `to` - The Identity which the ownership of this token SHALL be set to.
    /// * `token_id` - The token of which ownership SHALL change.
    ///
    /// # Reverts
    ///
    /// * It is REQUIRED that `msg_sender()` is not the owner of this token.
    /// * It is REQUIRED that `msg_sender()` is not approved to transfer this token on the owner's behalf.
    /// * It is REQUIRED that `msg_sender()` is not approved to transfer all tokens on the owner's behalf.
    ///
    /// # Events
    ///
    /// * The TransferEvent event MUST be emitted when the function is not reverted.
    fn transfer(to: Identity, token_id: u64);

    /// Set or reafirm the approved Identity for an NFT.
    /// The approved Identity for the specified NFT MAY transfer the token to a new owner.
    ///
    /// # Arguments
    ///
    /// * `approved` - The Identity that SHALL be approved as an NFT controller, or Option::None.
    /// * `token_id` - The token of which the NFT approval SHALL change.
    ///
    /// # Reverts
    ///
    /// * It is REQUIRED that `msg_sender()` is the owner of (or an approved Operator for) this NFT.
    ///
    /// # Events
    ///
    /// * The ApprovalEvent event MUST be emitted when the function is not reverted.
    fn approve(approved: Option<Identity>, token_id: u64);
    
    /// Enable or disable approval for a third party "Operator" to manages all
    /// of `msg_sender()`'s NFTs.
    /// An operator for an Identity MAY transfer and MAY set approved Identities for all tokens
    /// owned by the `msg_sender()`.
    ///
    /// -- The contract MUST allow multiple operators per owner. --
    ///
    /// # Arguments
    ///
    /// * `approve` - MUST be `True` if the operator is approved and MUST be `False` to revoke approval.
    /// * `operator` - The Identity that SHALL be added to the set of authorized operators.
    ///
    /// # Events
    ///
    /// * The OperatorEvent event MUST be emitted.
    fn set_approval_for_all(approve: bool, operator: Identity);
   
    /// Get the approved Identity for a single NFT.
    /// Option::None indicates there is no approved Identity.
    ///
    /// # Arguments
    ///
    /// * `token_id` - The NFT to find the approved Identity for.
    ///
    /// # Reverts
    ///
    /// * It is REQUIRED that `token_id` is valid NFT.
    fn approved(token_id: u64) -> Option<Identity>;
   
    /// The number of NFTs owner by an Identity.
    ///
    /// # Arguments
    ///
    /// * `owner` - The Identity of which to query the balance.
    fn balance_of(owner: Identity) -> u64;

    /// Query if an Identity is an authorized operator for another Identity.
    ///
    /// # Arguments
    ///
    /// * `operator` - The Identity that acts on behalf of the owner.
    /// * `owner` - The Identity that owns the NFT/NFTs.
    fn is_approved_for_all(operator: Identity, owner: Identity) -> bool;
   
    /// Query the owner of an NFT.
    /// Option::None indicates there is no owner Identity.
    ///
    /// # Arguments
    ///
    /// * `token_id` - The NFT to find the owner for.
    ///
    /// # Reverts
    ///
    /// * It is REQUIRED that `token_id` is valid NFT.
    fn owner_of(token_id: u64) -> Option<Identity>;
}
