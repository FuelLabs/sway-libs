use fuels::{prelude::*};

abigen!(
    TestStringLib,
    "test_projects/string/out/debug/string-abi.json"
);

async fn test_string_instance() -> TestStringLib {
    // Launch a local network and deploy the contract
    let wallet = launch_provider_and_get_wallet().await;

    let id = Contract::deploy(
        "test_projects/string/out/debug/string.bin",
        &wallet,
        TxParameters::default(),
        StorageConfiguration::default(),
    )
    .await
    .unwrap();

    let instance = TestStringLibBuilder::new(id.to_string(), wallet).build();

    instance
}

// mod as_bytes {

//     use super::*;

//     mod success {

//         use super::*;

//         #[tokio::test]
//         async fn gets_bytes() {
//             let _instance = test_string_instance().await;

//         }

//     }

//     mod reverts {

//         use super::*;

//     }

// }

mod len {

    use super::*;

    mod success {

        use super::*;

        #[tokio::test]
        async fn gets_length() {
            let instance = test_string_instance().await;

            let _result = instance.test_len().call().await.unwrap();
        }
    }
}
