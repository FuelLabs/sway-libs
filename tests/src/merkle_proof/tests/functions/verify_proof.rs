use crate::merkle_proof::tests::utils::{
    abi_calls::verify_proof,
    test_helpers::{build_tree, leaves_with_depth, merkle_proof_instance},
};

mod success {

    use super::*;

    #[tokio::test]
    async fn fails_merkle_proof_verification() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (_tree, root, leaf, proof) = build_tree(leaves.clone(), key).await;

        assert_eq!(
            verify_proof(&instance, key + 1, leaf, root, leaves.len() as u64, proof).await,
            false
        );
    }

    #[tokio::test]
    async fn verifies_merkle_proof() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (_tree, root, leaf, proof) = build_tree(leaves.clone(), key).await;

        assert_eq!(
            verify_proof(&instance, key, leaf, root, leaves.len() as u64, proof).await,
            true
        );
    }
}
