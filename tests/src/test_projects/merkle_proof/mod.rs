// TODO: More extensive testing should be added when https://github.com/FuelLabs/fuels-rs/issues/353 is revolved.
use fuels::{prelude::*};
// use rs_merkle::{algorithms::Sha256, Hasher, MerkleTree};
use fuel_merkle::binary::in_memory::MerkleTree;

abigen!(
    TestMerkleProofLib,
    "test_projects/merkle_proof/out/debug/merkle_proof-abi.json"
);

async fn build_tree(leaves: Vec<&[u8]>, key: u64) -> (MerkleTree, [u8; 32], [u8; 32], Vec<[u8; 32]>) {
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

    let contract_id  = Contract::deploy(
        "./test_projects/merkle_proof/out/debug/merkle_proof.bin",
        &wallet,
        TxParameters::default(),
        StorageConfiguration::default(),
    )
    .await
    .unwrap();

    let instance = TestMerkleProofLibBuilder::new(contract_id .to_string(), wallet.clone()).build();

    instance
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
