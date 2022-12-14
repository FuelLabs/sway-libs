use super::utils::{
    abi_calls::{push, to_vec_as_tup},
    test_helpers::setup,
};

// TODO: 
// This test uses a function called "to_vec_as_tup" which returns the first 3 elements of the vector as a tuple. 
// This is a temporary solution until we can return a vector from a contract call. (see https://github.com/FuelLabs/sway/issues/2900)
#[tokio::test]
pub async fn can_convert_to_vec() {
    let instance = setup().await;

    push(&instance, 1, 50).await;
    push(&instance, 1, 100).await;
    push(&instance, 1, 150).await;

    push(&instance, 2, 200).await;
    push(&instance, 2, 250).await;
    push(&instance, 2, 300).await;

    let first_vec = to_vec_as_tup(&instance, 1).await;
    assert_eq!((50, 100, 150), first_vec);

    let second_vec = to_vec_as_tup(&instance, 2).await;
    assert_eq!((200, 250, 300), second_vec);
}
