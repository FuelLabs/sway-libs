use crate::storage_string::tests::utils::{
    abi_calls::{store_string, stored_len},
    test_helpers::setup,
    String,
};
use fuels::prelude::Bytes;

#[tokio::test]
async fn get_string_length() {
    let instance = setup().await;

    let string = "Fuel is blazingly fast!";
    let input = String {
        bytes: Bytes(string.as_bytes().to_vec()),
    };

    assert_eq!(stored_len(&instance).await, 0);

    store_string(input.clone(), &instance).await;

    assert_eq!(stored_len(&instance).await, string.as_bytes().len() as u64);
}
