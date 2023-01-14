// use super::utils::{
//     abi_calls::{get, insert, push},
//     test_helpers::setup,
// };

// #[tokio::test]
// pub async fn can_insert() {
//     let instance = setup().await;

//     push(&instance, 1, 50).await;
//     push(&instance, 1, 100).await;

//     insert(&instance, 1, 1, 150).await;

//     push(&instance, 2, 200).await;
//     push(&instance, 2, 250).await;

//     insert(&instance, 2, 1, 300).await;

//     let first_vec = [
//         get(&instance, 1, 0).await.unwrap(),
//         get(&instance, 1, 1).await.unwrap(),
//         get(&instance, 1, 2).await.unwrap(),
//     ];

//     assert_eq!([50, 150, 100], first_vec);

//     let second_vec = [
//         get(&instance, 2, 0).await.unwrap(),
//         get(&instance, 2, 1).await.unwrap(),
//         get(&instance, 2, 2).await.unwrap(),
//     ];

//     assert_eq!([200, 300, 250], second_vec);
// }

// #[tokio::test]
// #[should_panic]
// pub async fn cannot_insert_out_of_bounds() {
//     let instance = setup().await;

//     push(&instance, 1, 50).await;
//     push(&instance, 1, 100).await;

//     insert(&instance, 1, 3, 150).await;
// }
