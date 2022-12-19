use fuels::prelude::*;

script_abigen!(
    TestUfp64Div,
    "test_projects/ufp64_div_test/out/debug/ufp64_div_test-abi.json"
);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ufp64_div_test_script() {
        let path_to_bin = "test_projects/ufp64_div_test/out/debug/ufp64_div_test.bin";

        let wallet = launch_provider_and_get_wallet().await;

        let instance = TestUfp64Div::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
