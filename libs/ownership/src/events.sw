library;

/// Logged when ownership is renounced.
pub struct OwnershipRenounced {
    /// The user which revoked the ownership.
    previous_owner: Identity,
}

/// Logged when ownership is given to a user.
pub struct OwnershipSet {
    /// The user which is now the owner.
    new_owner: Identity,
}

/// Logged when ownership is given from one user to another.
pub struct OwnershipTransferred {
    /// The user which is now the owner.
    new_owner: Identity,
    /// The user which has given up their ownership.
    previous_owner: Identity,
}
