library;

use hash_map::*;

#[test]
fn hash_map_new() {
    let new_map: HashMap<u64, u64> = HashMap::new();

    assert(new_map.len() == 0);
    assert(new_map.capacity() == 0);
    assert(new_map.keys().len() == 0);
    assert(new_map.values().len() == 0);
}

#[test]
fn hash_map_with_capacity() {
    let new_map_1: HashMap<u64, u64> = HashMap::with_capacity(0);
    assert(new_map_1.len() == 0);
    assert(new_map_1.capacity() == 0);
    assert(new_map_1.keys().len() == 0);
    assert(new_map_1.values().len() == 0);

    let new_map_2: HashMap<u64, u64> = HashMap::with_capacity(1);
    assert(new_map_2.len() == 0);
    assert(new_map_2.capacity() == 1);
    assert(new_map_2.keys().len() == 0);
    assert(new_map_2.values().len() == 0);

    let new_map_3: HashMap<u8, u8> = HashMap::with_capacity(u16::max());
    assert(new_map_3.len() == 0);
    assert(new_map_3.capacity() == u16::max());
    assert(new_map_3.keys().len() == 0);
    assert(new_map_3.values().len() == 0);
}

#[test]
fn hash_map_insert() {
    let mut maps: HashMap<u64, u64> = HashMap::new();

    assert(maps.get(1).is_none());
    let res = maps.insert(1, 10);
    assert(res == None);
    assert(maps.get(1).unwrap() == 10);

    assert(maps.get(2).is_none());
    let res = maps.insert(2, 11);
    assert(res == None);
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);

    assert(maps.get(3).is_none());
    let res = maps.insert(3, 12);
    assert(res == None);
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);

    assert(maps.get(4).is_none());
    let res = maps.insert(4, 13);
    assert(res == None);
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);

    assert(maps.get(5).is_none());
    let res = maps.insert(5, 13);
    assert(res == None);
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);

    assert(maps.get(6).is_none());
    let res = maps.insert(6, 0);
    assert(res == None);
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);

    assert(maps.get(1).is_some());
    let res = maps.insert(1, 0);
    assert(res == Some(10));
    assert(maps.get(1).unwrap() == 0);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);

    assert(maps.get(u64::max()).is_none());
    let res = maps.insert(u64::max(), u64::max());
    assert(res == None);
    assert(maps.get(1).unwrap() == 0);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);
    assert(maps.get(u64::max()).unwrap() == u64::max());

    assert(maps.get(0).is_none());
    let res = maps.insert(0, 0);
    assert(res == None);
    assert(maps.get(1).unwrap() == 0);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);
    assert(maps.get(u64::max()).unwrap() == u64::max());
    assert(maps.get(0).unwrap() == 0);
}

#[test]
fn hash_map_insert_reference_type() {
    let mut maps: HashMap<b256, b256> = HashMap::new();

    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .is_none(),
    );
    let res = maps.insert(
        0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d,
        0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(res == None);
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );

    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .is_none(),
    );
    let res = maps.insert(
        0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f,
        0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(res == None);
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );

    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .is_none(),
    );
    let res = maps.insert(
        0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f,
        0x00000000000000000000000000000000000000000000000000000000000000a3,
    );
    assert(res == None);
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a3,
    );

    assert(
        maps
            .get(0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5)
            .is_none(),
    );
    let res = maps.insert(
        0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5,
        0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(res == None);
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a3,
    );
    assert(
        maps
            .get(0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );

    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e15fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .is_none(),
    );
    let res = maps.insert(
        0xe0cef4b9cb0706cfa4aa174e15fb006b8ddd2a0ecd6296a27c0a05dcb856f32f,
        0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(res == None);
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a3,
    );
    assert(
        maps
            .get(0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e15fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );

    assert(
        maps
            .get(0xe0cef4b9cb0706c1a4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .is_none(),
    );
    let res = maps.insert(
        0xe0cef4b9cb0706c1a4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f,
        b256::zero(),
    );
    assert(res == None);
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a3,
    );
    assert(
        maps
            .get(0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e15fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706c1a4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == b256::zero(),
    );

    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .is_some(),
    );
    let res = maps.insert(
        0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d,
        b256::zero(),
    );
    assert(res == Some(0x00000000000000000000000000000000000000000000000000000000000000a1));
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == b256::zero(),
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a3,
    );
    assert(
        maps
            .get(0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e15fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706c1a4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == b256::zero(),
    );

    assert(maps.get(b256::max()).is_none());
    let res = maps.insert(b256::max(), b256::max());
    assert(res == None);
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == b256::zero(),
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a3,
    );
    assert(
        maps
            .get(0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e15fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706c1a4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == b256::zero(),
    );
    assert(maps.get(b256::max()).unwrap() == b256::max());

    assert(maps.get(b256::zero()).is_none());
    let res = maps.insert(b256::zero(), b256::zero());
    assert(res == None);
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == b256::zero(),
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a3,
    );
    assert(
        maps
            .get(0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e15fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706c1a4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == b256::zero(),
    );
    assert(maps.get(b256::max()).unwrap() == b256::max());
    assert(maps.get(b256::zero()).unwrap() == b256::zero());
}

