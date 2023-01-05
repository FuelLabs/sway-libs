use super::utils::{
    abi_calls::{get, push, swap},
    test_helpers::setup,
};

#[tokio::test]
pub async fn can_swap() {
    let instance = setup().await;

    push(&instance, 1, 50).await;
    push(&instance, 1, 100).await;
    push(&instance, 1, 150).await;

    push(&instance, 2, 200).await;
    push(&instance, 2, 250).await;
    push(&instance, 2, 300).await;

    swap(&instance, 1, 0, 2).await;
    swap(&instance, 2, 0, 2).await;

    let first_vec = [
        get(&instance, 1, 0).await.unwrap(),
        get(&instance, 1, 1).await.unwrap(),
        get(&instance, 1, 2).await.unwrap(),
    ];
    assert_eq!([150, 100, 50], first_vec);

    let second_vec = [
        get(&instance, 2, 0).await.unwrap(),
        get(&instance, 2, 1).await.unwrap(),
        get(&instance, 2, 2).await.unwrap(),
    ];
    assert_eq!([300, 250, 200], second_vec);
}