use crate::merkle_proof::tests::utils::{
    abi_calls::leaf_digest,
    test_helpers::{build_tree, merkle_proof_instance},
};

mod success {

    use super::*;

    #[ignore]
    #[tokio::test]
    async fn computes_leaf() {
        let instance = merkle_proof_instance().await;

        let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
        let key = 0;
        let (_tree, _root, leaf, _proof) = build_tree(leaves, key).await;

        assert_eq!(
            leaf_digest(&instance, "A".as_bytes().try_into().unwrap()).await,
            leaf
        );
    }
}