#[test]
fn hash_map_insert_byte() {
    let mut maps: HashMap<u8, u8> = HashMap::new();

    assert(maps.get(1u8).is_none());
    let res = maps.insert(1u8, 10u8);
    assert(res == None);
    assert(maps.get(1u8).unwrap() == 10u8);

    assert(maps.get(2u8).is_none());
    let res = maps.insert(2u8, 11u8);
    assert(res == None);
    assert(maps.get(1u8).unwrap() == 10u8);
    assert(maps.get(2u8).unwrap() == 11u8);

    assert(maps.get(3u8).is_none());
    let res = maps.insert(3u8, 12u8);
    assert(res == None);
    assert(maps.get(1u8).unwrap() == 10u8);
    assert(maps.get(2u8).unwrap() == 11u8);
    assert(maps.get(3u8).unwrap() == 12u8);

    assert(maps.get(4u8).is_none());
    let res = maps.insert(4u8, 13u8);
    assert(res == None);
    assert(maps.get(1u8).unwrap() == 10u8);
    assert(maps.get(2u8).unwrap() == 11u8);
    assert(maps.get(3u8).unwrap() == 12u8);
    assert(maps.get(4u8).unwrap() == 13u8);

    assert(maps.get(5u8).is_none());
    let res = maps.insert(5u8, 13u8);
    assert(res == None);
    assert(maps.get(1u8).unwrap() == 10u8);
    assert(maps.get(2u8).unwrap() == 11u8);
    assert(maps.get(3u8).unwrap() == 12u8);
    assert(maps.get(4u8).unwrap() == 13u8);
    assert(maps.get(5u8).unwrap() == 13u8);

    assert(maps.get(6u8).is_none());
    let res = maps.insert(6u8, 0u8);
    assert(res == None);
    assert(maps.get(1u8).unwrap() == 10u8);
    assert(maps.get(2u8).unwrap() == 11u8);
    assert(maps.get(3u8).unwrap() == 12u8);
    assert(maps.get(4u8).unwrap() == 13u8);
    assert(maps.get(5u8).unwrap() == 13u8);
    assert(maps.get(6u8).unwrap() == 0u8);

    assert(maps.get(1u8).is_some());
    let res = maps.insert(1u8, 0u8);
    assert(res == Some(10u8));
    assert(maps.get(1u8).unwrap() == 0u8);
    assert(maps.get(2u8).unwrap() == 11u8);
    assert(maps.get(3u8).unwrap() == 12u8);
    assert(maps.get(4u8).unwrap() == 13u8);
    assert(maps.get(5u8).unwrap() == 13u8);
    assert(maps.get(6u8).unwrap() == 0u8);

    assert(maps.get(u8::max()).is_none());
    let res = maps.insert(u8::max(), u8::max());
    assert(res == None);
    assert(maps.get(1u8).unwrap() == 0u8);
    assert(maps.get(2u8).unwrap() == 11u8);
    assert(maps.get(3u8).unwrap() == 12u8);
    assert(maps.get(4u8).unwrap() == 13u8);
    assert(maps.get(5u8).unwrap() == 13u8);
    assert(maps.get(6u8).unwrap() == 0u8);
    assert(maps.get(u8::max()).unwrap() == u8::max());

    assert(maps.get(0u8).is_none());
    let res = maps.insert(0u8, 0u8);
    assert(res == None);
    assert(maps.get(1u8).unwrap() == 0u8);
    assert(maps.get(2u8).unwrap() == 11u8);
    assert(maps.get(3u8).unwrap() == 12u8);
    assert(maps.get(4u8).unwrap() == 13u8);
    assert(maps.get(5u8).unwrap() == 13u8);
    assert(maps.get(6u8).unwrap() == 0u8);
    assert(maps.get(u8::max()).unwrap() == u8::max());
    assert(maps.get(0u8).unwrap() == 0u8);
}

#[test]
fn hash_map_try_insert() {
    let mut maps: HashMap<u64, u64> = HashMap::new();

    assert(maps.get(1).is_none());
    let res = maps.try_insert(1, 10);
    assert(res == Ok(10));
    assert(maps.get(1).unwrap() == 10);

    assert(maps.get(2).is_none());
    let res = maps.try_insert(2, 11);
    assert(res == Ok(11));
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);

    assert(maps.get(3).is_none());
    let res = maps.try_insert(3, 12);
    assert(res == Ok(12));
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);

    assert(maps.get(4).is_none());
    let res = maps.try_insert(4, 13);
    assert(res == Ok(13));
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);

    assert(maps.get(5).is_none());
    let res = maps.try_insert(5, 13);
    assert(res == Ok(13));
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);

    assert(maps.get(6).is_none());
    let res = maps.try_insert(6, 0);
    assert(res == Ok(0));
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);

    assert(maps.get(1).is_some());
    let res = maps.try_insert(1, 0);
    assert(res == Err(HashMapError::OccupiedError(10)));
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);

    assert(maps.get(u64::max()).is_none());
    let res = maps.try_insert(u64::max(), u64::max());
    assert(res == Ok(u64::max()));
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);
    assert(maps.get(u64::max()).unwrap() == u64::max());

    assert(maps.get(0).is_none());
    let res = maps.try_insert(0, 0);
    assert(res == Ok(0));
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);
    assert(maps.get(u64::max()).unwrap() == u64::max());
    assert(maps.get(0).unwrap() == 0);

    assert(maps.get(0).is_some());
    let res = maps.try_insert(0, 0);
    assert(res == Err(HashMapError::OccupiedError(0)));
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);
    assert(maps.get(u64::max()).unwrap() == u64::max());
    assert(maps.get(0).unwrap() == 0);

    assert(maps.get(u64::max()).is_some());
    let res = maps.try_insert(u64::max(), u64::max() - 1);
    assert(res == Err(HashMapError::OccupiedError(u64::max())));
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);
    assert(maps.get(u64::max()).unwrap() == u64::max());
}

