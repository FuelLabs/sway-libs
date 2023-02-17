use fuels::prelude::*;

abigen!(Script(
    name = "TestUfp128",
    abi = "src/unsigned_numbers/ufp128_test/out/debug/ufp128_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ufp128_test_script() {
        let path_to_bin = "src/unsigned_numbers/ufp128_test/out/debug/ufp128_test.bin";

        let wallet = launch_provider_and_get_wallet().await;

        let instance = TestUfp128::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
