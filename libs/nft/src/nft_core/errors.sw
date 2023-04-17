library;

pub enum AccessError {
    OwnerDoesNotExist: (),
    SenderNotOwner: (),
    SenderNotOwnerOrApproved: (),
}

pub enum InputError {
    TokenAlreadyExists: (),
    TokenDoesNotExist: (),
}