#[test]
fn hash_map_try_insert_reference_type() {
    let mut maps: HashMap<b256, b256> = HashMap::new();

    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .is_none(),
    );
    let res = maps.try_insert(
        0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d,
        0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(res == Ok(0x00000000000000000000000000000000000000000000000000000000000000a1));
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );

    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .is_none(),
    );
    let res = maps.try_insert(
        0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f,
        0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(res == Ok(0x00000000000000000000000000000000000000000000000000000000000000a2));
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );

    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .is_none(),
    );
    let res = maps.try_insert(
        0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f,
        0x00000000000000000000000000000000000000000000000000000000000000a3,
    );
    assert(res == Ok(0x00000000000000000000000000000000000000000000000000000000000000a3));
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a3,
    );

    assert(
        maps
            .get(0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5)
            .is_none(),
    );
    let res = maps.try_insert(
        0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5,
        0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(res == Ok(0x00000000000000000000000000000000000000000000000000000000000000a4));
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a3,
    );
    assert(
        maps
            .get(0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );

    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e15fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .is_none(),
    );
    let res = maps.try_insert(
        0xe0cef4b9cb0706cfa4aa174e15fb006b8ddd2a0ecd6296a27c0a05dcb856f32f,
        0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(res == Ok(0x00000000000000000000000000000000000000000000000000000000000000a4));
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a3,
    );
    assert(
        maps
            .get(0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e15fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );

    assert(
        maps
            .get(0xe0cef4b9cb0706c1a4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .is_none(),
    );
    let res = maps.try_insert(
        0xe0cef4b9cb0706c1a4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f,
        b256::zero(),
    );
    assert(res == Ok(b256::zero()));
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a3,
    );
    assert(
        maps
            .get(0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e15fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706c1a4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == b256::zero(),
    );

    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .is_some(),
    );
    let res = maps.try_insert(
        0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d,
        b256::zero(),
    );
    assert(
        res == Err(HashMapError::OccupiedError(0x00000000000000000000000000000000000000000000000000000000000000a1)),
    );
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a3,
    );
    assert(
        maps
            .get(0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e15fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706c1a4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == b256::zero(),
    );

    assert(maps.get(b256::max()).is_none());
    let res = maps.try_insert(b256::max(), b256::max());
    assert(res == Ok(b256::max()));
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a3,
    );
    assert(
        maps
            .get(0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e15fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706c1a4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == b256::zero(),
    );
    assert(maps.get(b256::max()).unwrap() == b256::max());

    assert(maps.get(b256::zero()).is_none());
    let res = maps.try_insert(b256::zero(), b256::zero());
    assert(res == Ok(b256::zero()));
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a3,
    );
    assert(
        maps
            .get(0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e15fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706c1a4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == b256::zero(),
    );
    assert(maps.get(b256::max()).unwrap() == b256::max());
    assert(maps.get(b256::zero()).unwrap() == b256::zero());

    assert(maps.get(b256::zero()).is_some());
    let res = maps.try_insert(b256::zero(), b256::zero());
    assert(res == Err(HashMapError::OccupiedError(b256::zero())));
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a3,
    );
    assert(
        maps
            .get(0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e15fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706c1a4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == b256::zero(),
    );
    assert(maps.get(b256::max()).unwrap() == b256::max());
    assert(maps.get(b256::zero()).unwrap() == b256::zero());

    assert(maps.get(b256::max()).is_some());
    let res = maps.try_insert(
        b256::max(),
        b256::from(
            u256::max() - 0x0000000000000000000000000000000000000000000000000000000000000001u256,
        ),
    );
    assert(res == Err(HashMapError::OccupiedError(b256::max())));
    assert(
        maps
            .get(0x38d1786f24d5547780e48992ad12c12d6aeb6b06ccf0aa699dea36aafccad94d)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a1,
    );
    assert(
        maps
            .get(0xe0ced4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a2,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a3,
    );
    assert(
        maps
            .get(0xa139623f3a64240ac2919443bd827e1f80a576c63311efd23423c91cbedb13c5)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706cfa4aa174e15fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == 0x00000000000000000000000000000000000000000000000000000000000000a4,
    );
    assert(
        maps
            .get(0xe0cef4b9cb0706c1a4aa174e75fb006b8ddd2a0ecd6296a27c0a05dcb856f32f)
            .unwrap() == b256::zero(),
    );
    assert(maps.get(b256::max()).unwrap() == b256::max());
    assert(maps.get(b256::zero()).unwrap() == b256::zero());
}

#[test]
fn hash_map_try_insert_byte() {
    let mut maps: HashMap<u8, u8> = HashMap::new();

    assert(maps.get(1u8).is_none());
    let res = maps.try_insert(1u8, 10u8);
    assert(res == Ok(10u8));
    assert(maps.get(1u8).unwrap() == 10u8);

    assert(maps.get(2u8).is_none());
    let res = maps.try_insert(2u8, 11u8);
    assert(res == Ok(11u8));
    assert(maps.get(1u8).unwrap() == 10u8);
    assert(maps.get(2u8).unwrap() == 11u8);

    assert(maps.get(3u8).is_none());
    let res = maps.try_insert(3u8, 12u8);
    assert(res == Ok(12u8));
    assert(maps.get(1u8).unwrap() == 10u8);
    assert(maps.get(2u8).unwrap() == 11u8);
    assert(maps.get(3u8).unwrap() == 12u8);

    assert(maps.get(4u8).is_none());
    let res = maps.try_insert(4u8, 13u8);
    assert(res == Ok(13u8));
    assert(maps.get(1u8).unwrap() == 10u8);
    assert(maps.get(2u8).unwrap() == 11u8);
    assert(maps.get(3u8).unwrap() == 12u8);
    assert(maps.get(4u8).unwrap() == 13u8);

    assert(maps.get(5u8).is_none());
    let res = maps.try_insert(5u8, 13u8);
    assert(res == Ok(13u8));
    assert(maps.get(1u8).unwrap() == 10u8);
    assert(maps.get(2u8).unwrap() == 11u8);
    assert(maps.get(3u8).unwrap() == 12u8);
    assert(maps.get(4u8).unwrap() == 13u8);
    assert(maps.get(5u8).unwrap() == 13u8);

    assert(maps.get(6u8).is_none());
    let res = maps.try_insert(6u8, 0u8);
    assert(res == Ok(0u8));
    assert(maps.get(1u8).unwrap() == 10u8);
    assert(maps.get(2u8).unwrap() == 11u8);
    assert(maps.get(3u8).unwrap() == 12u8);
    assert(maps.get(4u8).unwrap() == 13u8);
    assert(maps.get(5u8).unwrap() == 13u8);
    assert(maps.get(6u8).unwrap() == 0u8);

    assert(maps.get(1u8).is_some());
    let res = maps.try_insert(1u8, 0u8);
    assert(res == Err(HashMapError::OccupiedError(10u8)));
    assert(maps.get(1u8).unwrap() == 10u8);
    assert(maps.get(2u8).unwrap() == 11u8);
    assert(maps.get(3u8).unwrap() == 12u8);
    assert(maps.get(4u8).unwrap() == 13u8);
    assert(maps.get(5u8).unwrap() == 13u8);
    assert(maps.get(6u8).unwrap() == 0u8);

    assert(maps.get(u8::max()).is_none());
    let res = maps.try_insert(u8::max(), u8::max());
    assert(res == Ok(u8::max()));
    assert(maps.get(1u8).unwrap() == 10u8);
    assert(maps.get(2u8).unwrap() == 11u8);
    assert(maps.get(3u8).unwrap() == 12u8);
    assert(maps.get(4u8).unwrap() == 13u8);
    assert(maps.get(5u8).unwrap() == 13u8);
    assert(maps.get(6u8).unwrap() == 0u8);
    assert(maps.get(u8::max()).unwrap() == u8::max());

    assert(maps.get(0u8).is_none());
    let res = maps.try_insert(0u8, 0u8);
    assert(res == Ok(0u8));
    assert(maps.get(1u8).unwrap() == 10u8);
    assert(maps.get(2u8).unwrap() == 11u8);
    assert(maps.get(3u8).unwrap() == 12u8);
    assert(maps.get(4u8).unwrap() == 13u8);
    assert(maps.get(5u8).unwrap() == 13u8);
    assert(maps.get(6u8).unwrap() == 0u8);
    assert(maps.get(u8::max()).unwrap() == u8::max());
    assert(maps.get(0u8).unwrap() == 0u8);

    assert(maps.get(0u8).is_some());
    let res = maps.try_insert(0u8, 0u8);
    assert(res == Err(HashMapError::OccupiedError(0u8)));
    assert(maps.get(1u8).unwrap() == 10u8);
    assert(maps.get(2u8).unwrap() == 11u8);
    assert(maps.get(3u8).unwrap() == 12u8);
    assert(maps.get(4u8).unwrap() == 13u8);
    assert(maps.get(5u8).unwrap() == 13u8);
    assert(maps.get(6u8).unwrap() == 0u8);
    assert(maps.get(u8::max()).unwrap() == u8::max());
    assert(maps.get(0u8).unwrap() == 0u8);

    assert(maps.get(u8::max()).is_some());
    let res = maps.try_insert(u8::max(), u8::max() - 1);
    assert(res == Err(HashMapError::OccupiedError(u8::max())));
    assert(maps.get(1u8).unwrap() == 10u8);
    assert(maps.get(2u8).unwrap() == 11u8);
    assert(maps.get(3u8).unwrap() == 12u8);
    assert(maps.get(4u8).unwrap() == 13u8);
    assert(maps.get(5u8).unwrap() == 13u8);
    assert(maps.get(6u8).unwrap() == 0u8);
    assert(maps.get(u8::max()).unwrap() == u8::max());
    assert(maps.get(0u8).unwrap() == 0u8);
}

#[test]
fn hash_map_remove() {
    let mut maps: HashMap<u64, u64> = HashMap::new();

    let res = maps.remove(1);
    assert(res == None);
    let _ = maps.insert(1, 10);
    assert(maps.get(1).unwrap() == 10);
    let res = maps.remove(1);
    assert(res == Some(10));

    let res = maps.remove(1);
    assert(res == None);
    let _ = maps.insert(1, 10);

    let res = maps.remove(2);
    assert(res == None);
    let _ = maps.insert(2, 11);
    let res = maps.remove(2);
    assert(res == Some(11));
    assert(maps.get(1).unwrap() == 10);

    let _ = maps.insert(2, 11);
    let _ = maps.insert(3, 12);
    let _ = maps.insert(4, 13);
    let _ = maps.insert(5, 13);
    let _ = maps.insert(6, 0);
    let res = maps.remove(1);
    assert(res == Some(10));
    assert(maps.get(1) == None);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);

    let _ = maps.insert(1, 0);
    assert(maps.get(1).unwrap() == 0);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);

    let _ = maps.insert(u64::max(), u64::max());
    let _ = maps.insert(0, 0);
    assert(maps.get(1).unwrap() == 0);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);
    assert(maps.get(u64::max()).unwrap() == u64::max());
    assert(maps.get(0).unwrap() == 0);

    let res = maps.remove(1);
    assert(res == Some(0));
    assert(maps.get(1) == None);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);
    assert(maps.get(u64::max()).unwrap() == u64::max());
    assert(maps.get(0).unwrap() == 0);

    let res = maps.remove(2);
    assert(res == Some(11));
    assert(maps.get(1) == None);
    assert(maps.get(2) == None);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);
    assert(maps.get(u64::max()).unwrap() == u64::max());
    assert(maps.get(0).unwrap() == 0);

    let res = maps.remove(3);
    assert(res == Some(12));
    assert(maps.get(1) == None);
    assert(maps.get(2) == None);
    assert(maps.get(3) == None);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);
    assert(maps.get(u64::max()).unwrap() == u64::max());
    assert(maps.get(0).unwrap() == 0);

    let res = maps.remove(4);
    assert(res == Some(13));
    assert(maps.get(1) == None);
    assert(maps.get(2) == None);
    assert(maps.get(3) == None);
    assert(maps.get(4) == None);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);
    assert(maps.get(u64::max()).unwrap() == u64::max());
    assert(maps.get(0).unwrap() == 0);

    let res = maps.remove(5);
    assert(res == Some(13));
    assert(maps.get(1) == None);
    assert(maps.get(2) == None);
    assert(maps.get(3) == None);
    assert(maps.get(4) == None);
    assert(maps.get(5) == None);
    assert(maps.get(6).unwrap() == 0);
    assert(maps.get(u64::max()).unwrap() == u64::max());
    assert(maps.get(0).unwrap() == 0);

    let res = maps.remove(6);
    assert(res == Some(0));
    assert(maps.get(1) == None);
    assert(maps.get(2) == None);
    assert(maps.get(3) == None);
    assert(maps.get(4) == None);
    assert(maps.get(5) == None);
    assert(maps.get(6) == None);
    assert(maps.get(u64::max()).unwrap() == u64::max());
    assert(maps.get(0).unwrap() == 0);

    let res = maps.remove(u64::max());
    assert(res == Some(u64::max()));
    assert(maps.get(1) == None);
    assert(maps.get(2) == None);
    assert(maps.get(3) == None);
    assert(maps.get(4) == None);
    assert(maps.get(5) == None);
    assert(maps.get(6) == None);
    assert(maps.get(u64::max()) == None);
    assert(maps.get(0).unwrap() == 0);

    let res = maps.remove(0);
    assert(res == Some(0));
    assert(maps.get(1) == None);
    assert(maps.get(2) == None);
    assert(maps.get(3) == None);
    assert(maps.get(4) == None);
    assert(maps.get(5) == None);
    assert(maps.get(6) == None);
    assert(maps.get(u64::max()) == None);
    assert(maps.get(0) == None);

    let res = maps.remove(1);
    assert(res == None);
    let res = maps.remove(2);
    assert(res == None);
    let res = maps.remove(3);
    assert(res == None);
    let res = maps.remove(4);
    assert(res == None);
    let res = maps.remove(5);
    assert(res == None);
    let res = maps.remove(6);
    assert(res == None);
    let res = maps.remove(u64::max());
    assert(res == None);
    let res = maps.remove(0);
    assert(res == None);
}

