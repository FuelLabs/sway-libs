use fuels::{prelude::*, tx::ContractId};

// Load abi from json
abigen!(
    StringTestLib,
    "test_projects/string/out/debug/string-abi.json"
);

async fn string_test_instance() -> StringTestLib {
    // Launch a local network and deploy the contract
    let mut wallets = launch_custom_provider_and_get_wallets(
        WalletsConfig::new(
            Some(1),             /* Single wallet */
            Some(1),             /* Single coin (UTXO) */
            Some(1_000_000_000), /* Amount per coin */
        ),
        None,
    )
    .await;
    let wallet = wallets.pop().unwrap();

    let id = Contract::deploy(
        "test_projects/string/out/debug/string.bin",
        &wallet,
        TxParameters::default(),
        StorageConfiguration::default(),
    )
    .await
    .unwrap();

    let instance = StringTestLibBuilder::new(id.to_string(), wallet).build();

    instance
}

mod as_bytes {

    use super::*;

    mod success {

        use super::*;

        #[tokio::test]
        async fn returns_bytes() {
            let instance = test_string_instance().await;

            let _result = instance.test_as_bytes().call().await.unwrap();
        }
    }
}

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

mod from_utf8 {

    use super::*;

    mod success {

        use super::*;

        #[tokio::test]
        async fn converts_to_string() {
            let instance = test_string_instance().await;

            let _result = instance.test_from_utf8().call().await.unwrap();
        }
    }
}

mod insert {

    use super::*;

    mod success {

        use super::*;

        #[tokio::test]
        async fn inserts_into_string() {
            let instance = test_string_instance().await;

            let _result = instance.test_insert().call().await.unwrap();
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
        async fn returns_string_length() {
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
        async fn creates_empty_string() {
            let instance = test_string_instance().await;

            let _result = instance.test_new().call().await.unwrap();
        }
    }
}

mod nth {

    use super::*;

    mod success {

        use super::*;

        #[tokio::test]
        async fn returns_nth_element_in_string() {
            let instance = test_string_instance().await;

            let _result = instance.test_nth().call().await.unwrap();
        }
    }
}

mod pop {

    use super::*;

    mod success {

        use super::*;

        #[tokio::test]
        async fn pops_last_element_in_string() {
            let instance = test_string_instance().await;

            let _result = instance.test_pop().call().await.unwrap();
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

mod remove {

    use super::*;

    mod success {

        use super::*;

        #[tokio::test]
        async fn removes_element_in_string() {
            let instance = test_string_instance().await;

            let _result = instance.test_remove().call().await.unwrap();
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
