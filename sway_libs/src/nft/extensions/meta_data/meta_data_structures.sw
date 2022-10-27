library meta_data_structures;

pub struct NFTMetaData {
    // This is left as an example. Support for StorageVec in struct is needed here
    name: str[7],
}

impl NFTMetaData {
    fn new() -> Self {
        Self {
            name: "Example",
        }
    }
}
