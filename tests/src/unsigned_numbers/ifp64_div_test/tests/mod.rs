use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "TestIfp64Div",
    abi = "src/unsigned_numbers/ifp64_div_test/out/debug/ifp64_div_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ifp64_div_test_script() {
        let path_to_bin = "src/unsigned_numbers/ifp64_div_test/out/debug/ifp64_div_test.bin";

        let wallet = launch_provider_and_get_wallet().await;

        let instance = TestIfp64Div::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
