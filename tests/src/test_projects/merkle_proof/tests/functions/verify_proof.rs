use crate::merkle_proof::tests::utils::{
    abi_calls::verify_proof,
    test_helpers::{build_tree, merkle_proof_instance},
};

mod success {

    use super::*;

    #[ignore]
    #[tokio::test]
    async fn fails_merkle_proof_verification() {
        let instance = merkle_proof_instance().await;

        let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
        let num_leaves = 3;
        let key = 0;

        let (_tree, root, leaf, proof) = build_tree(leaves, key).await;

        assert_eq!(
            verify_proof(
                &instance,
                key,
                leaf,
                root,
                num_leaves,
                [proof[1], proof[0]].to_vec()
            )
            .await,
            false
        );
    }

    #[ignore]
    #[tokio::test]
    async fn verifies_merkle_proof() {
        let instance = merkle_proof_instance().await;

        let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
        let num_leaves = 3;
        let key = 0;

        let (_tree, root, leaf, proof) = build_tree(leaves, key).await;

        assert_eq!(
            verify_proof(&instance, key, leaf, root, num_leaves, proof).await,
            true
        );
    }
}
