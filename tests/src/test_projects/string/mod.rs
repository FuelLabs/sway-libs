use fuels::{prelude::*, tx::ContractId};

abigen!(
    TestStringLib,
    "test_projects/string/out/debug/string-abi.json"
);

async fn test_merkle_proof_instance() -> TestStringLib {
    // Launch a local network and deploy the contract
    let wallet = launch_provider_and_get_wallet().await;

    let id = Contract::deploy(
        "test_projects/merkle_proof/out/debug/string.bin",
        &wallet,
        TxParameters::default(),
        StorageConfiguration::default(),
    )
    .await
    .unwrap();

    let instance = TestStringLibBuilder::new(id.to_string(), wallet).build();

    instance
}

// mod merkle_proof {

//     use super::*;

//     mod success {

//         use super::*;

//         #[tokio::test]
//         async fn verifies_merkle_proof() {
//             let _instance = test_merkle_proof_instance().await;

//             // Test here once https://github.com/FuelLabs/fuels-rs/issues/353 is closed
//         }

//     }

//     mod reverts {

//         use super::*;

//     }

// }