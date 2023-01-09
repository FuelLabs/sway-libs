use fuels::prelude::*;

script_abigen!(
    TestUfp64Pow,
    "test_projects/unsigned_integers/ufp64_pow_test/out/debug/ufp64_pow_test-abi.json"
);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ufp64_pow_test_script() {
        let path_to_bin = "test_projects/unsigned_integers/ufp64_pow_test/out/debug/ufp64_pow_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = TestUfp64Pow::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
