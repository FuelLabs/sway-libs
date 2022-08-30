use crate::merkle_proof::tests::utils::{
    abi_calls::node_digest,
    test_helpers::{build_tree, merkle_proof_instance},
};
use fuel_merkle::common::{Bytes32, LEAF};
use sha2::{Digest, Sha256};

mod success {

    use super::*;

    #[ignore]
    #[tokio::test]
    async fn computes_node() {
        let instance = merkle_proof_instance().await;

        let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
        let key = 2;
        let (_tree, root, leaf, proof) = build_tree(leaves, key).await;

        assert_eq!(node_digest(&instance, proof[0], leaf).await, root);
    }

    // NOTE: This test does not use the Fuel-Merkle library but replicates it's functionality
    // without the use of a `u8`. Due to a `u8` being padded to a full word in Sway, the Fuel-Merkle
    // repository sha-256 hashes and the Sway sha-256 hashes do not produce the same result. This
    // test uses a `u64` instead for node concatentation and passes as expected. Once this is resolved
    // this test will be modified to use a `u8` again.
    // The issue can be tracked here: https://github.com/FuelLabs/sway/issues/2594
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
            node_digest(&instance, leaf_a_hash, leaf_b_hash).await,
            node_ab_hash
        );

        assert_eq!(
            node_digest(&instance, node_ab_hash, leaf_c_hash).await,
            node_abc_hash
        );
    }
}
