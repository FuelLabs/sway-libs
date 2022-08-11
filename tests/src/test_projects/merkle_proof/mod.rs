use fuels::{prelude::*, tx::Bytes32};
use rs_merkle::{algorithms::Sha256, Hasher, MerkleTree};

abigen!(
    TestMerkleProofLib,
    "test_projects/merkle_proof/out/debug/merkle_proof-abi.json"
);

async fn test_merkle_proof_instance() -> TestMerkleProofLib {
    // Launch a local network and deploy the contract
    let wallet = launch_provider_and_get_wallet().await;

    let id = Contract::deploy(
        "test_projects/merkle_proof/out/debug/merkle_proof.bin",
        &wallet,
        TxParameters::default(),
        StorageConfiguration::default(),
    )
    .await
    .unwrap();

    let instance = TestMerkleProofLibBuilder::new(id.to_string(), wallet).build();

    instance
}

mod merkle_proof {

    use super::*;

    mod success {

        use super::*;

        #[tokio::test]
        async fn verifies_merkle_proof() {
            let instance = test_merkle_proof_instance().await;

            let leaf_values = ["A", "B", "C"];
            let leaves: Vec<[u8; 32]> = leaf_values
                .iter()
                .map(|x| Sha256::hash(x.as_bytes()))
                .collect();

            let merkle_tree = MerkleTree::<Sha256>::from_leaves(&leaves);
            let merkle_root = merkle_tree.root();
            let (merkle_leaf, proof) = leaves.split_first().unwrap();

            assert_eq!(instance.verify_proof(*merkle_leaf, merkle_root.unwrap(), proof.to_vec()).call().await.unwrap().value, true);
        }

        #[tokio::test]
        async fn fails_merkle_proof() {
            let instance = test_merkle_proof_instance().await;

            let leaf_values = ["A", "B", "C"];
            let leaves: Vec<[u8; 32]> = leaf_values
                .iter()
                .map(|x| Sha256::hash(x.as_bytes()))
                .collect();

            let merkle_tree = MerkleTree::<Sha256>::from_leaves(&leaves);
            let merkle_root = merkle_tree.root();
            let (_merkle_leaf, proof) = leaves.split_first().unwrap();
            let zero_b256 = Bytes32::zeroed();

            assert_eq!(instance.verify_proof(*zero_b256, merkle_root.unwrap(), proof.to_vec()).call().await.unwrap().value, false);
        }

        #[tokio::test]
        async fn verifies_multi_merkle_proof() {
            let instance = test_merkle_proof_instance().await;

            let leaf_values = ["A", "B", "C", "D"];
            let leaves: Vec<[u8; 32]> = leaf_values
                .iter()
                .map(|x| Sha256::hash(x.as_bytes()))
                .collect();

            let merkle_tree = MerkleTree::<Sha256>::from_leaves(&leaves);
            let indices_to_prove = vec![0, 1];
            let merkle_leaves = leaves.get(0..2);
            let merkle_proof  = merkle_tree.proof(&indices_to_prove);
            let proof_bytes = merkle_proof.to_bytes();
            let proof: &[u8; 32] = &(&proof_bytes[..]).try_into().unwrap();
            let merkle_root = merkle_tree.root();
            let proof_flags = vec![true, false];

            assert_eq!(instance.verify_multi_proof((*merkle_leaves.unwrap()).to_vec(), merkle_root.unwrap(), *proof, proof_flags).call().await.unwrap().value, true);
        }

        #[tokio::test]
        async fn fails_multi_merkle_proof() {
            let instance = test_merkle_proof_instance().await;

            let leaf_values = ["A", "B", "C", "D"];
            let leaves: Vec<[u8; 32]> = leaf_values
                .iter()
                .map(|x| Sha256::hash(x.as_bytes()))
                .collect();

            let merkle_tree = MerkleTree::<Sha256>::from_leaves(&leaves);
            let indices_to_prove = vec![0, 1];
            let merkle_leaves = leaves.get(0..2);
            let merkle_proof  = merkle_tree.proof(&indices_to_prove);
            let proof_bytes = merkle_proof.to_bytes();
            let proof: &[u8; 32] = &(&proof_bytes[..]).try_into().unwrap();
            let merkle_root = merkle_tree.root();
            let proof_flags = vec![false, false];

            assert_eq!(instance.verify_multi_proof((*merkle_leaves.unwrap()).to_vec(), merkle_root.unwrap(), *proof, proof_flags).call().await.unwrap().value, false);
        }
    }
}
