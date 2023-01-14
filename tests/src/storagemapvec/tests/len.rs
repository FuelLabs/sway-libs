use super::utils::{
    abi_calls::{len, push},
    test_helpers::setup,
};

#[tokio::test]
pub async fn can_get_len() {
    let instance = setup().await;

    push(&instance, 1, 50).await;
    assert_eq!(1, len(&instance, 1).await);
    push(&instance, 1, 100).await;
    assert_eq!(2, len(&instance, 1).await);
    push(&instance, 1, 150).await;
    assert_eq!(3, len(&instance, 1).await);

    push(&instance, 2, 200).await;
    assert_eq!(1, len(&instance, 2).await);
    push(&instance, 2, 250).await;
    assert_eq!(2, len(&instance, 2).await);
    push(&instance, 2, 300).await;
    assert_eq!(3, len(&instance, 2).await);
}
