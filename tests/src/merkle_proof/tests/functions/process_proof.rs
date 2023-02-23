use crate::merkle_proof::tests::utils::{
    abi_calls::process_proof,
    test_helpers::{build_tree, build_tree_manual, leaves_with_depth, merkle_proof_instance},
};

mod success {

    use super::*;

    #[tokio::test]
    async fn fails_to_process_merkle_proof() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (_tree, root, leaf, proof) = build_tree(leaves.clone(), key).await;

        assert_ne!(
            process_proof(&instance, key + 1, leaf, leaves.len() as u64, proof).await,
            root
        );
    }

    #[tokio::test]
    async fn processes_merkle_proof() {
        let instance = merkle_proof_instance().await;

        let depth = 16;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (_tree, root, leaf, proof) = build_tree(leaves.clone(), key).await;

        assert_eq!(
            process_proof(&instance, key, leaf, leaves.len() as u64, proof).await,
            root
        );
    }

    #[tokio::test]
    async fn processes_merkle_proof_not_full_tree() {
        let instance = merkle_proof_instance().await;

        let depth = 16;
        let mut leaves = leaves_with_depth(depth).await;
        let key = 0;
        let length = leaves.len() / 3;

        leaves.truncate(length);

        let (_tree, root, leaf, proof) = build_tree(leaves.clone(), key).await;

        assert_eq!(
            process_proof(&instance, key, leaf, leaves.len() as u64, proof).await,
            root
        );
    }

    #[tokio::test]
    async fn processes_merkle_proof_key_is_num_leaves() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = (leaves.len() - 1) as u64;

        let (_tree, root, leaf, proof) = build_tree(leaves.clone(), key).await;

        assert_eq!(
            process_proof(&instance, key, leaf, leaves.len() as u64, proof).await,
            root
        );
    }

    #[tokio::test]
    async fn processes_merkle_proof_key_is_half_num_leaves() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = (leaves.len() / 2) as u64;

        let (_tree, root, leaf, proof) = build_tree(leaves.clone(), key).await;

        assert_eq!(
            process_proof(&instance, key, leaf, leaves.len() as u64, proof).await,
            root
        );
    }

    // This test does not use the Fuel-Merkle library but replicates it's functionality
    #[tokio::test]
    async fn processes_merkle_proof_manual() {
        let instance = merkle_proof_instance().await;

        // Data as bytes
        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;
        let (leaf_hash, proof, root_hash) =
            build_tree_manual(leaves.clone(), depth.try_into().unwrap(), key).await;

        assert_eq!(
            process_proof(
                &instance,
                key.try_into().unwrap(),
                leaf_hash,
                leaves.len().try_into().unwrap(),
                proof
            )
            .await,
            root_hash
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

        let (_tree, root, leaf, _proof) = build_tree(leaves, key).await;

        assert_eq!(
            process_proof(&instance, key, leaf, num_leaves, [].to_vec()).await,
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

        let (_tree, root, leaf, proof) = build_tree(leaves, key).await;

        assert_eq!(
            process_proof(&instance, key, leaf, num_leaves, proof).await,
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

        let (_tree, _root, leaf, proof) = build_tree(leaves, key).await;
        key = num_leaves;

        process_proof(&instance, key, leaf, num_leaves, proof).await;
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

        let (_tree, _root, leaf, proof) = build_tree(leaves, key).await;

        process_proof(&instance, num_leaves, leaf, num_leaves, proof).await;
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

        let (_tree, _root, leaf, proof) = build_tree(leaves, key).await;
        key = num_leaves + 1;

        process_proof(&instance, key, leaf, num_leaves, proof).await;
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

        let (_tree, _root, leaf, proof) = build_tree(leaves, key).await;

        process_proof(&instance, key, leaf, num_leaves, proof).await;
    }
}
