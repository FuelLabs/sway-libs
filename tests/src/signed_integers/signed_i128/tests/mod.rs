use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "Testi128",
    abi = "src/signed_integers/signed_i128/out/debug/i128_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_i128_test_script() {
        let path_to_bin = "src/signed_integers/signed_i128/out/debug/i128_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = Testi128::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
