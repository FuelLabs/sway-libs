use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "TestUfp64Pow",
    abi = "src/fixed_point/ufp64_pow_test/out/release/ufp64_pow_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ufp64_pow_test_script() {
        let path_to_bin = "src/fixed_point/ufp64_pow_test/out/release/ufp64_pow_test.bin";
        let wallet = launch_provider_and_get_wallet().await.unwrap();

        let instance = TestUfp64Pow::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
