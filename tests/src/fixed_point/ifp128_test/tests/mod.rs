use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "TestIfp128",
    abi = "src/fixed_point/ifp128_test/out/release/ifp128_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ifp128_test_script() {
        let path_to_bin = "src/fixed_point/ifp128_test/out/release/ifp128_test.bin";

        let wallet = launch_provider_and_get_wallet().await.unwrap();

        let instance = TestIfp128::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
