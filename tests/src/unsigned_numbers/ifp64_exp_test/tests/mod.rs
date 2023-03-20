use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "TestIfp64Exp",
    abi = "src/unsigned_numbers/ifp64_exp_test/out/debug/ifp64_exp_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ifp64_exp_test_script() {
        let path_to_bin = "src/unsigned_numbers/ifp64_exp_test/out/debug/ifp64_exp_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = TestIfp64Exp::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
