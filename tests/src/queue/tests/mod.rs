use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "TestQueue",
    abi = "src/queue/out/debug/queue_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_queue_test_script() {
        let path_to_bin = "src/queue/out/debug/queue_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = TestQueue::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
