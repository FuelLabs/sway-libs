use fuels::prelude::*;

script_abigen!(
    TestUfp64,
    "src/unsigned_integers/ufp64_test/out/debug/ufp64_test-abi.json"
);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ufp64_test_script() {
        let path_to_bin = "src/unsigned_integers/ufp64_test/out/debug/ufp64_test.bin";

        let wallet = launch_provider_and_get_wallet().await;

        let instance = TestUfp64::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
