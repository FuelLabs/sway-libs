use fuels::prelude::*;

script_abigen!(
    Testi16,
    "test_projects/signed_integers/signed_i16/out/debug/i16_test-abi.json"
);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_i16_test_script() {
        let path_to_bin = "test_projects/signed_integers/signed_i16/out/debug/i16_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = Testi16::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