#[test]
fn hash_map_get() {
    let mut maps: HashMap<u64, u64> = HashMap::new();

    assert(maps.get(1).is_none());
    assert(maps.get(2).is_none());
    assert(maps.get(3).is_none());
    assert(maps.get(4).is_none());
    assert(maps.get(5).is_none());
    assert(maps.get(6).is_none());
    assert(maps.get(u64::max()).is_none());
    assert(maps.get(0).is_none());
    let _ = maps.insert(1, 10);
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).is_none());
    assert(maps.get(3).is_none());
    assert(maps.get(4).is_none());
    assert(maps.get(5).is_none());
    assert(maps.get(6).is_none());
    assert(maps.get(u64::max()).is_none());
    assert(maps.get(0).is_none());

    assert(maps.get(2).is_none());
    assert(maps.get(3).is_none());
    assert(maps.get(4).is_none());
    assert(maps.get(5).is_none());
    assert(maps.get(6).is_none());
    assert(maps.get(u64::max()).is_none());
    assert(maps.get(0).is_none());
    let _ = maps.insert(2, 11);
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).is_none());
    assert(maps.get(4).is_none());
    assert(maps.get(5).is_none());
    assert(maps.get(6).is_none());
    assert(maps.get(u64::max()).is_none());
    assert(maps.get(0).is_none());

    assert(maps.get(3).is_none());
    assert(maps.get(4).is_none());
    assert(maps.get(5).is_none());
    assert(maps.get(6).is_none());
    assert(maps.get(u64::max()).is_none());
    assert(maps.get(0).is_none());
    let _ = maps.insert(3, 12);
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).is_none());
    assert(maps.get(5).is_none());
    assert(maps.get(6).is_none());
    assert(maps.get(u64::max()).is_none());
    assert(maps.get(0).is_none());

    assert(maps.get(4).is_none());
    assert(maps.get(5).is_none());
    assert(maps.get(6).is_none());
    assert(maps.get(u64::max()).is_none());
    assert(maps.get(0).is_none());
    let _ = maps.insert(4, 13);
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).is_none());
    assert(maps.get(6).is_none());
    assert(maps.get(u64::max()).is_none());
    assert(maps.get(0).is_none());

    assert(maps.get(5).is_none());
    assert(maps.get(6).is_none());
    assert(maps.get(u64::max()).is_none());
    let _ = maps.insert(5, 13);
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).is_none());
    assert(maps.get(u64::max()).is_none());
    assert(maps.get(0).is_none());

    assert(maps.get(6).is_none());
    assert(maps.get(u64::max()).is_none());
    assert(maps.get(0).is_none());
    let _ = maps.insert(6, 0);
    assert(maps.get(1).unwrap() == 10);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);
    assert(maps.get(u64::max()).is_none());
    assert(maps.get(0).is_none());

    assert(maps.get(1).is_some());
    assert(maps.get(u64::max()).is_none());
    assert(maps.get(0).is_none());
    let _ = maps.insert(1, 0);
    assert(maps.get(1).unwrap() == 0);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);
    assert(maps.get(u64::max()).is_none());
    assert(maps.get(0).is_none());

    assert(maps.get(u64::max()).is_none());
    assert(maps.get(0).is_none());
    let _ = maps.insert(u64::max(), u64::max());
    assert(maps.get(1).unwrap() == 0);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);
    assert(maps.get(u64::max()).unwrap() == u64::max());
    assert(maps.get(0).is_none());

    assert(maps.get(0).is_none());
    let _ = maps.insert(0, 0);
    assert(maps.get(1).unwrap() == 0);
    assert(maps.get(2).unwrap() == 11);
    assert(maps.get(3).unwrap() == 12);
    assert(maps.get(4).unwrap() == 13);
    assert(maps.get(5).unwrap() == 13);
    assert(maps.get(6).unwrap() == 0);
    assert(maps.get(u64::max()).unwrap() == u64::max());
    assert(maps.get(0).unwrap() == 0);
}

