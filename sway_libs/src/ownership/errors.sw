library errors;

pub enum AccessError {
    AlreadyInitialized: (),
    NotOwner: (),
}
