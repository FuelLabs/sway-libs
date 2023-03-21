library fuel_nft_standard;


/**
The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”,
“SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be
interpreted as described in RFC 2119: https://www.ietf.org/rfc/rfc2119.txt
*/

/// This is logged when the approved Identity for an NFT is changed or
/// Option::None indicates there is no approved Identity.
pub struct ApprovalEvent {
    approved: Option<Identity>,
    owner: Identity,
    token_id: u64,
}


/// This is logged when an operator is enabled or disabled for an owner.
/// The operator can manage all NFTs of the owner.
pub struct OperatorEvent {
    approved: bool,
    operator: Identity,
    owner: Identity,
}

/// This is logged when ownership of any NFT changes via the 'transfer' function.
/// At the time of a transfer, the approved Identity for that NFT (if any) is reset to Option::None.
pub struct TransferEvent {
    from: Identity,
    sender: Identity,
    to: Identity,
    token_id: u64,
}

abi NFT {
    /// Transfer ownership of an NFT.
    ///
    /// -- THE CALLER IS RESPONSIBLE
    /// FOR CONFIRMING THAT `to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    /// THEY MAY BE PERMANENTLY LOST! --
    ///  
    /// # Arguments
    /// 
    /// * `to` - The user which the ownership of this token should be set to. 
    ///
    /// # Reverts
    ///
    /// * When `msg_sender()` is not the owner of this token.
    /// * When `msg_sender()` is not approved to transfer this token on the owner's behalf.
    /// * When `msg_sender()` is not approved to transfer all tokens on the owner's behalf.    
    fn transfer(to: Identity, token_id: u64);

    /// Set or reafirm the approved Identity for an NFT.
    ///
    /// # Arguments
    ///
    /// * `approved` - The approved NFT controller, or Option::None.
    /// * `token_id` - The NFT to approve.
    ///
    /// # Reverts
    ///
    /// * When `msg_sender()` is not the owner of (or an approved Operator for) this NFT. 
    fn approve(approved: Option<Identity>, token_id: u64);

    /// Enable or disable approval for a third party "Operator" to manages all
    /// of `msg_sender()`'s NFTs.
    /// 
    /// -- The contract MUST allow multiple operators per owner. --
    ///
    /// # Arguments
    ///
    /// * `approve` - True if the operator is approved, false to revoke approval.
    /// * `operator` - Identity to add to the set of authorized operators.
    /// 
    /// # Events
    ///
    /// * Emits the ApprovalForAll event.   
    fn set_approval_for_all(approve: bool, operator: Identity);

    /// Get the approved Identity for a single NFT
    /// 
    /// # Arguments
    /// 
    /// * `token_id` - The NFT to find the approved Identity for.
    ///
    /// # Reverts
    /// 
    /// * When `token_id` is not a valid NFT
    fn approved(token_id: u64) -> Option<Identity>;

    /// The number of NFTs owner by an Identity.
    /// 
    /// # Arguments
    ///
    /// * `owner` - The Identity fo which to query the balance. 
    fn balance_of(owner: Identity) -> u64;

    /// Query if an Identity is an authorized operator for another Identity.
    ///
    /// # Arguments
    /// 
    /// * `operator` - The Identity that acts on behalf of the owner.
    /// * `owner` - The Identity that owns the NFT/NFTs.
    fn is_approved_for_all(operator: Identity, owner: Identity) -> bool;

    /// Query the owner of an NFT.
    ///
    /// # Arguments
    /// 
    /// * `token_id` - The NFT to fing the owner for.
    fn owner_of(token_id: u64) -> Option<Identity>;
}
