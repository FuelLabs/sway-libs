use fuels::prelude::*;

abigen!(Script(
    name = "TestUfp32Mul",
    abi = "src/unsigned_numbers/ufp32_mul_test/out/debug/ufp32_mul_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ufp32_mul_test_script() {
        let path_to_bin = "src/unsigned_numbers/ufp32_mul_test/out/debug/ufp32_mul_test.bin";

        let wallet = launch_provider_and_get_wallet().await;

        let instance = TestUfp32Mul::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
