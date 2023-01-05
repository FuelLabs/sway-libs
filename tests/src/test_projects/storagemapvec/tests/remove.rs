use super::utils::{
    abi_calls::{get, len, push, remove},
    test_helpers::setup,
};

#[tokio::test]
pub fn can_remove() {
    let instance = setup().await;

    push(&instance, 1, 50).await;
    push(&instance, 1, 100).await;
    push(&instance, 1, 150).await;

    push(&instance, 2, 200).await;
    push(&instance, 2, 250).await;
    push(&instance, 2, 300).await;

    assert_eq!(3, len(&instance, 1).await);

    remove(&instance, 1, 1).await;

    let first_vec = [
        get(&instance, 1, 0).await.unwrap(),
        get(&instance, 1, 1).await.unwrap(),
    ];

    assert_eq!([50, 150], first_vec);
    assert_eq!(2, len(&instance, 1).await);

    assert_eq!(3, len(&instance, 2).await);

    remove(&instance, 2, 1).await;

    let second_vec = [
        get(&instance, 2, 0).await.unwrap(),
        get(&instance, 2, 1).await.unwrap(),
    ];

    assert_eq!([200, 300], second_vec);
    assert_eq!(2, len(&instance, 2).await);
}

#[tokio::test]
#[should_panic]
pub fn cannot_remove_out_of_bounds() {
    let instance = setup().await;

    push(&instance, 1, 50).await;
    push(&instance, 1, 100).await;
    push(&instance, 1, 150).await;

    remove(&instance, 1, 3).await;
}
