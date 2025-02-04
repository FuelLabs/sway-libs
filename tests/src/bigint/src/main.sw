library;

use sway_libs::bigint::BigInt;
use std::u128::U128;
use std::bytes::Bytes;

#[test]
fn bigint_new() {
    let bigint = BigInt::new();

    assert(bigint.number_of_limbs() == 1);
    assert(bigint.limbs().len() == 1);
    assert(bigint.limbs().get(0).unwrap() == 0);
}

#[test]
fn bigint_equal_limb_size() {
    let bigint_1 = BigInt::new();
    let bigint_2 = BigInt::zero();
    let bigint_3 = BigInt::from(1u64);
    let bigint_4 = BigInt::from(U128::from((1, 0)));
    let bigint_5 = BigInt::from(u256::max());

    assert(bigint_1.equal_limb_size(bigint_2));
    assert(bigint_1.equal_limb_size(bigint_3));
    assert(!bigint_1.equal_limb_size(bigint_4));
    assert(!bigint_1.equal_limb_size(bigint_5));

    assert(bigint_2.equal_limb_size(bigint_3));
    assert(!bigint_2.equal_limb_size(bigint_4));
    assert(!bigint_2.equal_limb_size(bigint_5));

    assert(!bigint_3.equal_limb_size(bigint_4));
    assert(!bigint_3.equal_limb_size(bigint_5));

    assert(!bigint_4.equal_limb_size(bigint_5));
}

#[test]
fn bigint_number_of_limbs() {
    let bigint_1 = BigInt::new();
    let bigint_2 = BigInt::zero();
    let bigint_3 = BigInt::from(1u64);
    let bigint_4 = BigInt::from(U128::from((1, 0)));
    let bigint_5 = BigInt::from(u256::max());

    assert(bigint_1.number_of_limbs() == 1);
    assert(bigint_2.number_of_limbs() == 1);
    assert(bigint_3.number_of_limbs() == 1);
    assert(bigint_4.number_of_limbs() == 2);
    assert(bigint_5.number_of_limbs() == 4);
}

#[test]
fn bigint_limbs() {
    // The returned vec should only be a copy.
    let mut bigint_1 = BigInt::zero();
    bigint_1.limbs().set(0, 10); // This does nothing
    assert(bigint_1 == BigInt::zero());

    let bigint_2 = BigInt::from(1u64);
    let result_vec = bigint_2.limbs();
    assert(result_vec.get(0).unwrap() == 1);
}

#[test]
fn bigint_get_limb() {
    let bigint_1 = BigInt::new();
    let bigint_2 = BigInt::zero();
    let bigint_3 = BigInt::from(1u64);
    let bigint_4 = BigInt::from(U128::from((1, 0)));
    let bigint_5 = BigInt::from(u256::max());

    assert(bigint_1.get_limb(0).unwrap() == 0);
    assert(bigint_1.get_limb(1) == None);

    assert(bigint_2.get_limb(0).unwrap() == 0);
    assert(bigint_2.get_limb(1) == None);

    assert(bigint_3.get_limb(0).unwrap() == 1);
    assert(bigint_3.get_limb(1) == None);

    assert(bigint_4.get_limb(0).unwrap() == 0);
    assert(bigint_4.get_limb(1).unwrap() == 1);
    assert(bigint_4.get_limb(2) == None);

    assert(bigint_5.get_limb(0).unwrap() == u64::max());
    assert(bigint_5.get_limb(1).unwrap() == u64::max());
    assert(bigint_5.get_limb(2).unwrap() == u64::max());
    assert(bigint_5.get_limb(3).unwrap() == u64::max());
    assert(bigint_5.get_limb(4) == None);
}

#[test]
fn bigint_zero() {
    let bigint = BigInt::zero();

    assert(bigint.number_of_limbs() == 1);
    assert(bigint.limbs().len() == 1);
    assert(bigint.limbs().get(0).unwrap() == 0);
}

#[test]
fn bigint_is_zero() {
    let bigint_1 = BigInt::zero();
    assert(bigint_1.is_zero());

    let bigint_2 = BigInt::new();
    assert(bigint_2.is_zero());

    let bigint_3 = BigInt::from(u256::zero());
    assert(bigint_3.is_zero());

    let bigint_4 = BigInt::from(1u64);
    assert(!bigint_4.is_zero());

    let bigint_5 = BigInt::from(U128::from((1, 0)));
    assert(!bigint_5.is_zero());
}

#[test]
fn bigint_clone() {
    let bigint_1 = BigInt::zero();
    let bigint_2 = bigint_1.clone();
    assert(bigint_1 == bigint_2);
    assert(__addr_of(bigint_1) != __addr_of(bigint_2));

    let bigint_3 = BigInt::from(1u64);
    let bigint_4 = bigint_3.clone();
    assert(bigint_3 == bigint_4);
    assert(__addr_of(bigint_3) != __addr_of(bigint_4));
}

