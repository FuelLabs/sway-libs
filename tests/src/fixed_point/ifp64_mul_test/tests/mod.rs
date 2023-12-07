use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "TestIfp64Mul",
    abi = "src/fixed_point/ifp64_mul_test/out/debug/ifp64_mul_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ifp64_mul_test_script() {
        let path_to_bin = "src/fixed_point/ifp64_mul_test/out/debug/ifp64_mul_test.bin";

        let wallet = launch_provider_and_get_wallet().await.unwrap();

        let instance = TestIfp64Mul::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
