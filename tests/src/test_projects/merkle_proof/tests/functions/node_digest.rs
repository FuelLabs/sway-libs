use crate::merkle_proof::tests::utils::{
    abi_calls::node_digest,
    test_helpers::{build_tree, merkle_proof_instance},
};

mod node_digest {

    use super::*;

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
    }
}
