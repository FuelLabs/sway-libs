library;

/// Emitted when `_pause()` is called.
pub struct PauseEvent {
    /// The entity which paused the contract.
    caller: Identity,
}

/// Emitted when `_unpause()` is called.
pub struct UnpauseEvent {
    /// The entity which unpaused the contract.
    caller: Identity,
}

impl PauseEvent {
    pub fn new(caller: Identity) -> Self {
        Self {
            caller
        }
    }

    pub fn log(self) {
        log(self);
    }
}

impl PartialEq for PauseEvent {
    fn eq(self, other: Self) -> bool {
        self.caller == other.caller
    }
}

impl Eq for PauseEvent {}

impl UnpauseEvent {
    pub fn new(caller: Identity) -> Self {
        Self {
            caller
        }
    }

    pub fn log(self) {
        log(self);
    }
}

impl PartialEq for UnpauseEvent {
    fn eq(self, other: Self) -> bool {
        self.caller == other.caller
    }
}

impl Eq for UnpauseEvent {}
