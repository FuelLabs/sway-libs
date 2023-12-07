use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "TestIfp64",
    abi = "src/fixed_point/ifp64_test/out/debug/ifp64_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ifp64_test_script() {
        let path_to_bin = "src/fixed_point/ifp64_test/out/debug/ifp64_test.bin";

        let wallet = launch_provider_and_get_wallet().await.unwrap();

        let instance = TestIfp64::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
