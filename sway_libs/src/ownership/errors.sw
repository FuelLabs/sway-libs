library errors;

pub enum AccessError {
    NotOwner: (),
    OwnerExists: (),
}
