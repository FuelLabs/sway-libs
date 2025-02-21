use crate::merkle_proof::tests::utils::{
    abi_calls::sparse_verify_proof,
    test_helpers::{build_sparse_tree, fuel_to_sway_sparse_proof, sparse_proof, leaves_with_depth, merkle_proof_instance},
};
use fuels::types::Bits256;

mod success {

    use super::*;

    #[tokio::test]
    async fn fails_merkle_proof_verification() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let fuel_proof = sparse_proof(tree, leaf_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());
        let invalid_key = Bits256::zeroed();

        assert!(fuel_proof.is_inclusion());
        assert_eq!(
            sparse_verify_proof(&instance, invalid_key, Some(leaf), root, proof).await,
            false
        );
    }

    #[tokio::test]
    async fn verifies_merkle_proof() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let fuel_proof = sparse_proof(tree, leaf_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_inclusion());
        assert_eq!(
            sparse_verify_proof(&instance, Bits256(*leaf_key.as_ref()), Some(leaf), root, proof).await,
            true
        );
    }
}