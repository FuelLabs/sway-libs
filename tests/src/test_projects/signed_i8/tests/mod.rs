use fuels::prelude::{script::run_compiled_script, TxParameters};

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_i8_test_script() {
        let path_to_bin = "../out/debug/i8_test.bin";

        let _result = run_compiled_script(path_to_bin, TxParameters::default(), None).await;
    }
}
