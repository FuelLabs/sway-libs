use crate::merkle_proof::tests::utils::{
    abi_calls::leaf_digest,
    test_helpers::{build_tree, merkle_proof_instance},
};
use fuel_merkle::common::Bytes32;
use fuels::prelude::Bits256;
use sha2::{Digest, Sha256};

mod success {

    use super::*;

    #[tokio::test]
    async fn computes_leaf() {
        let instance = merkle_proof_instance().await;

        let mut leaves: Vec<[u8; 1]> = Vec::new();
        leaves.push("A".as_bytes().try_into().unwrap());
        leaves.push("B".as_bytes().try_into().unwrap());
        leaves.push("C".as_bytes().try_into().unwrap());
        let key = 0;
        let (_tree, _root, leaf, _proof) = build_tree(leaves.clone(), key).await;

        let mut hasher1 = Sha256::new();
        hasher1.update(&leaves[key as usize]);
        let data_hash: Bytes32 = hasher1.finalize().try_into().unwrap();

        assert_eq!(leaf_digest(&instance, Bits256(data_hash)).await, leaf);
    }
}
