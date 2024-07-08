use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "Testi256TwosComplement",
    abi = "src/signed_integers/signed_i256_twos_complement/out/release/i256_twos_complement_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_i256_twos_complement_test_script() {
        let path_to_bin =
            "src/signed_integers/signed_i256_twos_complement/out/release/i256_twos_complement_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = Testi256TwosComplement::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
