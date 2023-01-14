library errors;

pub enum AccessError {
    CannotReinitialized: (),
    NotOwner: (),
}
