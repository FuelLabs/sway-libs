use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "Testi8",
    abi = "src/signed_integers/signed_i8/out/debug/i8_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_i8_test_script() {
        let path_to_bin = "src/signed_integers/signed_i8/out/debug/i8_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = Testi8::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
