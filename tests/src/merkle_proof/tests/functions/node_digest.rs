use crate::merkle_proof::tests::utils::{
    abi_calls::node_digest,
    test_helpers::{build_tree, merkle_proof_instance},
    LEAF, NODE,
};
use fuel_merkle::common::Bytes32;
use fuels::types::Bits256;
use sha2::{Digest, Sha256};

mod success {

    use super::*;

    #[tokio::test]
    async fn computes_node() {
        let instance = merkle_proof_instance().await;

        let mut leaves: Vec<[u8; 1]> = Vec::new();
        leaves.push("A".as_bytes().try_into().unwrap());
        leaves.push("B".as_bytes().try_into().unwrap());
        leaves.push("C".as_bytes().try_into().unwrap());
        let key = 2;
        let (_tree, root, leaf, proof) = build_tree(leaves, key).await;

        assert_eq!(node_digest(&instance, proof[0], leaf).await, root);
    }

    // This test does not use the Fuel-Merkle library but replicates it's functionality
    #[tokio::test]
    async fn computes_node_manual() {
        let instance = merkle_proof_instance().await;

        // Data as bytes
        let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()];

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

        // leaf C hash
        let mut merkle_leaf_c = Sha256::new();
        merkle_leaf_c.update(&[LEAF]);
        merkle_leaf_c.update(&leaves[2]);
        let leaf_c_hash: Bytes32 = merkle_leaf_c.finalize().try_into().unwrap();

        // Node AB hash
        let mut node_ab = Sha256::new();
        node_ab.update(&[NODE]);
        node_ab.update(&leaf_a_hash);
        node_ab.update(&leaf_b_hash);
        let node_ab_hash: Bytes32 = node_ab.finalize().try_into().unwrap();

        // Root hash
        let mut node_abc = Sha256::new();
        node_abc.update(&[NODE]);
        node_abc.update(&node_ab_hash);
        node_abc.update(&leaf_c_hash);
        let node_abc_hash: Bytes32 = node_abc.finalize().try_into().unwrap();

        assert_eq!(
            node_digest(&instance, Bits256(leaf_a_hash), Bits256(leaf_b_hash)).await,
            Bits256(node_ab_hash)
        );

        assert_eq!(
            node_digest(&instance, Bits256(node_ab_hash), Bits256(leaf_c_hash)).await,
            Bits256(node_abc_hash)
        );
    }
}
