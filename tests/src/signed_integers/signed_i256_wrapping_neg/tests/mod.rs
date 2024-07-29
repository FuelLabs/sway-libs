use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "Testi256WrappingNeg",
    abi =
        "src/signed_integers/signed_i256_wrapping_neg/out/release/i256_wrapping_neg_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_i256_wrapping_neg_test_script() {
        let path_to_bin =
            "src/signed_integers/signed_i256_wrapping_neg/out/release/i256_wrapping_neg_test.bin";
        let wallet = launch_provider_and_get_wallet().await.unwrap();

        let instance = Testi256WrappingNeg::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
