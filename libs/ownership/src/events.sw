library events;

pub struct OwnershipRenounced {
    previous_owner: Identity,
}

pub struct OwnershipSet {
    new_owner: Identity,
}

pub struct OwnershipTransferred {
    new_owner: Identity,
    previous_owner: Identity,
}