#[test]
fn hash_map_contains_key() {
    let mut maps: HashMap<u64, u64> = HashMap::new();

    assert(maps.contains_key(1) == false);
    assert(maps.contains_key(2) == false);
    assert(maps.contains_key(3) == false);
    assert(maps.contains_key(4) == false);
    assert(maps.contains_key(5) == false);
    assert(maps.contains_key(6) == false);
    assert(maps.contains_key(u64::max()) == false);
    assert(maps.contains_key(0) == false);
    let _ = maps.insert(1, 10);
    assert(maps.contains_key(1) == true);
    assert(maps.contains_key(2) == false);
    assert(maps.contains_key(3) == false);
    assert(maps.contains_key(4) == false);
    assert(maps.contains_key(5) == false);
    assert(maps.contains_key(6) == false);
    assert(maps.contains_key(u64::max()) == false);
    assert(maps.contains_key(0) == false);

    let _ = maps.insert(2, 11);
    assert(maps.contains_key(1) == true);
    assert(maps.contains_key(2) == true);
    assert(maps.contains_key(3) == false);
    assert(maps.contains_key(4) == false);
    assert(maps.contains_key(5) == false);
    assert(maps.contains_key(6) == false);
    assert(maps.contains_key(u64::max()) == false);
    assert(maps.contains_key(0) == false);

    let _ = maps.insert(3, 12);
    assert(maps.contains_key(1) == true);
    assert(maps.contains_key(2) == true);
    assert(maps.contains_key(3) == true);
    assert(maps.contains_key(4) == false);
    assert(maps.contains_key(5) == false);
    assert(maps.contains_key(6) == false);
    assert(maps.contains_key(u64::max()) == false);
    assert(maps.contains_key(0) == false);

    let _ = maps.insert(4, 13);
    assert(maps.contains_key(1) == true);
    assert(maps.contains_key(2) == true);
    assert(maps.contains_key(3) == true);
    assert(maps.contains_key(4) == true);
    assert(maps.contains_key(5) == false);
    assert(maps.contains_key(6) == false);
    assert(maps.contains_key(u64::max()) == false);
    assert(maps.contains_key(0) == false);

    let _ = maps.insert(5, 13);
    assert(maps.contains_key(1) == true);
    assert(maps.contains_key(2) == true);
    assert(maps.contains_key(3) == true);
    assert(maps.contains_key(4) == true);
    assert(maps.contains_key(5) == true);
    assert(maps.contains_key(6) == false);
    assert(maps.contains_key(u64::max()) == false);
    assert(maps.contains_key(0) == false);

    let _ = maps.insert(6, 0);
    assert(maps.contains_key(1) == true);
    assert(maps.contains_key(2) == true);
    assert(maps.contains_key(3) == true);
    assert(maps.contains_key(4) == true);
    assert(maps.contains_key(5) == true);
    assert(maps.contains_key(6) == true);
    assert(maps.contains_key(u64::max()) == false);
    assert(maps.contains_key(0) == false);

    let _ = maps.insert(1, 0);
    assert(maps.contains_key(1) == true);
    assert(maps.contains_key(2) == true);
    assert(maps.contains_key(3) == true);
    assert(maps.contains_key(4) == true);
    assert(maps.contains_key(5) == true);
    assert(maps.contains_key(6) == true);
    assert(maps.contains_key(u64::max()) == false);
    assert(maps.contains_key(0) == false);

    let _ = maps.insert(u64::max(), u64::max());
    assert(maps.contains_key(1) == true);
    assert(maps.contains_key(2) == true);
    assert(maps.contains_key(3) == true);
    assert(maps.contains_key(4) == true);
    assert(maps.contains_key(5) == true);
    assert(maps.contains_key(6) == true);
    assert(maps.contains_key(u64::max()) == true);
    assert(maps.contains_key(0) == false);

    let _ = maps.insert(0, 0);
    assert(maps.contains_key(1) == true);
    assert(maps.contains_key(2) == true);
    assert(maps.contains_key(3) == true);
    assert(maps.contains_key(4) == true);
    assert(maps.contains_key(5) == true);
    assert(maps.contains_key(6) == true);
    assert(maps.contains_key(u64::max()) == true);
    assert(maps.contains_key(0) == true);

    let _ = maps.remove(1);
    assert(maps.contains_key(1) == false);
    assert(maps.contains_key(2) == true);
    assert(maps.contains_key(3) == true);
    assert(maps.contains_key(4) == true);
    assert(maps.contains_key(5) == true);
    assert(maps.contains_key(6) == true);
    assert(maps.contains_key(u64::max()) == true);
    assert(maps.contains_key(0) == true);

    let _ = maps.remove(2);
    assert(maps.contains_key(1) == false);
    assert(maps.contains_key(2) == false);
    assert(maps.contains_key(3) == true);
    assert(maps.contains_key(4) == true);
    assert(maps.contains_key(5) == true);
    assert(maps.contains_key(6) == true);
    assert(maps.contains_key(u64::max()) == true);
    assert(maps.contains_key(0) == true);

    let _ = maps.remove(3);
    assert(maps.contains_key(1) == false);
    assert(maps.contains_key(2) == false);
    assert(maps.contains_key(3) == false);
    assert(maps.contains_key(4) == true);
    assert(maps.contains_key(5) == true);
    assert(maps.contains_key(6) == true);
    assert(maps.contains_key(u64::max()) == true);
    assert(maps.contains_key(0) == true);

    let _ = maps.remove(4);
    assert(maps.contains_key(1) == false);
    assert(maps.contains_key(2) == false);
    assert(maps.contains_key(3) == false);
    assert(maps.contains_key(4) == false);
    assert(maps.contains_key(5) == true);
    assert(maps.contains_key(6) == true);
    assert(maps.contains_key(u64::max()) == true);
    assert(maps.contains_key(0) == true);

    let _ = maps.remove(5);
    assert(maps.contains_key(1) == false);
    assert(maps.contains_key(2) == false);
    assert(maps.contains_key(3) == false);
    assert(maps.contains_key(4) == false);
    assert(maps.contains_key(5) == false);
    assert(maps.contains_key(6) == true);
    assert(maps.contains_key(u64::max()) == true);
    assert(maps.contains_key(0) == true);

    let _ = maps.remove(6);
    assert(maps.contains_key(1) == false);
    assert(maps.contains_key(2) == false);
    assert(maps.contains_key(3) == false);
    assert(maps.contains_key(4) == false);
    assert(maps.contains_key(5) == false);
    assert(maps.contains_key(6) == false);
    assert(maps.contains_key(u64::max()) == true);
    assert(maps.contains_key(0) == true);

    let _ = maps.remove(u64::max());
    assert(maps.contains_key(1) == false);
    assert(maps.contains_key(2) == false);
    assert(maps.contains_key(3) == false);
    assert(maps.contains_key(4) == false);
    assert(maps.contains_key(5) == false);
    assert(maps.contains_key(6) == false);
    assert(maps.contains_key(u64::max()) == false);
    assert(maps.contains_key(0) == true);

    let _ = maps.remove(0);
    assert(maps.contains_key(1) == false);
    assert(maps.contains_key(2) == false);
    assert(maps.contains_key(3) == false);
    assert(maps.contains_key(4) == false);
    assert(maps.contains_key(5) == false);
    assert(maps.contains_key(6) == false);
    assert(maps.contains_key(u64::max()) == false);
    assert(maps.contains_key(0) == false);
}

