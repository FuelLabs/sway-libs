// TODO: More extensive testing using different proof lengths should be added when https://github.com/FuelLabs/fuels-rs/issues/353 is revolved.
// TODO: Using the fuel-merkle repository will currently fail all tests due to https://github.com/FuelLabs/sway/issues/2594
use crate::merkle_proof::tests::utils::{
    abi_calls::process_proof,
    test_helpers::{build_tree, merkle_proof_instance},
};
use fuel_merkle::common::{Bytes32, LEAF};
use sha2::{Digest, Sha256};

mod success {

    use super::*;

    #[ignore]
    #[tokio::test]
    async fn fails_to_process_merkle_proof() {
        let instance = merkle_proof_instance().await;

        let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
        let num_leaves = 3;
        let key = 0;

        let (_tree, root, leaf, proof) = build_tree(leaves, key).await;

        assert_ne!(
            process_proof(
                &instance,
                key,
                leaf,
                num_leaves,
                [proof[1], proof[0]].to_vec()
            )
            .await,
            root
        );
    }

    #[ignore]
    #[tokio::test]
    async fn processes_merkle_proof() {
        let instance = merkle_proof_instance().await;

        let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
        let num_leaves = 3;
        let key = 0;

        let (_tree, root, leaf, proof) = build_tree(leaves, key).await;

        assert_eq!(
            process_proof(&instance, key, leaf, num_leaves, proof).await,
            root
        );
    }

    // NOTE: This test does not use the Fuel-Merkle library but replicates it's functionality
    // without the use of a `u8`. Due to a `u8` being padded to a full word in Sway, the Fuel-Merkle
    // repository sha-256 hashes and the Sway sha-256 hashes do not produce the same result. This
    // test uses a `u64` instead for node concatentation and passes as expected. Once this is resolved
    // this test will be modified to use a `u8` again.
    // The issue can be tracked here: https://github.com/FuelLabs/sway/issues/2594
    #[tokio::test]
    async fn processes_merkle_proof_manual() {
        let instance = merkle_proof_instance().await;

        // Data as bytes
        let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()];
        let key = 0;
        let num_leaves = 3;

        //            ABC
        //           /   \
        //          AB    C
        //         /  \
        //        A    B

        // Leaf A hash
        let mut merkle_leaf_a = Sha256::new();
        merkle_leaf_a.update(&[LEAF]);
        merkle_leaf_a.update(&leaves[0]);
        let leaf_a_hash: Bytes32 = merkle_leaf_a.finalize().try_into().unwrap();

        // Leaf B hash
        let mut merkle_leaf_b = Sha256::new();
        merkle_leaf_b.update(&[LEAF]);
        merkle_leaf_b.update(&leaves[1]);
        let leaf_b_hash: Bytes32 = merkle_leaf_b.finalize().try_into().unwrap();

        // leaf B hash
        let mut merkle_leaf_c = Sha256::new();
        merkle_leaf_c.update(&[LEAF]);
        merkle_leaf_c.update(&leaves[2]);
        let leaf_c_hash: Bytes32 = merkle_leaf_c.finalize().try_into().unwrap();

        // Node AB hash
        let node_u64: u64 = 1;
        let mut node_ab = Sha256::new();
        node_ab.update(node_u64.to_be_bytes());
        node_ab.update(&leaf_a_hash);
        node_ab.update(&leaf_b_hash);
        let node_ab_hash: Bytes32 = node_ab.finalize().try_into().unwrap();

        // Root hash
        let mut node_abc = Sha256::new();
        node_abc.update(node_u64.to_be_bytes());
        node_abc.update(&node_ab_hash);
        node_abc.update(&leaf_c_hash);
        let node_abc_hash: Bytes32 = node_abc.finalize().try_into().unwrap();

        // This passes due to use of u64 for node concatenation
        assert_eq!(
            process_proof(
                &instance,
                key,
                leaf_a_hash,
                num_leaves,
                [leaf_b_hash, leaf_c_hash].to_vec()
            )
            .await,
            node_abc_hash
        );
    }
}

mod revert {

    use super::*;

    #[ignore]
    #[tokio::test]
    #[should_panic(expected = "Revert(42)")]
    async fn when_invalid_proof_length_given() {
        let instance = merkle_proof_instance().await;

        let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
        let num_leaves = 3;
        let key = 0;

        let (_tree, root, leaf, _proof) = build_tree(leaves, key).await;

        assert_eq!(
            process_proof(&instance, key, leaf, num_leaves, [].to_vec()).await,
            root
        );
    }

    #[tokio::test]
    #[should_panic(expected = "Revert(42)")]
    async fn when_invalid_num_leaves_given() {
        let instance = merkle_proof_instance().await;

        let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
        let num_leaves = 1;
        let key = 0;

        let (_tree, root, leaf, proof) = build_tree(leaves, key).await;

        assert_eq!(
            process_proof(&instance, key, leaf, num_leaves, proof).await,
            root
        );
    }

    #[tokio::test]
    #[should_panic(expected = "Revert(42)")]
    async fn when_key_greater_or_equal_to_num_leaves() {
        let instance = merkle_proof_instance().await;

        let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
        let num_leaves = 3;
        let mut key = 0;

        let (_tree, _root, leaf, proof) = build_tree(leaves, key).await;
        key = num_leaves;

        process_proof(&instance, key, leaf, num_leaves, proof).await;
    }

    #[tokio::test]
    #[should_panic(expected = "Revert(42)")]
    async fn when_key_equal_num_leaves_length() {
        let instance = merkle_proof_instance().await;

        let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
        let num_leaves = 4;
        let key = 0;

        let (_tree, _root, leaf, proof) = build_tree(leaves, key).await;

        process_proof(&instance, num_leaves, leaf, num_leaves, proof).await;
    }

    #[tokio::test]
    #[should_panic(expected = "Revert(42)")]
    async fn when_key_greater_than_num_leaves_length() {
        let instance = merkle_proof_instance().await;

        let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
        let num_leaves = 4;
        let mut key = 0;

        let (_tree, _root, leaf, proof) = build_tree(leaves, key).await;
        key = num_leaves + 1;

        process_proof(&instance, key, leaf, num_leaves, proof).await;
    }

    #[tokio::test]
    #[should_panic(expected = "Revert(42)")]
    async fn when_num_leaves_zero() {
        let instance = merkle_proof_instance().await;

        let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
        let num_leaves = 0;
        let key = 0;

        let (_tree, _root, leaf, proof) = build_tree(leaves, key).await;

        process_proof(&instance, key, leaf, num_leaves, proof).await;
    }
}
