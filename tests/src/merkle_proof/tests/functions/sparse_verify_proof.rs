use crate::merkle_proof::tests::utils::{
    abi_calls::sparse_verify_proof,
    test_helpers::{build_sparse_tree, leaves_with_depth, merkle_proof_instance},
};

mod success {

    use super::*;

    #[tokio::test]
    async fn fails_merkle_proof_verification() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, leaf, proof) = build_sparse_tree(leaves.clone(), key).await;

        assert_eq!(
            sparse_verify_proof(&instance, key + 1, leaf, proof, root).await,
            false
        );
    }

    #[tokio::test]
    async fn verifies_merkle_proof() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, leaf, proof) = build_sparse_tree(leaves.clone(), key).await;

        assert_eq!(
            sparse_verify_proof(&instance, key, leaf, proof, root).await,
            true
        );
    }
}