#[test]
fn hash_map_keys() {
    let keys = [1, 2, 3, 4, 5, 6, u64::max(), 0];
    let values = [10, 11, 12, 13, 14, 15, u64::max(), 0];

    let mut maps: HashMap<u64, u64> = HashMap::new();
    
    let _ = maps.insert(keys[0], values[0]);
    let result = maps.keys();
    assert(result.len() == 1);
    for key in result.iter() {
        let mut iter = 0;
        let mut key_found = false;
        while iter < 8 {
            if keys[iter] == key {
                key_found = true;
                break;
            }
            iter += 1;
        }

        assert(key_found);
    }

    let _ = maps.insert(keys[1], values[1]);
    let result = maps.keys();
    assert(result.len() == 2);
    for key in result.iter() {
        let mut iter = 0;
        let mut key_found = false;
        while iter < 8 {
            if keys[iter] == key {
                key_found = true;
                break;
            }
            iter += 1;
        }

        assert(key_found);
    }

    let _ = maps.insert(keys[2], values[2]);
    let result = maps.keys();
    assert(result.len() == 3);
    for key in result.iter() {
        let mut iter = 0;
        let mut key_found = false;
        while iter < 8 {
            if keys[iter] == key {
                key_found = true;
                break;
            }
            iter += 1;
        }

        assert(key_found);
    }

    let _ = maps.insert(keys[3], values[3]);
    let result = maps.keys();
    assert(result.len() == 4);
    for key in result.iter() {
        let mut iter = 0;
        let mut key_found = false;
        while iter < 8 {
            if keys[iter] == key {
                key_found = true;
                break;
            }
            iter += 1;
        }

        assert(key_found);
    }

    let _ = maps.insert(keys[4], values[4]);
    let result = maps.keys();
    assert(result.len() == 5);
    for key in result.iter() {
        let mut iter = 0;
        let mut key_found = false;
        while iter < 8 {
            if keys[iter] == key {
                key_found = true;
                break;
            }
            iter += 1;
        }

        assert(key_found);
    }

    let _ = maps.insert(keys[5], values[5]);
    let result = maps.keys();
    assert(result.len() == 6);
    for key in result.iter() {
        let mut iter = 0;
        let mut key_found = false;
        while iter < 8 {
            if keys[iter] == key {
                key_found = true;
                break;
            }
            iter += 1;
        }

        assert(key_found);
    }

    let _ = maps.insert(keys[6], values[6]);
    let result = maps.keys();
    assert(result.len() == 7);
    for key in result.iter() {
        let mut iter = 0;
        let mut key_found = false;
        while iter < 8 {
            if keys[iter] == key {
                key_found = true;
                break;
            }
            iter += 1;
        }

        assert(key_found);
    }

    let _ = maps.insert(keys[7], values[7]);
    let result = maps.keys();
    assert(result.len() == 8);
    for key in result.iter() {
        let mut iter = 0;
        let mut key_found = false;
        while iter < 8 {
            if keys[iter] == key {
                key_found = true;
                break;
            }
            iter += 1;
        }

        assert(key_found);
    }

    let _ = maps.remove(keys[0]);
    let _ = maps.remove(keys[1]);
    let _ = maps.remove(keys[2]);
    let _ = maps.remove(keys[3]);
    let _ = maps.remove(keys[4]);
    let _ = maps.remove(keys[5]);
    let _ = maps.remove(keys[6]);
    let _ = maps.remove(keys[7]);
    let result = maps.keys();
    assert(result.len() == 0);
}

