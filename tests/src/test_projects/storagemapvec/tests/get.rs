use super::utils::{
    abi_calls::{get, push},
    test_helpers::setup,
};

#[tokio::test]
pub async fn can_get() {
    let instance = setup().await;

    push(&instance, 1, 50).await;
    push(&instance, 1, 100).await;
    push(&instance, 1, 150).await;

    push(&instance, 2, 200).await;
    push(&instance, 2, 250).await;
    push(&instance, 2, 300).await;

    let first_vec = [
        get(&instance, 1, 0).await.unwrap(),
        get(&instance, 1, 1).await.unwrap(),
        get(&instance, 1, 2).await.unwrap(),
    ];
    assert_eq!([50, 100, 150], first_vec);

    let second_vec = [
        get(&instance, 2, 0).await.unwrap(),
        get(&instance, 2, 1).await.unwrap(),
        get(&instance, 2, 2).await.unwrap(),
    ];
    assert_eq!([200, 250, 300], second_vec);
}

#[tokio::test]
#[should_panic]
pub async fn cannot_get_out_of_bounds() {
    let instance = setup().await;

    push(&instance, 1, 50).await;
    push(&instance, 1, 100).await;
    push(&instance, 1, 150).await;

    get(&instance, 1, 3).await.unwrap();
}