use crate::merkle_proof::tests::utils::{
    abi_calls::sparse_process_proof,
    test_helpers::{build_sparse_tree, fuel_to_sway_sparse_proof, sparse_proof, leaves_with_depth, merkle_proof_instance},
};
use fuels::types::Bits256;
use fuel_merkle::sparse::MerkleTreeKey as SparseTreeKey;

mod success {

    use super::*;

    #[tokio::test]
    async fn fails_to_process_merkle_proof() {
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
            sparse_process_proof(&instance, invalid_key, Some(leaf), proof).await,
            root
        );
    }

    #[tokio::test]
    async fn processes_merkle_proof() {
        let instance = merkle_proof_instance().await;

        let depth = 16;
        let leaves = leaves_with_depth(depth).await;
        let key = 0;

        let (tree, root, leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let fuel_proof = sparse_proof(tree, leaf_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());
        
        assert!(fuel_proof.is_inclusion());
        assert_eq!(
            sparse_process_proof(&instance, Bits256(*leaf_key.as_ref()), Some(leaf), proof).await,
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

        let (tree, root, leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let fuel_proof = sparse_proof(tree, leaf_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_inclusion());
        assert_eq!(
            sparse_process_proof(&instance, Bits256(*leaf_key.as_ref()), Some(leaf), proof).await,
            root
        );
    }

    #[tokio::test]
    async fn processes_merkle_proof_key_is_num_leaves() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = (leaves.len() - 1) as u64;

        let (tree, root, leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let fuel_proof = sparse_proof(tree, leaf_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_inclusion());
        assert_eq!(
            sparse_process_proof(&instance, Bits256(*leaf_key.as_ref()), Some(leaf), proof).await,
            root
        );
    }

    #[tokio::test]
    async fn processes_merkle_proof_key_is_half_num_leaves() {
        let instance = merkle_proof_instance().await;

        let depth = 8;
        let leaves = leaves_with_depth(depth).await;
        let key = (leaves.len() / 2) as u64;

        let (tree, root, leaf, leaf_key) = build_sparse_tree(leaves.clone(), key).await;
        let fuel_proof = sparse_proof(tree, leaf_key).await;
        let proof = fuel_to_sway_sparse_proof(fuel_proof.clone());

        assert!(fuel_proof.is_inclusion());
        assert_eq!(
            sparse_process_proof(&instance, Bits256(*leaf_key.as_ref()), Some(leaf), proof).await,
            root
        );
    }

    #[tokio::test]
    async fn processes_exclusion_merkle_proof() {
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
            sparse_process_proof(&instance, Bits256(*empty_key.as_ref()), None, proof).await,
            root
        );
    }

    #[tokio::test]
    async fn processes_exclusion_merkle_proof_key_similar() {
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
            sparse_process_proof(&instance, Bits256(*false_key.as_ref()), None, proof).await,
            root
        );
    }
}

// mod revert {

//     use super::*;

//     #[tokio::test]
//     #[should_panic(expected = "InvalidProofLength")]
//     #[ignore]
//     async fn when_invalid_proof_length_given() {
//         let instance = merkle_proof_instance().await;

//         let mut leaves: Vec<[u8; 1]> = Vec::new();
//         leaves.push("A".as_bytes().try_into().unwrap());
//         leaves.push("B".as_bytes().try_into().unwrap());
//         leaves.push("C".as_bytes().try_into().unwrap());
//         let num_leaves = 3;
//         let key = 0;

//         let (tree, root, leaf) = build_sparse_tree(leaves, key).await;

//         assert_eq!(
//             sparse_process_proof(&instance, key, leaf, [].to_vec()).await,
//             root
//         );
//     }

//     #[tokio::test]
//     #[ignore]
//     #[should_panic(expected = "InvalidProofLength")]
//     async fn when_invalid_num_leaves_given() {
//         let instance = merkle_proof_instance().await;

//         let mut leaves: Vec<[u8; 1]> = Vec::new();
//         leaves.push("A".as_bytes().try_into().unwrap());
//         leaves.push("B".as_bytes().try_into().unwrap());
//         leaves.push("C".as_bytes().try_into().unwrap());
//         let num_leaves = 1;
//         let key = 0;

//         let (tree, root, leaf) = build_sparse_tree(leaves, key).await;

//         assert_eq!(
//             sparse_process_proof(&instance, key, leaf, proof).await,
//             root
//         );
//     }

//     #[tokio::test]
//     #[ignore]
//     #[should_panic(expected = "InvalidProofLength")]
//     async fn when_key_greater_or_equal_to_num_leaves() {
//         let instance = merkle_proof_instance().await;

//         let mut leaves: Vec<[u8; 1]> = Vec::new();
//         leaves.push("A".as_bytes().try_into().unwrap());
//         leaves.push("B".as_bytes().try_into().unwrap());
//         leaves.push("C".as_bytes().try_into().unwrap());
//         let num_leaves = 3;
//         let mut key = 0;

//         let (tree, _root, leaf) = build_sparse_tree(leaves, key).await;
//         key = num_leaves;

//         sparse_process_proof(&instance, key, leaf, proof).await;
//     }

//     #[tokio::test]
//     #[ignore]
//     #[should_panic(expected = "InvalidKey")]
//     async fn when_key_equal_num_leaves_length() {
//         let instance = merkle_proof_instance().await;

//         let mut leaves: Vec<[u8; 1]> = Vec::new();
//         leaves.push("A".as_bytes().try_into().unwrap());
//         leaves.push("B".as_bytes().try_into().unwrap());
//         leaves.push("C".as_bytes().try_into().unwrap());
//         let num_leaves = 4;
//         let key = 0;

//         let (tree, _root, leaf) = build_sparse_tree(leaves, key).await;

//         sparse_process_proof(&instance, num_leaves, leaf, proof).await;
//     }

//     #[tokio::test]
//     #[ignore]
//     #[should_panic(expected = "InvalidKey")]
//     async fn when_key_greater_than_num_leaves_length() {
//         let instance = merkle_proof_instance().await;

//         let mut leaves: Vec<[u8; 1]> = Vec::new();
//         leaves.push("A".as_bytes().try_into().unwrap());
//         leaves.push("B".as_bytes().try_into().unwrap());
//         leaves.push("C".as_bytes().try_into().unwrap());
//         let num_leaves = 4;
//         let mut key = 0;

//         let (tree, _root, leaf) = build_sparse_tree(leaves, key).await;
//         key = num_leaves + 1;

//         sparse_process_proof(&instance, key, leaf, proof).await;
//     }

//     #[tokio::test]
//     #[ignore]
//     #[should_panic(expected = "InvalidProofLength")]
//     async fn when_num_leaves_zero() {
//         let instance = merkle_proof_instance().await;

//         let mut leaves: Vec<[u8; 1]> = Vec::new();
//         leaves.push("A".as_bytes().try_into().unwrap());
//         leaves.push("B".as_bytes().try_into().unwrap());
//         leaves.push("C".as_bytes().try_into().unwrap());
//         let num_leaves = 0;
//         let key = 0;

//         let (tree, _root, leaf) = build_sparse_tree(leaves, key).await;

//         sparse_process_proof(&instance, key, leaf, proof).await;
//     }
// }
