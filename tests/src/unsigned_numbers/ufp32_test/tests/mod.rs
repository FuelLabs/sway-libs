use fuels::prelude::*;

script_abigen!(
    TestUfp32,
    "src/unsigned_numbers/ufp32_test/out/debug/ufp32_test-abi.json"
);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ufp32_test_script() {
        let path_to_bin = "src/unsigned_numbers/ufp32_test/out/debug/ufp32_test.bin";

        let wallet = launch_provider_and_get_wallet().await;

        let instance = TestUfp32::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
