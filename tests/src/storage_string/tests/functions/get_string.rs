use crate::storage_string::tests::utils::{
    abi_calls::{get_string, store_string},
    test_helpers::setup,
    String,
};
use fuels::prelude::Bytes;

#[tokio::test]
async fn gets_string_length() {
    let instance = setup().await;

    let string = "Fuel is blazingly fast!";
    let input = String {
        bytes: Bytes(string.as_bytes().to_vec()),
    };

    assert_eq!(get_string(&instance).await, Bytes(vec![]));

    store_string(input.clone(), &instance).await;

    assert_eq!(get_string(&instance).await, input.bytes);
}
