library burnable_events;
pub struct BurnEvent {
    /// The user that has burned their token.
    owner: Identity,
    /// The unique identifier of the token which has been burned.
    token_id: u64,
}
