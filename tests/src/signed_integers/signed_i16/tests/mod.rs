use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "Testi16",
    abi = "src/signed_integers/signed_i16/out/release/i16_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_i16_test_script() {
        let path_to_bin = "src/signed_integers/signed_i16/out/release/i16_test.bin";
        let wallet = launch_provider_and_get_wallet().await.unwrap();

        let instance = Testi16::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
