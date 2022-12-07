use super::utils::{
    abi_calls::{
        push,
        get,
    }, 
    test_helpers::{
      setup,  
    },    
};

#[tokio::test]
pub async fn can_push() {
    let instance = setup().await;

    push(&instance, 1, 50).await;
    push(&instance, 1, 100).await;
    push(&instance, 1, 150).await;

    push(&instance, 2, 50).await;
    push(&instance, 2, 100).await;
    push(&instance, 2, 150).await;

    let first_vec = [get(&instance, 1, 0).await.unwrap(), get(&instance, 1, 1).await.unwrap(), get(&instance, 1, 2).await.unwrap()];
    assert_eq!([50, 100, 150], first_vec);

    let second_vec = [get(&instance, 2, 0).await.unwrap(), get(&instance, 2, 1).await.unwrap(), get(&instance, 2, 2).await.unwrap()];
    assert_eq!([50, 100, 150], second_vec);
}