#[test]
fn hash_map_values() {
    let keys = [1, 2, 3, 4, 5, 6, u64::max(), 0];
    let values = [10, 11, 12, 13, 14, 15, u64::max(), 0];

    let mut maps: HashMap<u64, u64> = HashMap::new();
    
    let _ = maps.insert(keys[0], values[0]);
    let result = maps.values();
    assert(result.len() == 1);
    for value in result.iter() {
        let mut iter = 0;
        let mut value_found = false;
        while iter < 8 {
            if values[iter] == value {
                value_found = true;
                break;
            }
            iter += 1;
        }

        assert(value_found);
    }

    let _ = maps.insert(keys[1], values[1]);
    let result = maps.values();
    assert(result.len() == 2);
    for value in result.iter() {
        let mut iter = 0;
        let mut value_found = false;
        while iter < 8 {
            if values[iter] == value {
                value_found = true;
                break;
            }
            iter += 1;
        }

        assert(value_found);
    }

    let _ = maps.insert(keys[2], values[2]);
    let result = maps.values();
    assert(result.len() == 3);
    for value in result.iter() {
        let mut iter = 0;
        let mut value_found = false;
        while iter < 8 {
            if values[iter] == value {
                value_found = true;
                break;
            }
            iter += 1;
        }

        assert(value_found);
    }

    let _ = maps.insert(keys[3], values[3]);
    let result = maps.values();
    assert(result.len() == 4);
    for value in result.iter() {
        let mut iter = 0;
        let mut value_found = false;
        while iter < 8 {
            if values[iter] == value {
                value_found = true;
                break;
            }
            iter += 1;
        }

        assert(value_found);
    }

    let _ = maps.insert(keys[4], values[4]);
    let result = maps.values();
    assert(result.len() == 5);
    for value in result.iter() {
        let mut iter = 0;
        let mut value_found = false;
        while iter < 8 {
            if values[iter] == value {
                value_found = true;
                break;
            }
            iter += 1;
        }

        assert(value_found);
    }

    let _ = maps.insert(keys[5], values[5]);
    let result = maps.values();
    assert(result.len() == 6);
    for value in result.iter() {
        let mut iter = 0;
        let mut value_found = false;
        while iter < 8 {
            if values[iter] == value {
                value_found = true;
                break;
            }
            iter += 1;
        }

        assert(value_found);
    }

    let _ = maps.insert(keys[6], values[6]);
    let result = maps.values();
    assert(result.len() == 7);
    for value in result.iter() {
        let mut iter = 0;
        let mut value_found = false;
        while iter < 8 {
            if values[iter] == value {
                value_found = true;
                break;
            }
            iter += 1;
        }

        assert(value_found);
    }

    let _ = maps.insert(keys[7], values[7]);
    let result = maps.values();
    assert(result.len() == 8);
    for value in result.iter() {
        let mut iter = 0;
        let mut value_found = false;
        while iter < 8 {
            if values[iter] == value {
                value_found = true;
                break;
            }
            iter += 1;
        }

        assert(value_found);
    }

    let _ = maps.remove(keys[0]);
    let _ = maps.remove(keys[1]);
    let _ = maps.remove(keys[2]);
    let _ = maps.remove(keys[3]);
    let _ = maps.remove(keys[4]);
    let _ = maps.remove(keys[5]);
    let _ = maps.remove(keys[6]);
    let _ = maps.remove(keys[7]);
    let result = maps.values();
    assert(result.len() == 0);
}

#[test]
fn hash_map_len() {
    let mut maps: HashMap<u64, u64> = HashMap::new();

    assert(maps.len() == 0);
    let _ = maps.insert(1, 10);
    assert(maps.len() == 1);

    let _ = maps.insert(2, 11);
    assert(maps.len() == 2);

    let _ = maps.insert(3, 12);
    assert(maps.len() == 3);

    let _ = maps.insert(4, 13);
    assert(maps.len() == 4);

    let _ = maps.insert(5, 13);
    assert(maps.len() == 5);

    let _ = maps.insert(6, 0);
    assert(maps.len() == 6);

    let _ = maps.insert(1, 0);
    assert(maps.len() == 6);

    let _ = maps.insert(u64::max(), u64::max());
    assert(maps.len() == 7);

    let _ = maps.insert(0, 0);
    assert(maps.len() == 8);

    let _ = maps.remove(1);
    assert(maps.len() == 7);

    let _ = maps.remove(1);
    assert(maps.len() == 7);

    let _ = maps.remove(2);
    assert(maps.len() == 6);

    let _ = maps.remove(3);
    assert(maps.len() == 5);

    let _ = maps.remove(4);
    assert(maps.len() == 4);

    let _ = maps.remove(5);
    assert(maps.len() == 3);

    let _ = maps.remove(6);
    assert(maps.len() == 2);

    let _ = maps.remove(u64::max());
    assert(maps.len() == 1);

    let _ = maps.remove(0);
    assert(maps.len() == 0);
}

