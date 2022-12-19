use fuels::prelude::*;

script_abigen!(
    Testi32,
    "test_projects/signed_i32/out/debug/i32_test-abi.json"
);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_i32_test_script() {
        let path_to_bin = "test_projects/signed_i32/out/debug/i32_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = Testi32::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
