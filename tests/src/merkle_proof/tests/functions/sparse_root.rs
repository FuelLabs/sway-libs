use crate::merkle_proof::tests::utils::{
    abi_calls::{sparse_root, sparse_root_hash},
    test_helpers::{
        build_sparse_tree, fuel_to_sway_sparse_proof, leaves_with_depth, merkle_proof_instance,
        sparse_proof,
    },
};
use fuel_merkle::sparse::MerkleTreeKey as SparseTreeKey;
use fuels::types::Bits256;
use sha2::{Digest, Sha256};

mod success {

    use super::*;

    #[tokio::test]
    async fn fails_to_compute_inclusion_root() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let fuel_proof = sparse_proof(tree, leaf_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());
        let invalid_key = Bits256::zeroed();

        assert!(fuel_proof.is_inclusion());
        assert_ne!(
            sparse_root(&instance, invalid_key, Some(leaf), proof).await,
            root
        );
    }

    #[tokio::test]
    async fn fails_to_compute_inclusion_root_from_hash() {
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
        assert_ne!(
            sparse_root_hash(&instance, invalid_key, Bits256(hashed_leaf), proof).await,
            root
        );
    }

    #[tokio::test]
    async fn fails_to_compute_exclusion_root() {
        let instance = merkle_proof_instance().await;

        let depth = 16;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, _leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;

        let empty_key = SparseTreeKey::new([1u8; 32]);
        let fuel_proof = sparse_proof(tree, empty_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_exclusion());
        assert_ne!(
            sparse_root(&instance, Bits256(*leaf_key.as_ref()), None, proof).await,
            root
        );
    }

    #[tokio::test]
    async fn compute_inclusion_root() {
        let instance = merkle_proof_instance().await;

        let depth = 16;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let fuel_proof = sparse_proof(tree, leaf_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_inclusion());
        assert_eq!(
            sparse_root(&instance, Bits256(*leaf_key.as_ref()), Some(leaf), proof).await,
            root
        );
    }

    #[tokio::test]
    async fn compute_exclusion_root() {
        let instance = merkle_proof_instance().await;

        let depth = 16;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, _leaf, _leaf_key) = build_sparse_tree(leaves.clone(), key).await;

        let empty_key = SparseTreeKey::new([1u8; 32]);
        let fuel_proof = sparse_proof(tree, empty_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_exclusion());
        assert_eq!(
            sparse_root(&instance, Bits256(*empty_key.as_ref()), None, proof).await,
            root
        );
    }

    #[tokio::test]
    async fn compute_exclusion_root_simnilar_leaf() {
        let instance = merkle_proof_instance().await;

        let depth = 16;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, _leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;

        let mut new_key_bits: [u8; 32] = *leaf_key.as_ref();
        new_key_bits[0] = 0u8;

        let false_key = SparseTreeKey::new(new_key_bits);
        let fuel_proof = sparse_proof(tree, false_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_exclusion());
        assert_eq!(
            sparse_root(&instance, Bits256(*false_key.as_ref()), None, proof).await,
            root
        );
    }

    #[tokio::test]
    async fn compute_inclusion_root_complete_tree() {
        let instance = merkle_proof_instance().await;

        let depth = 16;
        let mut leaves = leaves_with_depth(depth).await;
        let key = 0;
        let length = leaves.len() / 3;

        leaves.truncate(length);

        let (tree, root, leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let fuel_proof = sparse_proof(tree, leaf_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_inclusion());
        assert_eq!(
            sparse_root(&instance, Bits256(*leaf_key.as_ref()), Some(leaf), proof).await,
            root
        );
    }

    #[tokio::test]
    async fn compute_exclusion_proof_complete_tree() {
        let instance = merkle_proof_instance().await;

        let depth = 16;
        let mut leaves = leaves_with_depth(depth).await;
        let key = 0;
        let length = leaves.len() / 3;

        leaves.truncate(length);

        let (tree, root, _leaf, _leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let empty_key = SparseTreeKey::new([1u8; 32]);
        let fuel_proof = sparse_proof(tree, empty_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_exclusion());
        assert_eq!(
            sparse_root(&instance, Bits256(*empty_key.as_ref()), None, proof).await,
            root
        );
    }

    #[tokio::test]
    async fn compute_inclusion_root_key_is_max() {
        let instance = merkle_proof_instance().await;

        let depth = 16;
        let leaves = leaves_with_depth(depth).await;
        let key = (leaves.len() - 1) as u64;

        let (tree, root, leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let fuel_proof = sparse_proof(tree, leaf_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_inclusion());
        assert_eq!(
            sparse_root(&instance, Bits256(*leaf_key.as_ref()), Some(leaf), proof).await,
            root
        );
    }

    #[tokio::test]
    async fn compute_exclusion_root_key_is_max() {
        let instance = merkle_proof_instance().await;

        let depth = 16;
        let leaves = leaves_with_depth(depth).await;
        let key = (leaves.len() - 1) as u64;

        let (tree, root, _leaf, _leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let empty_key = SparseTreeKey::new([u8::MAX; 32]);
        let fuel_proof = sparse_proof(tree, empty_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_exclusion());
        assert_eq!(
            sparse_root(&instance, Bits256(*empty_key.as_ref()), None, proof).await,
            root
        );
    }

    #[tokio::test]
    async fn compute_inclusion_root_leaves_is_half() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = (leaves.len() / 2) as u64;

        let (tree, root, leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let fuel_proof = sparse_proof(tree, leaf_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_inclusion());
        assert_eq!(
            sparse_root(&instance, Bits256(*leaf_key.as_ref()), Some(leaf), proof).await,
            root
        );
    }

    #[tokio::test]
    async fn compute_exclusion_root_leaves_is_half() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = (leaves.len() / 2) as u64;

        let (tree, root, _leaf, _leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let empty_key = SparseTreeKey::new([u8::MAX / 2u8; 32]);
        let fuel_proof = sparse_proof(tree, empty_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_exclusion());
        assert_eq!(
            sparse_root(&instance, Bits256(*empty_key.as_ref()), None, proof).await,
            root
        );
    }
}

mod revert {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "NoLeafData")]
    async fn when_no_leaf_in_inclusion_proof() {
        let instance = merkle_proof_instance().await;

        let depth = 16;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, _root, _leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let fuel_proof = sparse_proof(tree, leaf_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_inclusion());
        let _ = sparse_root(&instance, Bits256(*leaf_key.as_ref()), None, proof).await;
    }

    #[tokio::test]
    #[should_panic(expected = "LeafData")]
    async fn when_leaf_in_exclusion_proof() {
        let instance = merkle_proof_instance().await;

        let depth = 16;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, _root, leaf, _leaf_key) = build_sparse_tree(leaves.clone(), key).await;

        let empty_key = SparseTreeKey::new([1u8; 32]);
        let fuel_proof = sparse_proof(tree, empty_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_exclusion());
        let _ = sparse_root(&instance, Bits256(*empty_key.as_ref()), Some(leaf), proof).await;
    }
}
