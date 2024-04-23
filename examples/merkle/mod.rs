// ANCHOR: import
use fuel_merkle::{binary::in_memory::MerkleTree, common::Bytes32};
// ANCHOR_END: import
use fuels::{prelude::*, types::Bits256};
use sha2::{Digest, Sha256};

// Load abi from json
abigen!(Contract(
    name = "MerkleExample",
    abi = "merkle/out/release/merkle_examples-abi.json"
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
        "./merkle/out/release/merkle_examples.bin",
        LoadConfiguration::default(),
    )
    .unwrap()
    .deploy(&wallet, TxPolicies::default())
    .await
    .unwrap();

    let instance = MerkleExample::new(id.clone(), wallet.clone());

    (instance, wallet)
}

#[tokio::test]
async fn rust_setup_example() {
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
    let proof = tree.prove(key).unwrap();
    let mut bits256_proof: Vec<Bits256> = Vec::new();
    for itterator in &proof.1 {
        bits256_proof.push(Bits256(itterator.clone()));
    }
    // ANCHOR_END: generating_proof

    // ANCHOR: verify_proof
    let merkle_root = proof.0;
    let merkle_leaf = proof.1[key as usize];
    bits256_proof.remove(key as usize);

    let result: bool = contract_instance
        .methods()
        .verify(
            Bits256(merkle_root),
            key,
            Bits256(merkle_leaf),
            num_leaves,
            bits256_proof,
        )
        .call()
        .await
        .unwrap()
        .value;
    assert!(result);
    // ANCHOR_END: verify_proof
}
