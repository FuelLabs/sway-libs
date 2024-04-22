// ANCHOR: import
use fuel_merkle::{binary::in_memory::MerkleTree, common::Bytes32};
// ANCHOR_END: import
use fuels::prelude::*;
use sha2::{Digest, Sha256};

// Load abi from json
abigen!(Contract(
    name = "MerkleExample",
    abi = "out/release/merkle_proof_test-abi.json"
));

async fn get_contract_instance() -> (MerkleExample<WalletUnlocked>, WalletUnlocked) {
    // Launch a local network and deploy the contract
    let mut wallets = launch_custom_provider_and_get_wallets(
        WalletsConfig::new(
            Some(1),             /* Single wallet */
            Some(1),             /* Single coin (UTXO) */
            Some(1_000_000_000), /* Amount per coin */
        ),
        None,
        None,
    )
    .await
    .unwrap();
    let wallet = wallets.pop().unwrap();

    let id = Contract::load_from(
        "./out/release/merkle_proof_test.bin",
        LoadConfiguration::default(),
    )
    .unwrap()
    .deploy(&wallet, TxPolicies::default())
    .await
    .unwrap();

    let instance = MerkleExample::new(id.clone(), wallet.clone());

    (instance, wallet)
}

fn rust_setup_example() {
    let (contract_instance, _id) = get_contract_instance().await;

    // ANCHOR: generating_a_tree
    let mut tree = MerkleTree::new();
    let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();
    for datum in leaves.iter() {
        let mut hasher = Sha256::new();
        hasher.update(&datum);
        let hash: Bytes32 = hasher.finalize().try_into().unwrap();
        tree.push(&hash);
    }
    // ANCHOR_END: generating_a_tree

    let key = 0;
    let num_leaves = 3;

    // ANCHOR: generating_proof
    let mut proof = tree.prove(key).unwrap();
    // ANCHOR_END: generating_proof

    // ANCHOR: verify_proof
    let merkle_root = proof.0;
    let merkle_leaf = proof.1[0];
    proof.1.remove(0);
    contract_instance
        .verify(key, merkle_leaf, merkle_root, num_leaves, proof.1)
        .call()
        .await;
    // ANCHOR_END: verify_proof
}
