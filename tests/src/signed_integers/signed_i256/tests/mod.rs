use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "Testi256",
    abi = "src/signed_integers/signed_i256/out/debug/i256_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_i256_test_script() {
        let path_to_bin = "src/signed_integers/signed_i256/out/debug/i256_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = Testi256::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