#[test]
fn bigint_from_u8() {
    let bigint_1 = BigInt::from(0u8);
    assert(bigint_1.number_of_limbs() == 1);
    assert(bigint_1.is_zero());

    let bigint_2 = BigInt::from(1u8);
    assert(bigint_2.number_of_limbs() == 1);
    assert(bigint_2.get_limb(0).unwrap() == 1);

    let bigint_3 = BigInt::from(u8::max());
    assert(bigint_3.number_of_limbs() == 1);
    assert(bigint_3.get_limb(0).unwrap() == u8::max().as_u64());
}

#[test]
fn bigint_try_into_u8() {
    let bigint_1 = BigInt::zero();
    assert(<BigInt as TryInto<u8>>::try_into(bigint_1).unwrap() == 0u8);

    let bigint_2 = BigInt::from(1u8);
    assert(<BigInt as TryInto<u8>>::try_into(bigint_2).unwrap() == 1u8);

    let bigint_3 = BigInt::from(u8::max());
    assert(<BigInt as TryInto<u8>>::try_into(bigint_3).unwrap() == u8::max());

    let bigint_4 = BigInt::from(u8::max().as_u64() + 1u64);
    assert(<BigInt as TryInto<u8>>::try_into(bigint_4) == None);
}

#[test]
fn bigint_from_u16() {
    let bigint_1 = BigInt::from(0u16);
    assert(bigint_1.number_of_limbs() == 1);
    assert(bigint_1.is_zero());

    let bigint_2 = BigInt::from(1u16);
    assert(bigint_2.number_of_limbs() == 1);
    assert(bigint_2.get_limb(0).unwrap() == 1);

    let bigint_3 = BigInt::from(u16::max());
    assert(bigint_3.number_of_limbs() == 1);
    assert(bigint_3.get_limb(0).unwrap() == u16::max().as_u64());
}

#[test]
fn bigint_try_into_u16() {
    let bigint_1 = BigInt::zero();
    assert(<BigInt as TryInto<u16>>::try_into(bigint_1).unwrap() == 0u16);

    let bigint_2 = BigInt::from(1u16);
    assert(<BigInt as TryInto<u16>>::try_into(bigint_2).unwrap() == 1u16);

    let bigint_3 = BigInt::from(u16::max());
    assert(<BigInt as TryInto<u16>>::try_into(bigint_3).unwrap() == u16::max());

    let bigint_4 = BigInt::from(u16::max().as_u64() + 1u64);
    assert(<BigInt as TryInto<u16>>::try_into(bigint_4) == None);
}

#[test]
fn bigint_from_u32() {
    let bigint_1 = BigInt::from(0u32);
    assert(bigint_1.number_of_limbs() == 1);
    assert(bigint_1.is_zero());

    let bigint_2 = BigInt::from(1u32);
    assert(bigint_2.number_of_limbs() == 1);
    assert(bigint_2.get_limb(0).unwrap() == 1);

    let bigint_3 = BigInt::from(u32::max());
    assert(bigint_3.number_of_limbs() == 1);
    assert(bigint_3.get_limb(0).unwrap() == u32::max().as_u64());
}

#[test]
fn bigint_try_into_u32() {
    let bigint_1 = BigInt::zero();
    assert(<BigInt as TryInto<u32>>::try_into(bigint_1).unwrap() == 0u32);

    let bigint_2 = BigInt::from(1u32);
    assert(<BigInt as TryInto<u32>>::try_into(bigint_2).unwrap() == 1u32);

    let bigint_3 = BigInt::from(u32::max());
    assert(<BigInt as TryInto<u32>>::try_into(bigint_3).unwrap() == u32::max());

    let bigint_4 = BigInt::from(u32::max().as_u64() + 1u64);
    assert(<BigInt as TryInto<u32>>::try_into(bigint_4) == None);
}

#[test]
fn bigint_from_u64() {
    let bigint_1 = BigInt::from(0u64);
    assert(bigint_1.number_of_limbs() == 1);
    assert(bigint_1.is_zero());

    let bigint_2 = BigInt::from(1u64);
    assert(bigint_2.number_of_limbs() == 1);
    assert(bigint_2.get_limb(0).unwrap() == 1);

    let bigint_3 = BigInt::from(u64::max());
    assert(bigint_3.number_of_limbs() == 1);
    assert(bigint_3.get_limb(0).unwrap() == u64::max());
}

#[test]
fn bigint_try_into_u64() {
    let bigint_1 = BigInt::zero();
    assert(<BigInt as TryInto<u64>>::try_into(bigint_1).unwrap() == 0u64);

    let bigint_2 = BigInt::from(1u64);
    assert(<BigInt as TryInto<u64>>::try_into(bigint_2).unwrap() == 1u64);

    let bigint_3 = BigInt::from(u64::max());
    assert(<BigInt as TryInto<u64>>::try_into(bigint_3).unwrap() == u64::max());

    let bigint_4 = BigInt::from(u64::max().as_u256() + 1u64.as_u256());
    assert(<BigInt as TryInto<u64>>::try_into(bigint_4) == None);
}

