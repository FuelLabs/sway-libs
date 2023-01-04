use fuels::prelude::*;

script_abigen!(
    Testi128,
    "test_projects/signed_i128/out/debug/i128_test-abi.json"
);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_i128_test_script() {
        let path_to_bin = "test_projects/signed_i128/out/debug/i128_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = Testi128::new(wallet, path_to_bin);

        let params = TxParameters::new(Some(1), Some(10000000), None);
        let _result = instance.main().tx_params(params).call().await;
        let logs = _result.as_ref().unwrap().get_logs().unwrap();
        println!("{:#?}", logs);
        assert_eq!(_result.is_err(), false);
    }
}
