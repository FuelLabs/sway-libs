use fuels::prelude::{script::run_compiled_script, TxParameters};

mod success {

    use super::*;

    // TODO: This should not be ignored once the i256 library will compile
    #[ignore]
    #[tokio::test]
    async fn runs_i256_test_script() {
        let path_to_bin = "../out/debug/i256_test.bin";

        let _result = run_compiled_script(path_to_bin, TxParameters::default()).await;
    }
}
