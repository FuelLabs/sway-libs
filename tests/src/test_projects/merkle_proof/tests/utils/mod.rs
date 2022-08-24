use fuel_merkle::{
    binary::in_memory::MerkleTree,
    common::{Bytes32, ProofSet},
};
use fuels::prelude::*;

abigen!(
    TestMerkleProofLib,
    "test_projects/merkle_proof/out/debug/merkle_proof-abi.json"
);

pub mod abi_calls {

    use super::*;

    pub async fn leaf_digest(contract: &TestMerkleProofLib, data: [u8; 32]) -> [u8; 32] {
        contract.leaf_digest(data).call().await.unwrap().value
    }

    pub async fn node_digest(
        contract: &TestMerkleProofLib,
        left: [u8; 32],
        right: [u8; 32],
    ) -> [u8; 32] {
        contract
            .node_digest(left, right)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn process_proof(
        contract: &TestMerkleProofLib,
        key: u64,
        leaf: [u8; 32],
        num_leaves: u64,
        proof: Vec<[u8; 32]>,
    ) -> [u8; 32] {
        contract
            .process_proof(key, leaf, num_leaves, proof)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn verify_proof(
        contract: &TestMerkleProofLib,
        key: u64,
        leaf: [u8; 32],
        root: [u8; 32],
        num_leaves: u64,
        proof: Vec<[u8; 32]>,
    ) -> bool {
        contract
            .verify_proof(key, root, leaf, num_leaves, proof)
            .call()
            .await
            .unwrap()
            .value
    }
}

pub mod test_helpers {

    use super::*;

    pub async fn build_tree(
        leaves: Vec<&[u8]>,
        key: u64,
    ) -> (MerkleTree, Bytes32, Bytes32, ProofSet) {
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

    pub async fn merkle_proof_instance() -> TestMerkleProofLib {
        let wallet = launch_provider_and_get_wallet().await;

        let contract_id = Contract::deploy(
            "./test_projects/merkle_proof/out/debug/merkle_proof.bin",
            &wallet,
            TxParameters::default(),
            StorageConfiguration::default(),
        )
        .await
        .unwrap();

        let instance =
            TestMerkleProofLibBuilder::new(contract_id.to_string(), wallet.clone()).build();

        instance
    }
}
