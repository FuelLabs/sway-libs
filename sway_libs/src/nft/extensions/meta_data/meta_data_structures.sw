library meta_data_structures;
pub struct NFTMetaData {
    // This is left as an example. Support for StorageVec in struct is needed here
    value: u64,
}
impl NFTMetaData {
    fn new(value: u64) -> Self {
        Self { value }
    }
}
