use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "TestDeque",
    abi = "src/deque/out/debug/deque_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_queue_test_script() {
        let path_to_bin = "src/deque/out/debug/deque_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = TestDeque::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}