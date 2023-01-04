use fuels::prelude::*;

script_abigen!(
    Testi16,
    "test_projects/signed_i16/out/debug/i16_test-abi.json"
);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_i16_test_script() {
        let path_to_bin = "test_projects/signed_i16/out/debug/i16_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = Testi16::new(wallet, path_to_bin);

        let params = TxParameters::new(Some(1), Some(10_000_000), None);
        let result = instance.main().tx_params(params).call().await;
        assert_eq!(result.is_err(), false);
    }
}