#[test]
fn bigint_from_U128() {
    let bigint_1 = BigInt::from(U128::zero());
    assert(bigint_1.number_of_limbs() == 1);
    assert(bigint_1.is_zero());

    let bigint_2 = BigInt::from(U128::from((0, 1)));
    assert(bigint_2.number_of_limbs() == 1);
    assert(bigint_2.get_limb(0).unwrap() == 1);

    let bigint_3 = BigInt::from(U128::from((1, 0)));
    assert(bigint_3.number_of_limbs() == 2);
    assert(bigint_3.get_limb(0).unwrap() == 0);
    assert(bigint_3.get_limb(1).unwrap() == 1);

    let bigint_4 = BigInt::from(U128::max());
    assert(bigint_4.number_of_limbs() == 2);
    assert(bigint_4.get_limb(0).unwrap() == u64::max());
    assert(bigint_4.get_limb(1).unwrap() == u64::max());
}

#[test]
fn bigint_try_into_U128() {
    let bigint_1 = BigInt::zero();
    assert(<BigInt as TryInto<U128>>::try_into(bigint_1).unwrap() == U128::zero());

    let bigint_2 = BigInt::from(1u64);
    assert(<BigInt as TryInto<U128>>::try_into(bigint_2).unwrap() == U128::from((0, 1)));

    let bigint_3 = BigInt::from(u64::max());
    assert(
        <BigInt as TryInto<U128>>::try_into(bigint_3)
            .unwrap() == U128::from((0, u64::max())),
    );

    let bigint_4 = BigInt::from(u64::max().as_u256() + 1u64.as_u256());
    assert(<BigInt as TryInto<U128>>::try_into(bigint_4).unwrap() == U128::from((1, 0)));

    let bigint_5 = BigInt::from(u256::from(U128::max()) + 1u64.as_u256());
    assert(<BigInt as TryInto<U128>>::try_into(bigint_5) == None);
}

#[test]
fn bigint_from_u256() {
    let bigint_1 = BigInt::from(u256::zero());
    assert(bigint_1.number_of_limbs() == 1);
    assert(bigint_1.is_zero());

    let bigint_2 = BigInt::from(0x0000000000000000000000000000000000000000000000000000000000000001u256);
    assert(bigint_2.number_of_limbs() == 1);
    assert(bigint_2.get_limb(0).unwrap() == 1);

    let bigint_3 = BigInt::from(0x0000000000000000000000000000000000000000000000010000000000000000u256);
    assert(bigint_3.number_of_limbs() == 2);
    assert(bigint_3.get_limb(0).unwrap() == 0);
    assert(bigint_3.get_limb(1).unwrap() == 1);

    let bigint_4 = BigInt::from(0x0000000000000000000000000000000100000000000000000000000000000000u256);
    assert(bigint_4.number_of_limbs() == 3);
    assert(bigint_4.get_limb(0).unwrap() == 0);
    assert(bigint_4.get_limb(1).unwrap() == 0);
    assert(bigint_4.get_limb(2).unwrap() == 1);

    let bigint_5 = BigInt::from(u256::max());
    assert(bigint_5.number_of_limbs() == 4);
    assert(bigint_5.get_limb(0).unwrap() == u64::max());
    assert(bigint_5.get_limb(1).unwrap() == u64::max());
    assert(bigint_5.get_limb(2).unwrap() == u64::max());
    assert(bigint_5.get_limb(3).unwrap() == u64::max());
}

#[test]
fn bigint_try_into_u256() {
    let bigint_1 = BigInt::zero();
    assert(<BigInt as TryInto<u256>>::try_into(bigint_1).unwrap() == u256::zero());

    let bigint_2 = BigInt::from(0x0000000000000000000000000000000000000000000000000000000000000001u256);
    assert(
        <BigInt as TryInto<u256>>::try_into(bigint_2)
            .unwrap() == 0x0000000000000000000000000000000000000000000000000000000000000001u256,
    );

    let bigint_3 = BigInt::from(0x0000000000000000000000000000000000000000000000010000000000000000u256);
    assert(
        <BigInt as TryInto<u256>>::try_into(bigint_3)
            .unwrap() == 0x0000000000000000000000000000000000000000000000010000000000000000u256,
    );

    let bigint_4 = BigInt::from(0x0000000000000000000000000000000100000000000000000000000000000000u256);
    assert(
        <BigInt as TryInto<u256>>::try_into(bigint_4)
            .unwrap() == 0x0000000000000000000000000000000100000000000000000000000000000000u256,
    );

    let bigint_5 = BigInt::from(u256::max());
    assert(<BigInt as TryInto<u256>>::try_into(bigint_5).unwrap() == u256::max());

    let bigint_6 = BigInt::from(u256::max()) + BigInt::from(1u64);
    assert(<BigInt as TryInto<u64>>::try_into(bigint_6) == None);
}

