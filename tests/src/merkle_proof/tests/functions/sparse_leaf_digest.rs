use crate::merkle_proof::tests::utils::{
    abi_calls::sparse_leaf_digest,
    test_helpers::{build_sparse_tree, merkle_proof_instance, sparse_leaf},
};
use fuel_merkle::common::Bytes32;
use fuels::types::Bits256;
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
        let (_tree, _root, leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let computed_leaf = sparse_leaf(leaf_key.as_ref(), &leaf.0);

        let mut hasher1 = Sha256::new();
        hasher1.update(&leaf.0);
        let data_hash: Bytes32 = hasher1.finalize().try_into().unwrap();

        assert_eq!(
            sparse_leaf_digest(&instance, Bits256(*leaf_key.as_ref()), Bits256(data_hash)).await,
            Bits256(computed_leaf)
        );
    }
}
