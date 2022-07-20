use fuels::prelude::*;

abigen!(
    TestMerkleProofLib,
    "test_projects/merkle_proof/out/debug/merkle_proof-abi.json"
);

async fn test_merkle_proof_instance() -> TestMerkleProofLib {
    let wallet = launch_provider_and_get_wallet().await;
    let id = Contract::deploy(
        "test_projects/merkle_proof/out/debug/merkle_proof.bin",
        &wallet,
        TxParameters::default(),
        StorageConfiguration::default(),
    )
    .await
    .unwrap();

    TestMerkleProofLib::new(id.to_string(), wallet)
}

mod merkle_proof {

    use super::*;

    mod success {

        use super::*;

        #[tokio::test]
        async fn verifies_merkle_proof() {
            let _instance = test_merkle_proof_instance().await;

            // Test here once https://github.com/FuelLabs/fuels-rs/issues/353 is closed
        }

    }

    mod reverts {

        use super::*;

    }

}
