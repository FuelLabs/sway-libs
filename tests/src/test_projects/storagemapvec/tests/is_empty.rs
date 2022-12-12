use super::utils::{
    abi_calls::{clear, is_empty, len, push},
    test_helpers::setup,
};

#[tokio::test]
pub async fn can_get_is_empty() {
    let instance = setup().await;

    push(&instance, 1, 50).await;
    push(&instance, 1, 100).await;
    push(&instance, 1, 150).await;

    push(&instance, 2, 200).await;
    push(&instance, 2, 250).await;
    push(&instance, 2, 300).await;

    assert_eq!(3, len(&instance, 1).await);
    assert_eq!(false, is_empty(&instance, 1).await);
    clear(&instance, 1).await;
    assert_eq!(0, len(&instance, 1).await);
    assert_eq!(true, is_empty(&instance, 1).await);

    assert_eq!(3, len(&instance, 2).await);
    assert_eq!(false, is_empty(&instance, 2).await);
    clear(&instance, 2).await;
    assert_eq!(0, len(&instance, 2).await);
    assert_eq!(true, is_empty(&instance, 2).await);
}

