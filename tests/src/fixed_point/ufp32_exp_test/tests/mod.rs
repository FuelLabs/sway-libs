use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "TestUfp32Exp",
    abi = "src/fixed_point/ufp32_exp_test/out/debug/ufp32_exp_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ufp32_exp_test_script() {
        let path_to_bin = "src/fixed_point/ufp32_exp_test/out/debug/ufp32_exp_test.bin";
        let wallet = launch_provider_and_get_wallet().await;

        let instance = TestUfp32Exp::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
