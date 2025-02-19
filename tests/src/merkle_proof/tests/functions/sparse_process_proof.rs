use crate::merkle_proof::tests::utils::{
    abi_calls::sparse_process_proof,
    test_helpers::{build_sparse_tree, leaves_with_depth, merkle_proof_instance},
};

mod success {

    use super::*;

    #[tokio::test]
    async fn fails_to_process_merkle_proof() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, leaf) = build_sparse_tree(leaves.clone(), key).await;

        assert_ne!(
            sparse_process_proof(&instance, key + 1, leaf, proof).await,
            root
        );
    }

    #[tokio::test]
    async fn processes_merkle_proof() {
        let instance = merkle_proof_instance().await;

        let depth = 16;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, leaf) = build_sparse_tree(leaves.clone(), key).await;

        assert_eq!(
            sparse_process_proof(&instance, key, leaf, proof).await,
            root
        );
    }

    #[tokio::test]
    async fn processes_merkle_proof_complete_tree() {
        let instance = merkle_proof_instance().await;

        let depth = 16;
        let mut leaves = leaves_with_depth(depth).await;
        let key = 0;
        let length = leaves.len() / 3;

        leaves.truncate(length);

        let (tree, root, leaf) = build_sparse_tree(leaves.clone(), key).await;

        assert_eq!(
            sparse_process_proof(&instance, key, leaf, proof).await,
            root
        );
    }

    #[tokio::test]
    async fn processes_merkle_proof_key_is_num_leaves() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = (leaves.len() - 1) as u64;

        let (tree, root, leaf) = build_sparse_tree(leaves.clone(), key).await;

        assert_eq!(
            sparse_process_proof(&instance, key, leaf, proof).await,
            root
        );
    }

    #[tokio::test]
    async fn processes_merkle_proof_key_is_half_num_leaves() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = (leaves.len() / 2) as u64;

        let (tree, root, leaf) = build_sparse_tree(leaves.clone(), key).await;

        assert_eq!(
            sparse_process_proof(&instance, key, leaf, proof).await,
            root
        );
    }
}

mod revert {

    use super::*;

    #[tokio::test]
    #[should_panic(expected = "InvalidProofLength")]
    async fn when_invalid_proof_length_given() {
        let instance = merkle_proof_instance().await;

        let mut leaves: Vec<[u8; 1]> = Vec::new();
        leaves.push("A".as_bytes().try_into().unwrap());
        leaves.push("B".as_bytes().try_into().unwrap());
        leaves.push("C".as_bytes().try_into().unwrap());
        let num_leaves = 3;
        let key = 0;

        let (tree, root, leaf) = build_sparse_tree(leaves, key).await;

        assert_eq!(
            sparse_process_proof(&instance, key, leaf, [].to_vec()).await,
            root
        );
    }

    #[tokio::test]
    #[should_panic(expected = "InvalidProofLength")]
    async fn when_invalid_num_leaves_given() {
        let instance = merkle_proof_instance().await;

        let mut leaves: Vec<[u8; 1]> = Vec::new();
        leaves.push("A".as_bytes().try_into().unwrap());
        leaves.push("B".as_bytes().try_into().unwrap());
        leaves.push("C".as_bytes().try_into().unwrap());
        let num_leaves = 1;
        let key = 0;

        let (tree, root, leaf) = build_sparse_tree(leaves, key).await;

        assert_eq!(
            sparse_process_proof(&instance, key, leaf, proof).await,
            root
        );
    }

    #[tokio::test]
    #[should_panic(expected = "InvalidProofLength")]
    async fn when_key_greater_or_equal_to_num_leaves() {
        let instance = merkle_proof_instance().await;

        let mut leaves: Vec<[u8; 1]> = Vec::new();
        leaves.push("A".as_bytes().try_into().unwrap());
        leaves.push("B".as_bytes().try_into().unwrap());
        leaves.push("C".as_bytes().try_into().unwrap());
        let num_leaves = 3;
        let mut key = 0;

        let (tree, _root, leaf) = build_sparse_tree(leaves, key).await;
        key = num_leaves;

        sparse_process_proof(&instance, key, leaf, proof).await;
    }

    #[tokio::test]
    #[should_panic(expected = "InvalidKey")]
    async fn when_key_equal_num_leaves_length() {
        let instance = merkle_proof_instance().await;

        let mut leaves: Vec<[u8; 1]> = Vec::new();
        leaves.push("A".as_bytes().try_into().unwrap());
        leaves.push("B".as_bytes().try_into().unwrap());
        leaves.push("C".as_bytes().try_into().unwrap());
        let num_leaves = 4;
        let key = 0;

        let (tree, _root, leaf) = build_sparse_tree(leaves, key).await;

        sparse_process_proof(&instance, num_leaves, leaf, proof).await;
    }

    #[tokio::test]
    #[should_panic(expected = "InvalidKey")]
    async fn when_key_greater_than_num_leaves_length() {
        let instance = merkle_proof_instance().await;

        let mut leaves: Vec<[u8; 1]> = Vec::new();
        leaves.push("A".as_bytes().try_into().unwrap());
        leaves.push("B".as_bytes().try_into().unwrap());
        leaves.push("C".as_bytes().try_into().unwrap());
        let num_leaves = 4;
        let mut key = 0;

        let (tree, _root, leaf) = build_sparse_tree(leaves, key).await;
        key = num_leaves + 1;

        sparse_process_proof(&instance, key, leaf, proof).await;
    }

    #[tokio::test]
    #[should_panic(expected = "InvalidProofLength")]
    async fn when_num_leaves_zero() {
        let instance = merkle_proof_instance().await;

        let mut leaves: Vec<[u8; 1]> = Vec::new();
        leaves.push("A".as_bytes().try_into().unwrap());
        leaves.push("B".as_bytes().try_into().unwrap());
        leaves.push("C".as_bytes().try_into().unwrap());
        let num_leaves = 0;
        let key = 0;

        let (tree, _root, leaf) = build_sparse_tree(leaves, key).await;

        sparse_process_proof(&instance, key, leaf, proof).await;
    }
}