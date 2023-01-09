use fuels::prelude::*;

script_abigen!(
    Testi64,
    "test_projects/signed_integers/signed_i64/out/debug/i64_test-abi.json"
);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_i64_test_script() {
        let path_to_bin = "test_projects/signed_integers/signed_i64/out/debug/i64_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = Testi64::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
