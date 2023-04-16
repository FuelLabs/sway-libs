library;

pub struct AdminEvent {
    /// The user which is now the admin of this contract.
    admin: Option<Identity>,
}