#[test]
fn bigint_from_bytes() {
    // New is zero
    let bigint_1 = BigInt::from(Bytes::new());
    assert(bigint_1.number_of_limbs() == 1);
    assert(bigint_1.is_zero());

    // One 0u8 is zero
    let mut bytes_2 = Bytes::new();
    bytes_2.push(0u8);
    let bigint_2 = BigInt::from(bytes_2);
    assert(bigint_2.number_of_limbs() == 1);
    assert(bigint_2.is_zero());

    // Multiple 0u8 is zero
    let mut bytes_3 = Bytes::new();
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    let bigint_3 = BigInt::from(bytes_3);
    assert(bigint_3.number_of_limbs() == 1);
    assert(bigint_3.is_zero());

    // Single u8
    let mut bytes_4 = Bytes::new();
    bytes_4.push(1u8);
    let bigint_4 = BigInt::from(bytes_4);
    assert(bigint_4.number_of_limbs() == 1);
    assert(bigint_4.get_limb(0).unwrap() == 1);

    // u8 with leading zeros
    let mut bytes_5 = Bytes::new();
    bytes_5.push(0u8);
    bytes_5.push(1u8);
    let bigint_5 = BigInt::from(bytes_5);
    assert(bigint_5.number_of_limbs() == 1);
    assert(bigint_5.get_limb(0).unwrap() == 1);

    // two u8 
    let mut bytes_6 = Bytes::new();
    bytes_6.push(0u8);
    bytes_6.insert(0, 1u8);
    let bigint_6 = BigInt::from(bytes_6);
    assert(bigint_6.number_of_limbs() == 1);
    assert(bigint_6.get_limb(0).unwrap() == 256);

    // bytes size of u64
    let mut bytes_7 = Bytes::new();
    bytes_7.push(255u8);
    bytes_7.push(255u8);
    bytes_7.push(255u8);
    bytes_7.push(255u8);
    bytes_7.push(255u8);
    bytes_7.push(255u8);
    bytes_7.push(255u8);
    bytes_7.push(255u8);
    let bigint_7 = BigInt::from(bytes_7);
    assert(bigint_7.number_of_limbs() == 1);
    assert(bigint_7.get_limb(0).unwrap() == u64::max());

    // bytes size of u64 with leading zeros
    let mut bytes_8 = Bytes::new();
    bytes_8.push(255u8);
    bytes_8.push(255u8);
    bytes_8.push(255u8);
    bytes_8.push(255u8);
    bytes_8.push(255u8);
    bytes_8.push(255u8);
    bytes_8.push(255u8);
    bytes_8.push(255u8);
    bytes_8.insert(0, 0u8);
    let bigint_8 = BigInt::from(bytes_8);
    assert(bigint_8.number_of_limbs() == 1);
    assert(bigint_8.get_limb(0).unwrap() == u64::max());

    // bytes results in 2 limbs
    let mut bytes_9 = Bytes::new();
    bytes_9.push(0u8);
    bytes_9.push(0u8);
    bytes_9.push(0u8);
    bytes_9.push(0u8);
    bytes_9.push(0u8);
    bytes_9.push(0u8);
    bytes_9.push(0u8);
    bytes_9.push(0u8);
    bytes_9.insert(0, 1u8);
    let bigint_9 = BigInt::from(bytes_9);
    assert(bigint_9.number_of_limbs() == 2);
    assert(bigint_9.get_limb(0).unwrap() == 0);
    assert(bigint_9.get_limb(1).unwrap() == 1);

    // bytes results in 3 limbs
    let mut bytes_10 = Bytes::new();
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.insert(0, 1u8);
    let bigint_10 = BigInt::from(bytes_10);
    assert(bigint_10.number_of_limbs() == 3);
    assert(bigint_10.get_limb(0).unwrap() == 0);
    assert(bigint_10.get_limb(1).unwrap() == 0);
    assert(bigint_10.get_limb(2).unwrap() == 1);
}

