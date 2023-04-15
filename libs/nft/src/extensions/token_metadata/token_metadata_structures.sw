library;

pub struct NFTMetadata {
    // This is left as an example. Support for StorageVec in struct is needed here.
    // Developers may also implement their own metadata structs with properties they may need
    // and use the MetaData trait.
    value: u64,
}

impl NFTMetadata {
    fn new(value: u64) -> Self {
        Self { value }
    }
}
