use fuels::{prelude::*};
use std::io::stdout;
use std::io::Write;

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

mod capacity {

    use super::*;

    mod success {

        use super::*;

        #[tokio::test]
        async fn returns_capacity() {
            let instance = test_string_instance().await;

            let _result = instance.test_capacity().call().await.unwrap();
        }
    }
}

mod clear {

    use super::*;

    mod success {

        use super::*;

        #[tokio::test]
        async fn clears_string() {
            let instance = test_string_instance().await;

            let _result = instance.test_clear().call().await.unwrap();
        }
    }
}

mod is_empty {

    use super::*;

    mod success {

        use super::*;

        #[tokio::test]
        async fn returns_if_empty() {
            let instance = test_string_instance().await;

            let _result = instance.test_is_empty().call().await.unwrap();
        }
    }
}

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

mod new {

    use super::*;

    mod success {

        use super::*;

        #[tokio::test]
        async fn creates_string() {
            let instance = test_string_instance().await;

            let _result = instance.test_new().call().await.unwrap();
        }
    }
}

mod push {

    use super::*;

    mod success {

        use super::*;

        #[tokio::test]
        async fn pushes_to_string() {
            let instance = test_string_instance().await;

            let _result = instance.test_push().call().await.unwrap();
        }
    }
}

mod push_str {

    use super::*;

    mod success {

        use super::*;

        #[tokio::test]
        async fn pushes_string() {
            let instance = test_string_instance().await;

            let _result = instance.test_push_str().call().await.unwrap();
        }
    }
}

mod with_capacity {

    use super::*;

    mod success {

        use super::*;

        #[tokio::test]
        async fn creates_string_with_capacity() {
            let instance = test_string_instance().await;

            let _result = instance.test_with_capacity().call().await.unwrap();
        }
    }
}
