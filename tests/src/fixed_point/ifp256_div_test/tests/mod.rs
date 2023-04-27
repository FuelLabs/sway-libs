use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "TestIfp256Div",
    abi = "src/fixed_point/ifp256_div_test/out/debug/ifp256_div_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ifp256_div_test_script() {
        let path_to_bin = "src/fixed_point/ifp256_div_test/out/debug/ifp256_div_test.bin";

        let wallet = launch_provider_and_get_wallet().await;

        let instance = TestIfp256Div::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
