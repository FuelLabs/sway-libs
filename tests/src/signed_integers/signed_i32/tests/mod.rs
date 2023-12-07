use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "Testi32",
    abi = "src/signed_integers/signed_i32/out/debug/i32_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_i32_test_script() {
        let path_to_bin = "src/signed_integers/signed_i32/out/debug/i32_test.bin";
        let wallet = launch_provider_and_get_wallet().await.unwrap();

        let instance = Testi32::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