#[test]
fn bigint_into_bytes() {
    // New is 0
    let bigint_1 = BigInt::from(Bytes::new());
    let converted_bytes_1: Bytes = <BigInt as Into<Bytes>>::into(bigint_1);
    assert(converted_bytes_1.len() == 0);

    // One 0u8 is zero
    let mut bytes_2 = Bytes::new();
    bytes_2.push(0u8);
    let bigint_2 = BigInt::from(bytes_2);
    let converted_bytes_2: Bytes = <BigInt as Into<Bytes>>::into(bigint_2);
    assert(converted_bytes_2.len() == 0);

    // Multiple 0u8 is zero
    let mut bytes_3 = Bytes::new();
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    bytes_3.push(0u8);
    let bigint_3 = BigInt::from(bytes_3);
    let converted_bytes_3: Bytes = <BigInt as Into<Bytes>>::into(bigint_3);
    assert(converted_bytes_3.len() == 0);

    // Single u8
    let mut bytes_4 = Bytes::new();
    bytes_4.push(1u8);
    let bigint_4 = BigInt::from(bytes_4);
    let converted_bytes_4: Bytes = <BigInt as Into<Bytes>>::into(bigint_4);
    assert(converted_bytes_4.len() == 1);
    assert(converted_bytes_4.get(0).unwrap() == 1);

    // single u8 with leading zeros
    let mut bytes_5 = Bytes::new();
    bytes_5.push(0u8);
    bytes_5.push(1u8);
    let bigint_5 = BigInt::from(bytes_5);
    let converted_bytes_5: Bytes = <BigInt as Into<Bytes>>::into(bigint_5);
    assert(converted_bytes_5.len() == 1);
    assert(converted_bytes_5.get(0).unwrap() == 1);

    // two u8 
    let mut bytes_6 = Bytes::new();
    bytes_6.push(0u8);
    bytes_6.insert(0, 1u8);
    let bigint_6 = BigInt::from(bytes_6);
    let converted_bytes_6: Bytes = <BigInt as Into<Bytes>>::into(bigint_6);
    assert(converted_bytes_6.len() == 2);
    assert(converted_bytes_6.get(0).unwrap() == 1);
    assert(converted_bytes_6.get(1).unwrap() == 0);

    // bytes size of u64
    let mut bytes_7 = Bytes::new();
    bytes_7.push(255u8);
    bytes_7.push(255u8);
    bytes_7.push(255u8);
    bytes_7.push(255u8);
    bytes_7.push(255u8);
    bytes_7.push(255u8);
    bytes_7.push(255u8);
    bytes_7.push(255u8);
    let bigint_7 = BigInt::from(bytes_7);
    let converted_bytes_7: Bytes = <BigInt as Into<Bytes>>::into(bigint_7);
    assert(converted_bytes_7.len() == 8);
    assert(converted_bytes_7.get(0).unwrap() == 255u8);
    assert(converted_bytes_7.get(1).unwrap() == 255u8);
    assert(converted_bytes_7.get(2).unwrap() == 255u8);
    assert(converted_bytes_7.get(3).unwrap() == 255u8);
    assert(converted_bytes_7.get(4).unwrap() == 255u8);
    assert(converted_bytes_7.get(5).unwrap() == 255u8);
    assert(converted_bytes_7.get(6).unwrap() == 255u8);
    assert(converted_bytes_7.get(7).unwrap() == 255u8);

    // bytes size of u64 with leading zeros
    let mut bytes_8 = Bytes::new();
    bytes_8.push(255u8);
    bytes_8.push(255u8);
    bytes_8.push(255u8);
    bytes_8.push(255u8);
    bytes_8.push(255u8);
    bytes_8.push(255u8);
    bytes_8.push(255u8);
    bytes_8.push(255u8);
    bytes_8.insert(0, 0u8);
    let bigint_8 = BigInt::from(bytes_8);
    let converted_bytes_8: Bytes = <BigInt as Into<Bytes>>::into(bigint_8);
    assert(converted_bytes_8.len() == 8);
    assert(converted_bytes_8.get(0).unwrap() == 255u8);
    assert(converted_bytes_8.get(1).unwrap() == 255u8);
    assert(converted_bytes_8.get(2).unwrap() == 255u8);
    assert(converted_bytes_8.get(3).unwrap() == 255u8);
    assert(converted_bytes_8.get(4).unwrap() == 255u8);
    assert(converted_bytes_8.get(5).unwrap() == 255u8);
    assert(converted_bytes_8.get(6).unwrap() == 255u8);
    assert(converted_bytes_8.get(7).unwrap() == 255u8);

    // bytes results in 2 limbs
    let mut bytes_9 = Bytes::new();
    bytes_9.push(0u8);
    bytes_9.push(0u8);
    bytes_9.push(0u8);
    bytes_9.push(0u8);
    bytes_9.push(0u8);
    bytes_9.push(0u8);
    bytes_9.push(0u8);
    bytes_9.push(0u8);
    bytes_9.insert(0, 1u8);
    let bigint_9 = BigInt::from(bytes_9);
    let converted_bytes_9: Bytes = <BigInt as Into<Bytes>>::into(bigint_9);
    assert(converted_bytes_9.len() == 9);
    assert(converted_bytes_9.get(0).unwrap() == 1);
    assert(converted_bytes_9.get(1).unwrap() == 0);
    assert(converted_bytes_9.get(2).unwrap() == 0);
    assert(converted_bytes_9.get(3).unwrap() == 0);
    assert(converted_bytes_9.get(4).unwrap() == 0);
    assert(converted_bytes_9.get(5).unwrap() == 0);
    assert(converted_bytes_9.get(6).unwrap() == 0);
    assert(converted_bytes_9.get(7).unwrap() == 0);
    assert(converted_bytes_9.get(8).unwrap() == 0);

    // bytes results in 3 limbs
    let mut bytes_10 = Bytes::new();
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.push(0u8);
    bytes_10.insert(0, 1u8);
    let bigint_10 = BigInt::from(bytes_10);
    let converted_bytes_10: Bytes = <BigInt as Into<Bytes>>::into(bigint_10);
    assert(converted_bytes_10.len() == 17);
    assert(converted_bytes_10.get(0).unwrap() == 1);
    assert(converted_bytes_10.get(1).unwrap() == 0);
    assert(converted_bytes_10.get(2).unwrap() == 0);
    assert(converted_bytes_10.get(3).unwrap() == 0);
    assert(converted_bytes_10.get(4).unwrap() == 0);
    assert(converted_bytes_10.get(5).unwrap() == 0);
    assert(converted_bytes_10.get(6).unwrap() == 0);
    assert(converted_bytes_10.get(7).unwrap() == 0);
    assert(converted_bytes_10.get(8).unwrap() == 0);
    assert(converted_bytes_10.get(9).unwrap() == 0);
    assert(converted_bytes_10.get(10).unwrap() == 0);
    assert(converted_bytes_10.get(11).unwrap() == 0);
    assert(converted_bytes_10.get(12).unwrap() == 0);
    assert(converted_bytes_10.get(13).unwrap() == 0);
    assert(converted_bytes_10.get(14).unwrap() == 0);
    assert(converted_bytes_10.get(15).unwrap() == 0);
    assert(converted_bytes_10.get(16).unwrap() == 0);
}