#[test]
fn hash_map_capacity() {
    let mut maps: HashMap<u64, u64> = HashMap::new();

    assert(maps.capacity() == 0);
    let _ = maps.insert(1, 10);
    assert(maps.capacity() == 1);

    let _ = maps.insert(2, 11);
    assert(maps.capacity() == 2);

    let _ = maps.insert(3, 12);
    assert(maps.capacity() == 4);

    let _ = maps.insert(4, 13);
    assert(maps.capacity() == 4);

    let _ = maps.insert(5, 13);
    assert(maps.capacity() == 8);

    let _ = maps.insert(6, 0);
    assert(maps.capacity() == 8);

    let _ = maps.insert(1, 0);
    assert(maps.capacity() == 8);

    let _ = maps.insert(u64::max(), u64::max());
    assert(maps.capacity() == 8);

    let _ = maps.insert(0, 0);
    assert(maps.capacity() == 8);

    let _ = maps.remove(1);
    assert(maps.capacity() == 8);

    let _ = maps.remove(1);
    assert(maps.capacity() == 8);

    let _ = maps.remove(2);
    assert(maps.capacity() == 8);

    let _ = maps.remove(3);
    assert(maps.capacity() == 8);

    let _ = maps.remove(4);
    assert(maps.capacity() == 8);

    let _ = maps.remove(5);
    assert(maps.capacity() == 8);

    let _ = maps.remove(6);
    assert(maps.capacity() == 8);

    let _ = maps.remove(u64::max());
    assert(maps.capacity() == 8);

    let _ = maps.remove(0);
    assert(maps.capacity() == 8);
}

#[test]
fn hash_map_is_empty() {
    let mut maps: HashMap<u64, u64> = HashMap::new();

    assert(maps.is_empty() == true);
    let _ = maps.insert(1, 10);
    assert(maps.is_empty() == false);

    let _ = maps.remove(1);
    assert(maps.is_empty() == true);

    let _ = maps.insert(1, 10);
    assert(maps.is_empty() == false);

    let _ = maps.insert(2, 11);
    assert(maps.is_empty() == false);

    let _ = maps.insert(3, 12);
    assert(maps.is_empty() == false);

    let _ = maps.insert(4, 13);
    assert(maps.is_empty() == false);

    let _ = maps.insert(5, 13);
    assert(maps.is_empty() == false);

    let _ = maps.insert(6, 0);
    assert(maps.is_empty() == false);

    let _ = maps.insert(1, 0);
    assert(maps.is_empty() == false);

    let _ = maps.insert(u64::max(), u64::max());
    assert(maps.is_empty() == false);

    let _ = maps.insert(0, 0);
    assert(maps.is_empty() == false);

    let _ = maps.remove(1);
    assert(maps.is_empty() == false);

    let _ = maps.remove(1);
    assert(maps.is_empty() == false);

    let _ = maps.remove(2);
    assert(maps.is_empty() == false);

    let _ = maps.remove(3);
    assert(maps.is_empty() == false);

    let _ = maps.remove(4);
    assert(maps.is_empty() == false);

    let _ = maps.remove(5);
    assert(maps.is_empty() == false);

    let _ = maps.remove(6);
    assert(maps.is_empty() == false);

    let _ = maps.remove(u64::max());
    assert(maps.is_empty() == false);

    let _ = maps.remove(0);
    assert(maps.is_empty() == true);
}

#[test]
fn hash_map_iter() {
    let keys = [1, 2, 3, 4, 5, 6, u64::max(), 0];
    let values = [10, 11, 12, 13, 14, 15, u64::max(), 0];

    let mut maps: HashMap<u64, u64> = HashMap::new();
    
    let _ = maps.insert(keys[0], values[0]);
    for (key, value) in maps.iter() {
        let mut iter = 0;
        let mut key_value_found = false;
        while iter < 8 {
            if values[iter] == value && keys[iter] == key {
                key_value_found = true;
                break;
            }
            iter += 1;
        }

        assert(key_value_found);
    }

    let _ = maps.insert(keys[1], values[1]);
    for (key, value) in maps.iter() {
        let mut iter = 0;
        let mut key_value_found = false;
        while iter < 8 {
            if values[iter] == value && keys[iter] == key {
                key_value_found = true;
                break;
            }
            iter += 1;
        }

        assert(key_value_found);
    }

    let _ = maps.insert(keys[2], values[2]);
    for (key, value) in maps.iter() {
        let mut iter = 0;
        let mut key_value_found = false;
        while iter < 8 {
            if values[iter] == value && keys[iter] == key {
                key_value_found = true;
                break;
            }
            iter += 1;
        }

        assert(key_value_found);
    }

    let _ = maps.insert(keys[3], values[3]);
    for (key, value) in maps.iter() {
        let mut iter = 0;
        let mut key_value_found = false;
        while iter < 8 {
            if values[iter] == value && keys[iter] == key {
                key_value_found = true;
                break;
            }
            iter += 1;
        }

        assert(key_value_found);
    }

    let _ = maps.insert(keys[4], values[4]);
    for (key, value) in maps.iter() {
        let mut iter = 0;
        let mut key_value_found = false;
        while iter < 8 {
            if values[iter] == value && keys[iter] == key {
                key_value_found = true;
                break;
            }
            iter += 1;
        }

        assert(key_value_found);
    }

    let _ = maps.insert(keys[5], values[5]);
    for (key, value) in maps.iter() {
        let mut iter = 0;
        let mut key_value_found = false;
        while iter < 8 {
            if values[iter] == value && keys[iter] == key {
                key_value_found = true;
                break;
            }
            iter += 1;
        }

        assert(key_value_found);
    }

    let _ = maps.insert(keys[6], values[6]);
    for (key, value) in maps.iter() {
        let mut iter = 0;
        let mut key_value_found = false;
        while iter < 8 {
            if values[iter] == value && keys[iter] == key {
                key_value_found = true;
                break;
            }
            iter += 1;
        }

        assert(key_value_found);
    }

    let _ = maps.insert(keys[7], values[7]);
    for (key, value) in maps.iter() {
        let mut iter = 0;
        let mut key_value_found = false;
        while iter < 8 {
            if values[iter] == value && keys[iter] == key {
                key_value_found = true;
                break;
            }
            iter += 1;
        }

        assert(key_value_found);
    }

    let _ = maps.remove(keys[0]);
    let _ = maps.remove(keys[1]);
    let _ = maps.remove(keys[2]);
    let _ = maps.remove(keys[3]);
    let _ = maps.remove(keys[4]);
    let _ = maps.remove(keys[5]);
    let _ = maps.remove(keys[6]);
    let _ = maps.remove(keys[7]);

    let mut iterator = maps.iter();
    assert(iterator.next() == None);
}
