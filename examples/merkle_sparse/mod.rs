// ANCHOR: import
use fuel_merkle::sparse::in_memory::MerkleTree as SparseTree;
use fuel_merkle::sparse::proof::ExclusionLeaf as FuelExclusionLeaf;
use fuel_merkle::sparse::proof::Proof as FuelProof;
use fuel_merkle::sparse::MerkleTreeKey as SparseTreeKey;
use fuels::types::{Bits256, Bytes};
// ANCHOR_END: import
use fuels::prelude::*;
use sha2::{Digest, Sha256};

// Load abi from json
abigen!(Contract(
    name = "MerkleExample",
    abi = "merkle_sparse/out/release/merkle_sparse_examples-abi.json"
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
        "./merkle_sparse/out/release/merkle_sparse_examples.bin",
        LoadConfiguration::default(),
    )
    .unwrap()
    .deploy(&wallet, TxPolicies::default())
    .await
    .unwrap();

    let instance = MerkleExample::new(id, wallet.clone());

    (instance, wallet)
}

#[tokio::test]
async fn rust_setup_example() {
    let (contract_instance, _id) = get_contract_instance().await;

    // ANCHOR: generating_a_tree
    // Create a new Merkle Tree and define leaves
    let mut tree = SparseTree::new();
    let leaves = ["A", "B", "C"].to_vec();
    let leaf_to_prove = "A";
    let key = SparseTreeKey::new(leaf_to_prove);

    // Hash the leaves and then push to the merkle tree
    for datum in &leaves {
        let _ = tree.update(SparseTreeKey::new(datum), datum.as_bytes());
    }
    // ANCHOR_END: generating_a_tree

    // ANCHOR: generating_proof
    // Get the merkle root and proof set
    let root = tree.root();
    let fuel_proof: FuelProof = tree.generate_proof(&key).unwrap();

    // Convert the proof from a FuelProof to the Sway Proof
    let sway_proof: Proof = fuel_to_sway_sparse_proof(fuel_proof);
    // ANCHOR_END: generating_proof

    // ANCHOR: verify_proof
    // Call the Sway contract to verify the generated merkle proof
    let result: bool = contract_instance
        .methods()
        .verify(
            Bits256(root),
            Bits256(*key),
            Some(Bytes(leaves[0].into())),
            sway_proof,
        )
        .call()
        .await
        .unwrap()
        .value;

    assert!(result);
    // ANCHOR_END: verify_proof
}

// ANCHOR: sway_conversion
pub fn fuel_to_sway_sparse_proof(fuel_proof: FuelProof) -> Proof {
    let mut proof_bits: Vec<Bits256> = Vec::new();
    for iterator in fuel_proof.proof_set().iter() {
        proof_bits.push(Bits256(iterator.clone()));
    }

    match fuel_proof {
        FuelProof::Exclusion(exlcusion_proof) => Proof::Exclusion(ExclusionProof {
            proof_set: proof_bits,
            leaf: match exlcusion_proof.leaf {
                FuelExclusionLeaf::Leaf(leaf_data) => ExclusionLeaf::Leaf(ExclusionLeafData {
                    leaf_key: Bits256(leaf_data.leaf_key),
                    leaf_value: Bits256(leaf_data.leaf_value),
                }),
                FuelExclusionLeaf::Placeholder => ExclusionLeaf::Placeholder,
            },
        }),
        FuelProof::Inclusion(_) => Proof::Inclusion(InclusionProof {
            proof_set: proof_bits,
        }),
    }
}
// ANCHOR_END: sway_conversion
