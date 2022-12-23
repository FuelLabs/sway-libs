use fuels::prelude::*;

script_abigen!(
    TestUfp64Root,
    "test_projects/ufp64_root_test/out/debug/ufp64_root_test-abi.json"
);

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ufp64_root_test_script() {
        let path_to_bin = "test_projects/ufp64_root_test/out/debug/ufp64_root_test.bin";

        let wallet = launch_provider_and_get_wallet().await;

        let instance = TestUfp64Root::new(wallet, path_to_bin);

        let _result = instance.main().call().await;
    }
}
