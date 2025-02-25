use crate::merkle_proof::tests::utils::{
    abi_calls::{sparse_verify, sparse_verify_hash},
    test_helpers::{build_sparse_tree, fuel_to_sway_sparse_proof, sparse_proof, leaves_with_depth, merkle_proof_instance},
};
use fuels::types::Bits256;
use fuel_merkle::sparse::MerkleTreeKey as SparseTreeKey;
use sha2::{Digest, Sha256};

mod success {

    use super::*;

    #[tokio::test]
    async fn fails_inclusion_verification() {
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
            sparse_verify(&instance, invalid_key, Some(leaf), root, proof).await,
            false
        );
    }

    #[tokio::test]
    async fn fails_inclusion_verification_from_hash() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let fuel_proof = sparse_proof(tree, leaf_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());
        let invalid_key = Bits256::zeroed();

        let mut hasher = Sha256::new();
        hasher.update(&leaf.0);
        let hashed_leaf: [u8; 32] = hasher.finalize().into();

        assert!(fuel_proof.is_inclusion());
        assert_eq!(
            sparse_verify_hash(&instance, invalid_key, Bits256(hashed_leaf), root, proof).await,
            false
        );
    }

    #[tokio::test]
    async fn fails_exclusion_verification() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, _leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let empty_key = SparseTreeKey::new([1u8; 32]);
        let fuel_proof = sparse_proof(tree, empty_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_exclusion());
        assert_eq!(
            sparse_verify(&instance, Bits256(*leaf_key.as_ref()), None, root, proof).await,
            false
        );
    }

    #[tokio::test]
    async fn verifies_inclusion_proof() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let fuel_proof = sparse_proof(tree, leaf_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_inclusion());
        assert_eq!(
            sparse_verify(&instance, Bits256(*leaf_key.as_ref()), Some(leaf), root, proof).await,
            true
        );
    }

    #[tokio::test]
    async fn verifies_inclusion_proof_from_hash() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let fuel_proof = sparse_proof(tree, leaf_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        let mut hasher = Sha256::new();
        hasher.update(&leaf.0);
        let hashed_leaf: [u8; 32] = hasher.finalize().into();

        assert!(fuel_proof.is_inclusion());
        assert_eq!(
            sparse_verify_hash(&instance, Bits256(*leaf_key.as_ref()), Bits256(hashed_leaf), root, proof).await,
            true
        );
    }

    #[tokio::test]
    async fn verifies_exclusion_proof() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, _leaf, _leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let empty_key = SparseTreeKey::new([1u8; 32]);
        let fuel_proof = sparse_proof(tree, empty_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_exclusion());
        assert_eq!(
            sparse_verify(&instance, Bits256(*empty_key.as_ref()), None, root, proof).await,
            true
        );
    }
}

mod revert {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "NoLeafData")]
    async fn when_no_leaf_in_inclusion_proof() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, _leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let fuel_proof = sparse_proof(tree, leaf_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_inclusion());
        let _ = sparse_verify(&instance, Bits256(*leaf_key.as_ref()), None, root, proof).await;
    }

    #[tokio::test]
    #[should_panic(expected = "LeafData")]
    async fn when_leaf_in_exclusion_proof() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, leaf, _leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let empty_key = SparseTreeKey::new([1u8; 32]);
        let fuel_proof = sparse_proof(tree, empty_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_exclusion());
        let _ = sparse_verify(&instance, Bits256(*empty_key.as_ref()), Some(leaf), root, proof).await;
    }

}