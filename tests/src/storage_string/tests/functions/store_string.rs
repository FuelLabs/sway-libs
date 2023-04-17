use crate::storage_string::tests::utils::{
    abi_calls::{get_string, store_string, stored_len},
    test_helpers::setup,
    String,
};
use fuels::prelude::Bytes;

#[tokio::test]
async fn stores_string() {
    let instance = setup().await;

    let string = "Fuel is blazingly fast!";
    let input = String {
        bytes: Bytes(string.as_bytes().to_vec()),
    };

    assert_eq!(get_string(&instance).await, Bytes(vec![]));
    assert_eq!(stored_len(&instance).await, 0);

    store_string(input.clone(), &instance).await;

    assert_eq!(get_string(&instance).await, input.bytes);
    assert_eq!(stored_len(&instance).await, string.as_bytes().len() as u64);
}

#[tokio::test]
async fn stores_long_string() {
    let instance = setup().await;

    // 2060 bytes
    let string = "Nam quis nulla. Integer malesuada. In in enim a arcu imperdiet malesuada. Sed vel lectus. Donec odio urna, tempus molestie, porttitor ut, iaculis quis, sem. Phasellus rhoncus. Aenean id metus id velit ullamcorper pulvinar. Vestibulum fermentum tortor id mi. Pellentesque ipsum. Nulla non arcu lacinia neque faucibus fringilla. Nulla non lectus sed nisl molestie malesuada. Proin in tellus sit amet nibh dignissim sagittis. Vivamus luctus egestas leo. Maecenas sollicitudin. Nullam rhoncus aliquam metus. Etiam egestas wisi a erat.
    Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nullam feugiat, turpis at pulvinar vulputate, erat libero tristique tellus, nec bibendum odio risus sit amet ante. Aliquam erat volutpat. Nunc auctor. Mauris pretium quam et urna. Fusce nibh. Duis risus. Curabitur sagittis hendrerit ante. Aliquam erat volutpat. Vestibulum erat nulla, ullamcorper nec, rutrum non, nonummy ac, erat. Duis condimentum augue id magna semper rutrum. Nullam justo enim, consectetuer nec, ullamcorper ac, vestibulum in, elit. Proin pede metus, vulputate nec, fermentum fringilla, vehicula vitae, justo. Fusce consectetuer risus a nunc. Aliquam ornare wisi eu metus. Integer pellentesque quam vel velit. Duis pulvinar.
    Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Morbi gravida libero nec velit. Morbi scelerisque luctus velit. Etiam dui sem, fermentum vitae, sagittis id, malesuada in, quam. Proin mattis lacinia justo. Vestibulum facilisis auctor urna. Aliquam in lorem sit amet leo accumsan lacinia. Integer rutrum, orci vestibulum ullamcorper ultricies, lacus quam ultricies odio, vitae placerat pede sem sit amet enim. Phasellus et lorem id felis nonummy placerat. Fusce dui leo, imperdiet in, aliquam sit amet, feugiat eu, orci. Aenean vel massa quis mauris vehicula lacinia. Quisque tincidunt scelerisque libero. Maecenas libero. Etiam dictum tincidunt diam. Donec ipsum massa, ullamcorper in, auctor et, scelerisque sed, est. Suspendisse nisl. Sed convallis magna eu sem. Cras pede libero, dapibus nec, pretium";
    let input = String {
        bytes: Bytes(string.as_bytes().to_vec()),
    };

    assert_eq!(stored_len(&instance).await, 0);

    store_string(input.clone(), &instance).await;

    assert_eq!(stored_len(&instance).await, string.as_bytes().len() as u64);
    assert_eq!(get_string(&instance).await, input.bytes);
}

#[tokio::test]
async fn stores_string_twice() {
    let instance = setup().await;

    let string1 = "Fuel is the fastest modular execution layer";
    let string2 = "Fuel is blazingly fast!";
    let input1 = String {
        bytes: Bytes(string1.as_bytes().to_vec()),
    };
    let input2 = String {
        bytes: Bytes(string2.as_bytes().to_vec()),
    };

    store_string(input1.clone(), &instance).await;

    assert_eq!(get_string(&instance).await, input1.bytes);
    assert_eq!(stored_len(&instance).await, string1.as_bytes().len() as u64);

    store_string(input2.clone(), &instance).await;

    assert_eq!(get_string(&instance).await, input2.bytes);
    assert_eq!(stored_len(&instance).await, string2.as_bytes().len() as u64);
}
