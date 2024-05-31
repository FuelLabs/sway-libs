// ANCHOR: import
use fuel_merkle::binary::in_memory::MerkleTree;
// ANCHOR_END: import
use fuels::{prelude::*, types::Bits256};
use sha2::{Digest, Sha256};

pub const LEAF: u8 = 0x00;

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
    // Create a new Merkle Tree and define leaves
    let mut tree = MerkleTree::new();
    let leaves = ["A".as_bytes(), "B".as_bytes(), "C".as_bytes()].to_vec();

    // Hash the leaves and then push to the merkle tree
    for datum in leaves.iter() {
        let mut hasher = Sha256::new();
        hasher.update(&datum);
        let hash = hasher.finalize();
        tree.push(&hash);
    }
    // ANCHOR_END: generating_a_tree

    // ANCHOR: generating_proof
    // Define the key or index of the leaf you want to prove and the number of leaves
    let key: u64 = 0;

    // Get the merkle root and proof set
    let (merkle_root, proof_set) = tree.prove(key).unwrap();

    // Convert the proof set from Vec<Bytes32> to Vec<Bits256>
    let mut bits256_proof: Vec<Bits256> = Vec::new();
    for itterator in proof_set {
        bits256_proof.push(Bits256(itterator.clone()));
    }
    // ANCHOR_END: generating_proof

    // ANCHOR: verify_proof
    // Create the merkle leaf
    let mut leaf_hasher = Sha256::new();
    leaf_hasher.update(&leaves[key as usize]);
    let hashed_leaf_data = leaf_hasher.finalize();
    let merkle_leaf = leaf_sum(&hashed_leaf_data);

    // Get the number of leaves or data points
    let num_leaves: u64 = leaves.len() as u64;

    // Call the Sway contract to verify the generated merkle proof
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

pub fn leaf_sum(data: &[u8]) -> [u8; 32] {
    let mut hash = Sha256::new();

    hash.update(&[LEAF]);
    hash.update(data);

    hash.finalize().into()
}
