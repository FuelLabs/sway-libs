use super::utils::{
    abi_calls::{get, push, swap_remove, len},
    test_helpers::setup,
};

#[tokio::test]
pub async fn can_swap_remove() {
    let instance = setup().await;

    push(&instance, 1, 50).await;
    push(&instance, 1, 100).await;
    push(&instance, 1, 150).await;

    push(&instance, 2, 200).await;
    push(&instance, 2, 250).await;
    push(&instance, 2, 300).await;

    swap_remove(&instance, 1, 0).await;
    swap_remove(&instance, 2, 0).await;

    let first_vec = [
        get(&instance, 1, 0).await.unwrap(),
        get(&instance, 1, 1).await.unwrap(),
    ];

    assert_eq!([150, 100], first_vec);
    assert_eq!(len(&instance, 1).await, 2);

    let second_vec = [
        get(&instance, 2, 0).await.unwrap(),
        get(&instance, 2, 1).await.unwrap(),
    ];

    assert_eq!([300, 250], second_vec);
    assert_eq!(len(&instance, 2).await, 2);
}   