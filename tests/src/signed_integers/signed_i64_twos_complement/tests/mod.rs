use fuels::prelude::*;

script_abigen!(
    Testi64TwosComplement,
    "src/signed_integers/signed_i64_twos_complement/out/debug/i64_twos_complement_test-abi.json"
);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_i64_twos_complement_test_script() {
        let path_to_bin = "src/signed_integers/signed_i64_twos_complement/out/debug/i64_twos_complement_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = Testi64TwosComplement::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
