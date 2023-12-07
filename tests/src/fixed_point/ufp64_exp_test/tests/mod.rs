use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "TestUfp64Exp",
    abi = "src/fixed_point/ufp64_exp_test/out/debug/ufp64_exp_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ufp64_exp_test_script() {
        let path_to_bin = "src/fixed_point/ufp64_exp_test/out/debug/ufp64_exp_test.bin";
        let wallet = launch_provider_and_get_wallet().await.unwrap();

        let instance = TestUfp64Exp::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
