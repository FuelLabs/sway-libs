use fuels::prelude::{abigen, launch_provider_and_get_wallet};

abigen!(Script(
    name = "TestUfp32Root",
    abi = "src/fixed_point/ufp32_root_test/out/release/ufp32_root_test-abi.json"
),);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ufp32_root_test_script() {
        let path_to_bin = "src/fixed_point/ufp32_root_test/out/release/ufp32_root_test.bin";

        let wallet = launch_provider_and_get_wallet().await.unwrap();

        let instance = TestUfp32Root::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
