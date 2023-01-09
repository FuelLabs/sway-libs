use fuels::prelude::*;

script_abigen!(Testi8, "test_projects/signed_integers/signed_i8/out/debug/i8_test-abi.json");

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_i8_test_script() {
        let path_to_bin = "test_projects/signed_integers/signed_i8/out/debug/i8_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = Testi8::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