#[test]
fn bigint_eq() {
    let bigint_1 = BigInt::zero();
    let bigint_2 = BigInt::zero();
    let bigint_3 = BigInt::from(1u64);
    let bigint_4 = BigInt::from(1u64);
    let bigint_5 = BigInt::from(20u64);
    let bigint_6 = BigInt::from(20u64);
    let bigint_7 = BigInt::from(u64::max());
    let bigint_8 = BigInt::from(u64::max());
    let bigint_9 = BigInt::from(U128::from((1, 0)));
    let bigint_10 = BigInt::from(U128::from((1, 0)));
    let bigint_11 = BigInt::from(U128::from((u64::max(), u64::max())));
    let bigint_12 = BigInt::from(U128::from((u64::max(), u64::max())));
    let bigint_13 = BigInt::from(u256::max());
    let bigint_14 = BigInt::from(u256::max());

    assert(bigint_1 == bigint_2);
    assert(bigint_3 == bigint_4);
    assert(bigint_5 == bigint_6);
    assert(bigint_7 == bigint_8);
    assert(bigint_9 == bigint_10);
    assert(bigint_11 == bigint_12);
    assert(bigint_13 == bigint_14);

    assert(bigint_1 != bigint_3);
    assert(bigint_1 != bigint_5);
    assert(bigint_1 != bigint_7);
    assert(bigint_1 != bigint_9);
    assert(bigint_1 != bigint_11);
    assert(bigint_1 != bigint_13);

    assert(bigint_3 != bigint_5);
    assert(bigint_3 != bigint_7);
    assert(bigint_3 != bigint_9);
    assert(bigint_3 != bigint_11);
    assert(bigint_3 != bigint_13);

    assert(bigint_5 != bigint_7);
    assert(bigint_5 != bigint_9);
    assert(bigint_5 != bigint_11);
    assert(bigint_5 != bigint_13);

    assert(bigint_7 != bigint_9);
    assert(bigint_7 != bigint_11);
    assert(bigint_7 != bigint_13);

    assert(bigint_9 != bigint_11);
    assert(bigint_9 != bigint_13);

    assert(bigint_11 != bigint_13);
}

