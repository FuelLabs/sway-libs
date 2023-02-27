use fuels::prelude::*;

script_abigen!(
    Testi32TwosComplement,
    "src/signed_integers/signed_i32_twos_complement/out/debug/i32_twos_complement_test-abi.json"
);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_i32_twos_complement_test_script() {
        let path_to_bin =
            "src/signed_integers/signed_i32_twos_complement/out/debug/i32_twos_complement_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = Testi32TwosComplement::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
