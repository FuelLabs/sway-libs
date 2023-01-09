use fuels::prelude::*;

script_abigen!(
    TestUfp64Mul,
    "test_projects/unsigned_integers/ufp64_mul_test/out/debug/ufp64_mul_test-abi.json"
);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ufp64_mul_test_script() {
        let path_to_bin = "test_projects/unsigned_integers/ufp64_mul_test/out/debug/ufp64_mul_test.bin";

        let wallet = launch_provider_and_get_wallet().await;

        let instance = TestUfp64Mul::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