#[test]
fn bigint_ord() {
    let bigint_zero = BigInt::zero();
    let bigint_1 = BigInt::from(1u64);
    let bigint_2 = BigInt::from(20u64);
    let bigint_3 = BigInt::from(u64::max());
    let bigint_4 = BigInt::from(U128::from((1, 0)));
    let bigint_5 = BigInt::from(U128::from((u64::max(), u64::max())));
    let bigint_6 = BigInt::from(u256::max());

    assert(bigint_zero < bigint_1);
    assert(bigint_zero < bigint_2);
    assert(bigint_zero < bigint_3);
    assert(bigint_zero < bigint_4);
    assert(bigint_zero < bigint_5);
    assert(bigint_zero < bigint_6);
    assert(bigint_1 > bigint_zero);
    assert(bigint_2 > bigint_zero);
    assert(bigint_3 > bigint_zero);
    assert(bigint_4 > bigint_zero);
    assert(bigint_5 > bigint_zero);
    assert(bigint_6 > bigint_zero);

    assert(bigint_1 < bigint_2);
    assert(bigint_1 < bigint_3);
    assert(bigint_1 < bigint_4);
    assert(bigint_1 < bigint_5);
    assert(bigint_1 < bigint_6);
    assert(bigint_2 > bigint_1);
    assert(bigint_3 > bigint_1);
    assert(bigint_4 > bigint_1);
    assert(bigint_5 > bigint_1);
    assert(bigint_6 > bigint_1);

    assert(bigint_2 < bigint_3);
    assert(bigint_2 < bigint_4);
    assert(bigint_2 < bigint_5);
    assert(bigint_2 < bigint_6);
    assert(bigint_3 > bigint_2);
    assert(bigint_4 > bigint_2);
    assert(bigint_5 > bigint_2);
    assert(bigint_6 > bigint_2);

    assert(bigint_3 < bigint_4);
    assert(bigint_3 < bigint_5);
    assert(bigint_3 < bigint_6);
    assert(bigint_4 > bigint_3);
    assert(bigint_5 > bigint_3);
    assert(bigint_6 > bigint_3);

    assert(bigint_4 < bigint_5);
    assert(bigint_4 < bigint_6);
    assert(bigint_5 > bigint_4);
    assert(bigint_6 > bigint_4);

    assert(bigint_5 < bigint_6);
    assert(bigint_6 > bigint_5);
}

#[test]
fn bigint_add() {
    let bigint_zero = BigInt::zero();
    let bigint_1 = BigInt::from(1u64);
    let bigint_2 = BigInt::from(20u64);
    let bigint_3 = BigInt::from(u64::max());
    let bigint_4 = BigInt::from(U128::from((1, 0)));
    let bigint_5 = BigInt::from(U128::from((u64::max(), u64::max())));
    let bigint_6 = BigInt::from(u256::max());

    // Two zeros added is zero
    assert(bigint_zero + bigint_zero == bigint_zero);

    // Order does not matter
    assert(bigint_1 + bigint_2 == bigint_2 + bigint_1);

    // Add zero stays the same
    let result_1 = bigint_1 + bigint_zero;
    assert(result_1 == bigint_1);
    assert(result_1.limbs().get(0).unwrap() == 1);
    assert(result_1.limbs().len() == 1);

    // Add two numbers with no overflow
    let result_2 = bigint_1 + bigint_2;
    assert(result_2 == BigInt::from(21u64));
    assert(result_2.limbs().get(0).unwrap() == 21);
    assert(result_2.limbs().len() == 1);

    // Add self to self
    let result_3 = bigint_1 + bigint_1;
    assert(result_3 == BigInt::from(2u64));
    assert(result_3.limbs().get(0).unwrap() == 2);
    assert(result_3.limbs().len() == 1);

    // Add results in new limb
    let result_4 = bigint_1 + bigint_3;
    assert(result_4.limbs().get(0).unwrap() == 0);
    assert(result_4.limbs().get(1).unwrap() == 1);
    assert(result_4.limbs().len() == 2);

    // Add two limbs to one limb
    let result_5 = bigint_1 + bigint_4;
    assert(result_5.limbs().get(0).unwrap() == 1);
    assert(result_5.limbs().get(1).unwrap() == 1);
    assert(result_5.limbs().len() == 2);

    // Add two limbs to one limb resulting in 3 limbs
    let result_6 = bigint_1 + bigint_5;
    assert(result_6.limbs().get(0).unwrap() == 0);
    assert(result_6.limbs().get(1).unwrap() == 0);
    assert(result_6.limbs().get(2).unwrap() == 1);
    assert(result_6.limbs().len() == 3);

    // Add goes over u256 in size
    let result_7 = bigint_1 + bigint_6;
    assert(result_7.limbs().get(0).unwrap() == 0);
    assert(result_7.limbs().get(1).unwrap() == 0);
    assert(result_7.limbs().get(2).unwrap() == 0);
    assert(result_7.limbs().get(3).unwrap() == 0);
    assert(result_7.limbs().get(4).unwrap() == 1);
    assert(result_7.limbs().len() == 5);
}

