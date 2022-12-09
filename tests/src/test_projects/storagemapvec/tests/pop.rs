use super::utils::{
    abi_calls::{pop, push},
    test_helpers::setup,
};

#[tokio::test]
pub async fn can_pop() {
    let instance = setup().await;

    push(&instance, 1, 50).await;
    push(&instance, 1, 100).await;
    push(&instance, 1, 150).await;

    push(&instance, 2, 200).await;
    push(&instance, 2, 250).await;
    push(&instance, 2, 300).await;

    let first_vec = [
        pop(&instance, 1).await.unwrap(),
        pop(&instance, 1).await.unwrap(),
        pop(&instance, 1).await.unwrap(),
    ];
    assert_eq!([150, 100, 50], first_vec);

    let second_vec = [
        pop(&instance, 2).await.unwrap(),
        pop(&instance, 2).await.unwrap(),
        pop(&instance, 2).await.unwrap(),
    ];
    assert_eq!([300, 250, 200], second_vec);
}
