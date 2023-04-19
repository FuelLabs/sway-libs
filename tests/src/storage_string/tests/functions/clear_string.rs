use crate::storage_string::tests::utils::{
    abi_calls::{clear_string, store_string, stored_len},
    test_helpers::setup,
    String,
};
use fuels::prelude::Bytes;

#[tokio::test]
async fn clears_string() {
    let instance = setup().await;

    let string = "Fuel is blazingly fast!";
    let input = String {
        bytes: Bytes(string.as_bytes().to_vec()),
    };

    assert!(clear_string(&instance).await);

    store_string(input, &instance).await;

    assert_eq!(stored_len(&instance).await, string.as_bytes().len() as u64);

    assert!(clear_string(&instance).await);

    assert_eq!(stored_len(&instance).await, 0);
}