#[test]
fn bigint_mul() {
    let bigint_zero = BigInt::zero();
    let bigint_1 = BigInt::from(1u64);
    let bigint_2 = BigInt::from(2u64);
    let bigint_3 = BigInt::from(u64::max());
    let bigint_4 = BigInt::from(U128::from((1, 0)));
    let bigint_5 = BigInt::from(U128::from((9223372036854775808, 0)));
    let bigint_6 = BigInt::from(0x8000000000000000000000000000000000000000000000000000000000000000u256);

    // Two zeros mul is zero
    assert(bigint_zero * bigint_zero == bigint_zero);

    // Order does not matter
    assert(bigint_1 * bigint_2 == bigint_2 * bigint_1);

    // Mul zero to anything is zero
    let result_1 = bigint_1 * bigint_zero;
    assert(result_1 == bigint_zero);
    assert(result_1.limbs().get(0).unwrap() == 0);
    assert(result_1.limbs().len() == 1);

    // Mul one to anything is anything
    let result_2 = bigint_1 * bigint_2;
    assert(result_2 == bigint_2);
    assert(result_2.limbs().get(0).unwrap() == 2);
    assert(result_2.limbs().len() == 1);

    // Mul self to self
    let result_3 = bigint_2 * bigint_2;
    assert(result_3 == BigInt::from(4u64));
    assert(result_3.limbs().get(0).unwrap() == 4);
    assert(result_3.limbs().len() == 1);

    // Mul results in new limb
    let result_4 = bigint_2 * bigint_3;
    assert(
        result_4
            .limbs()
            .get(0)
            .unwrap() == (U128::from((0, u64::max())) * U128::from((0, 2)))
            .lower(),
    );
    assert(
        result_4
            .limbs()
            .get(1)
            .unwrap() == (U128::from((0, u64::max())) * U128::from((0, 2)))
            .upper(),
    );
    assert(result_4.limbs().len() == 2);

    // Mul two limbs to one limb
    let result_5 = bigint_2 * bigint_4;
    assert(result_5.limbs().get(0).unwrap() == 0);
    assert(result_5.limbs().get(1).unwrap() == 2);
    assert(result_5.limbs().len() == 2);

    // Mul two limbs to one limb resulting in 3 limbs
    let result_6 = bigint_2 * bigint_5;
    assert(result_6.limbs().get(0).unwrap() == 0);
    assert(result_6.limbs().get(1).unwrap() == 0);
    assert(result_6.limbs().get(2).unwrap() == 1);
    assert(result_6.limbs().len() == 3);

    // Add goes over u256 in size
    let result_7 = bigint_2 * bigint_6;
    assert(result_7.limbs().get(0).unwrap() == 0);
    assert(result_7.limbs().get(1).unwrap() == 0);
    assert(result_7.limbs().get(2).unwrap() == 0);
    assert(result_7.limbs().get(3).unwrap() == 0);
    assert(result_7.limbs().get(4).unwrap() == 1);
    assert(result_7.limbs().len() == 5);
}

#[test]
fn bigint_sub() {
    let bigint_zero = BigInt::zero();
    let bigint_1 = BigInt::from(1u64);
    let bigint_2 = BigInt::from(2u64);
    let bigint_3 = BigInt::from(u64::max());
    let bigint_4 = BigInt::from(U128::from((1, 0)));
    let bigint_5 = BigInt::from(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000u256);
    let bigint_6 = BigInt::from(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000u256);
    let bigint_7 = BigInt::from(0xFFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000u256);
    let bigint_8 = BigInt::from(u256::max());

    // Zero sub is zero
    assert(bigint_zero - bigint_zero == bigint_zero);

    // Sub zero to anything is zero
    let result_1 = bigint_1 - bigint_zero;
    assert(result_1 == bigint_1);
    assert(result_1.limbs().get(0).unwrap() == 1);
    assert(result_1.limbs().len() == 1);

    // Sub to zero
    let result_2 = (bigint_2 - bigint_1) - bigint_1;
    assert(result_2 == bigint_zero);
    assert(result_2.limbs().get(0).unwrap() == 0);
    assert(result_2.limbs().len() == 1);

    // Sub self to self
    let result_3 = bigint_2 - bigint_2;
    assert(result_3 == bigint_zero);
    assert(result_3.limbs().get(0).unwrap() == 0);
    assert(result_3.limbs().len() == 1);

    // Sub results in less limbs
    let result_4 = bigint_4 - bigint_1;
    assert(result_4.limbs().get(0).unwrap() == u64::max());
    assert(result_4.limbs().len() == 1);

    // Sub two limbs to one limb
    let result_5 = bigint_4 - bigint_3;
    assert(result_5.limbs().get(0).unwrap() == 1);
    assert(result_5.limbs().len() == 1);

    // Sub four limbs to three limbs
    let result_6 = bigint_8 - bigint_7;
    assert(result_6.limbs().get(0).unwrap() == u64::max());
    assert(result_6.limbs().get(1).unwrap() == u64::max());
    assert(result_6.limbs().get(2).unwrap() == u64::max());
    assert(result_6.limbs().len() == 3);

    // Sub four limbs to two limbs
    let result_7 = bigint_8 - bigint_6;
    assert(result_7.limbs().get(0).unwrap() == u64::max());
    assert(result_7.limbs().get(1).unwrap() == u64::max());
    assert(result_7.limbs().len() == 2);

    // Sub four limbs to one limb
    let result_7 = bigint_8 - bigint_5;
    assert(result_7.limbs().get(0).unwrap() == u64::max());
    assert(result_7.limbs().len() == 1);
}

#[test(should_revert)]
fn bigint_sub_negative() {
    let bigint_zero = BigInt::zero();
    let bigint_1 = BigInt::from(1u64);
    let result = bigint_zero - bigint_1;
}
