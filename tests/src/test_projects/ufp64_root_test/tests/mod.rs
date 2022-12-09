use fuels::prelude::{script::run_compiled_script, TxParameters};

mod success {

    use super::*;

    #[tokio::test]
    async fn runs_ufp64_root_test_script() {
        let path_to_bin = "../out/debug/ufp64_root_test.bin";

        let _result = run_compiled_script(path_to_bin, TxParameters::default(), None).await;
    }
}
