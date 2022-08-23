// TODO: More extensive testing should be added when https://github.com/FuelLabs/fuels-rs/issues/353 is revolved.
// TODO: Using the fuel-merkle repository will currently fail all tests due to https://github.com/FuelLabs/sway/issues/2594
use fuel_merkle::{
    binary::in_memory::MerkleTree,
    common::{Bytes32, LEAF, NODE, ProofSet},
};
use fuels::prelude::*;
use sha2::{Digest, Sha256};

abigen!(
    TestMerkleProofLib,
    "test_projects/merkle_proof/out/debug/merkle_proof-abi.json"
);

async fn build_tree(leaves: Vec<&[u8]>, key: u64) -> (MerkleTree, Bytes32, Bytes32, ProofSet) {
    let mut tree = MerkleTree::new();

    for datum in leaves.iter() {
        let _ = tree.push(datum);
    }

    let merkle_root = tree.root();
    let mut proof = tree.prove(key).unwrap();
    let merkle_leaf = proof.1[0];
    proof.1.remove(0);

    (tree, merkle_root, merkle_leaf, proof.1)
}

async fn merkle_proof_instance() -> TestMerkleProofLib {
    let wallet = launch_provider_and_get_wallet().await;

    let contract_id = Contract::deploy(
        "./test_projects/merkle_proof/out/debug/merkle_proof.bin",
        &wallet,
        TxParameters::default(),
        StorageConfiguration::default(),
    )
    .await
    .unwrap();

    let instance = TestMerkleProofLibBuilder::new(contract_id.to_string(), wallet.clone()).build();

    instance
}

mod leaf_digest {

    use super::*;

    mod succes {

        use super::*;

        #[ignore]
        #[tokio::test]
        async fn computes_leaf() {
            let instance = merkle_proof_instance().await;

            let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
            let key = 0;
            let (_tree, _root, leaf, _proof) = build_tree(leaves, key).await;

            assert_eq!(
                instance
                    .leaf_digest("A".as_bytes().try_into().unwrap())
                    .call()
                    .await
                    .unwrap()
                    .value,
                leaf
            );
        }
    }
}

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

            assert_eq!(
                instance
                    .node_digest(proof[0], leaf)
                    .call()
                    .await
                    .unwrap()
                    .value,
                root
            );
        }
    }
}

mod process_merkle_proof {

    use super::*;

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
                instance
                    .process_proof(key, leaf, num_leaves, [proof[1], proof[0]].to_vec())
                    .call()
                    .await
                    .unwrap()
                    .value,
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
                instance
                    .process_proof(key, leaf, num_leaves, proof)
                    .call()
                    .await
                    .unwrap()
                    .value,
                root
            );
        }

        // NOTE: This test does not use the Fuel-Merkle library but replicates it's functionality. 
        // Due to a `u8` being padded as a full word, the Fuel-Merkle repository hashes and the 
        // Sway hashes do not produce the same result. This test uses a `u64` as passes as expected.
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

            // This passes due to use of u64
            // u64 ------------------------------------------
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

            // This fails due to sha256 incompatability with u8.
            // Issue found here: https://github.com/FuelLabs/sway/issues/2594
            // u8 ------------------------------------------
            // Node AB hash
            // let mut node_ab = Sha256::new();
            // node_ab.update(&[NODE]);
            // node_ab.update(&leaf_a_hash);
            // node_ab.update(&leaf_b_hash);
            // let node_ab_hash: Bytes32 = node_ab.finalize().try_into().unwrap();

            // Root hash
            // let mut node_abc = Sha256::new();
            // node_abc.update(&[NODE]);
            // node_abc.update(&node_ab_hash);
            // node_abc.update(&leaf_c_hash);
            // let node_abc_hash: Bytes32 = node_abc.finalize().try_into().unwrap();

            assert_eq!(
                instance
                    .node_digest(leaf_a_hash, leaf_b_hash)
                    .call()
                    .await
                    .unwrap()
                    .value,
                node_ab_hash
            );

            assert_eq!(
                instance
                    .node_digest(node_ab_hash, leaf_c_hash)
                    .call()
                    .await
                    .unwrap()
                    .value,
                node_abc_hash
            );

            assert_eq!(
                instance
                    .process_proof(
                        key,
                        leaf_a_hash,
                        num_leaves,
                        [leaf_b_hash, leaf_c_hash].to_vec()
                    )
                    .call()
                    .await
                    .unwrap()
                    .value,
                node_abc_hash
            );
        }
    }

    mod revert {

        use super::*;

        #[ignore]
        #[tokio::test]
        #[should_panic(expected = "Revert(42)")]
        async fn panics_when_invalid_proof_length_given() {
            let instance = merkle_proof_instance().await;

            let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
            let num_leaves = 3;
            let key = 0;

            let (_tree, root, leaf, _proof) = build_tree(leaves, key).await;

            assert_eq!(
                instance
                    .process_proof(key, leaf, num_leaves, [].to_vec())
                    .call()
                    .await
                    .unwrap()
                    .value,
                root
            );
        }

        #[ignore]
        #[tokio::test]
        #[should_panic(expected = "Revert(42)")]
        async fn panics_when_invalid_num_leaves_given() {
            let instance = merkle_proof_instance().await;

            let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
            let num_leaves = 1;
            let key = 0;

            let (_tree, root, leaf, proof) = build_tree(leaves, key).await;

            assert_eq!(
                instance
                    .process_proof(key, leaf, num_leaves, proof)
                    .call()
                    .await
                    .unwrap()
                    .value,
                root
            );
        }

        #[ignore]
        #[tokio::test]
        #[should_panic(expected = "Revert(42)")]
        async fn panics_when_key_greater_or_equal_to_num_leaves() {
            let instance = merkle_proof_instance().await;

            let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
            let num_leaves = 3;
            let mut key = 0;

            let (_tree, _root, leaf, proof) = build_tree(leaves, key).await;
            key = num_leaves;

            let _result = instance
                .process_proof(key, leaf, num_leaves, proof)
                .call()
                .await;
        }

        #[ignore]
        #[tokio::test]
        #[should_panic(expected = "Revert(42)")]
        async fn panics_with_invalid_num_leaves_length() {
            let instance = merkle_proof_instance().await;

            let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
            let num_leaves = 4;
            let mut key = 0;

            let (_tree, _root, leaf, proof) = build_tree(leaves, key).await;
            key = num_leaves;

            let _result = instance
                .process_proof(key, leaf, num_leaves, proof)
                .call()
                .await;
        }
    }
}

mod verify_merkle_proof {

    use super::*;

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
                instance
                    .verify_proof(key, leaf, root, num_leaves, [proof[1], proof[0]].to_vec())
                    .call()
                    .await
                    .unwrap()
                    .value,
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
                instance
                    .verify_proof(key, leaf, root, num_leaves, proof)
                    .call()
                    .await
                    .unwrap()
                    .value,
                true
            );
        }
    }
}
