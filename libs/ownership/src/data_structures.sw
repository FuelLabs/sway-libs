library;

pub enum State {
    Uninitialized: (),
    Initialized: Identity,
    Revoked: (),
}

impl core::ops::Eq for State {
    fn eq(self, other: Self) -> bool {
        match (self, other) {
            (State::Initialized(owner1), State::Initialized(owner2)) => {
                owner1 == owner2
            },
            (State::Uninitialized, State::Uninitialized) => true,
            (State::Revoked, State::Revoked) => true,
            _ => false,
        }
    }
}
