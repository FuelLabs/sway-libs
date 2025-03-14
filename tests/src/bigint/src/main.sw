library;

use sway_libs::bigint::BigUint;
use std::u128::U128;
use std::bytes::Bytes;
use std::flags::{disable_panic_on_overflow, disable_panic_on_unsafe_math};

#[test]
fn big_uint_new() {
    let big_uint = BigUint::new();

    assert(big_uint.number_of_limbs() == 1);
    assert(big_uint.limbs().len() == 1);
    assert(big_uint.limbs().get(0).unwrap() == 0);
}

#[test]
fn big_uint_equal_limb_size() {
    let big_uint_1 = BigUint::new();
    let big_uint_2 = BigUint::zero();
    let big_uint_3 = BigUint::from(1u64);
    let big_uint_4 = BigUint::from(U128::from((1, 0)));
    let big_uint_5 = BigUint::from(u256::max());

    assert(big_uint_1.equal_limb_size(big_uint_2));
    assert(big_uint_1.equal_limb_size(big_uint_3));
    assert(!big_uint_1.equal_limb_size(big_uint_4));
    assert(!big_uint_1.equal_limb_size(big_uint_5));

    assert(big_uint_2.equal_limb_size(big_uint_3));
    assert(!big_uint_2.equal_limb_size(big_uint_4));
    assert(!big_uint_2.equal_limb_size(big_uint_5));

    assert(!big_uint_3.equal_limb_size(big_uint_4));
    assert(!big_uint_3.equal_limb_size(big_uint_5));

    assert(!big_uint_4.equal_limb_size(big_uint_5));
}

#[test]
fn big_uint_number_of_limbs() {
    let big_uint_1 = BigUint::new();
    let big_uint_2 = BigUint::zero();
    let big_uint_3 = BigUint::from(1u64);
    let big_uint_4 = BigUint::from(U128::from((1, 0)));
    let big_uint_5 = BigUint::from(u256::max());

    assert(big_uint_1.number_of_limbs() == 1);
    assert(big_uint_2.number_of_limbs() == 1);
    assert(big_uint_3.number_of_limbs() == 1);
    assert(big_uint_4.number_of_limbs() == 2);
    assert(big_uint_5.number_of_limbs() == 4);
}

#[test]
fn big_uint_limbs() {
    // The returned vec should only be a copy.
    let mut big_uint_1 = BigUint::zero();
    big_uint_1.limbs().set(0, 10); // This does nothing
    assert(big_uint_1 == BigUint::zero());

    let big_uint_2 = BigUint::from(1u64);
    let result_vec = big_uint_2.limbs();
    assert(result_vec.get(0).unwrap() == 1);
}

#[test]
fn big_uint_get_limb() {
    let big_uint_1 = BigUint::new();
    let big_uint_2 = BigUint::zero();
    let big_uint_3 = BigUint::from(1u64);
    let big_uint_4 = BigUint::from(U128::from((1, 0)));
    let big_uint_5 = BigUint::from(u256::max());

    assert(big_uint_1.get_limb(0).unwrap() == 0);
    assert(big_uint_1.get_limb(1) == None);

    assert(big_uint_2.get_limb(0).unwrap() == 0);
    assert(big_uint_2.get_limb(1) == None);

    assert(big_uint_3.get_limb(0).unwrap() == 1);
    assert(big_uint_3.get_limb(1) == None);

    assert(big_uint_4.get_limb(0).unwrap() == 0);
    assert(big_uint_4.get_limb(1).unwrap() == 1);
    assert(big_uint_4.get_limb(2) == None);

    assert(big_uint_5.get_limb(0).unwrap() == u64::max());
    assert(big_uint_5.get_limb(1).unwrap() == u64::max());
    assert(big_uint_5.get_limb(2).unwrap() == u64::max());
    assert(big_uint_5.get_limb(3).unwrap() == u64::max());
    assert(big_uint_5.get_limb(4) == None);
}

#[test]
fn big_uint_zero() {
    let big_uint = BigUint::zero();

    assert(big_uint.number_of_limbs() == 1);
    assert(big_uint.limbs().len() == 1);
    assert(big_uint.limbs().get(0).unwrap() == 0);
}

#[test]
fn big_uint_is_zero() {
    let big_uint_1 = BigUint::zero();
    assert(big_uint_1.is_zero());

    let big_uint_2 = BigUint::new();
    assert(big_uint_2.is_zero());

    let big_uint_3 = BigUint::from(u256::zero());
    assert(big_uint_3.is_zero());

    let big_uint_4 = BigUint::from(1u64);
    assert(!big_uint_4.is_zero());

    let big_uint_5 = BigUint::from(U128::from((1, 0)));
    assert(!big_uint_5.is_zero());
}

#[test]
fn big_uint_clone() {
    let big_uint_1 = BigUint::zero();
    let big_uint_2 = big_uint_1.clone();
    assert(big_uint_1 == big_uint_2);
    assert(__addr_of(big_uint_1) != __addr_of(big_uint_2));

    let big_uint_3 = BigUint::from(1u64);
    let big_uint_4 = big_uint_3.clone();
    assert(big_uint_3 == big_uint_4);
    assert(__addr_of(big_uint_3) != __addr_of(big_uint_4));
}

#[test]
fn big_uint_from_u8() {
    let big_uint_1 = BigUint::from(0u8);
    assert(big_uint_1.number_of_limbs() == 1);
    assert(big_uint_1.is_zero());

    let big_uint_2 = BigUint::from(1u8);
    assert(big_uint_2.number_of_limbs() == 1);
    assert(big_uint_2.get_limb(0).unwrap() == 1);

    let big_uint_3 = BigUint::from(u8::max());
    assert(big_uint_3.number_of_limbs() == 1);
    assert(big_uint_3.get_limb(0).unwrap() == u8::max().as_u64());
}

#[test]
fn big_uint_try_into_u8() {
    let big_uint_1 = BigUint::zero();
    assert(<BigUint as TryInto<u8>>::try_into(big_uint_1).unwrap() == 0u8);

    let big_uint_2 = BigUint::from(1u8);
    assert(<BigUint as TryInto<u8>>::try_into(big_uint_2).unwrap() == 1u8);

    let big_uint_3 = BigUint::from(u8::max());
    assert(<BigUint as TryInto<u8>>::try_into(big_uint_3).unwrap() == u8::max());

    let big_uint_4 = BigUint::from(u8::max().as_u64() + 1u64);
    assert(<BigUint as TryInto<u8>>::try_into(big_uint_4) == None);
}

#[test]
fn big_uint_from_u16() {
    let big_uint_1 = BigUint::from(0u16);
    assert(big_uint_1.number_of_limbs() == 1);
    assert(big_uint_1.is_zero());

    let big_uint_2 = BigUint::from(1u16);
    assert(big_uint_2.number_of_limbs() == 1);
    assert(big_uint_2.get_limb(0).unwrap() == 1);

    let big_uint_3 = BigUint::from(u16::max());
    assert(big_uint_3.number_of_limbs() == 1);
    assert(big_uint_3.get_limb(0).unwrap() == u16::max().as_u64());
}

#[test]
fn big_uint_try_into_u16() {
    let big_uint_1 = BigUint::zero();
    assert(<BigUint as TryInto<u16>>::try_into(big_uint_1).unwrap() == 0u16);

    let big_uint_2 = BigUint::from(1u16);
    assert(<BigUint as TryInto<u16>>::try_into(big_uint_2).unwrap() == 1u16);

    let big_uint_3 = BigUint::from(u16::max());
    assert(<BigUint as TryInto<u16>>::try_into(big_uint_3).unwrap() == u16::max());

    let big_uint_4 = BigUint::from(u16::max().as_u64() + 1u64);
    assert(<BigUint as TryInto<u16>>::try_into(big_uint_4) == None);
}

#[test]
fn big_uint_from_u32() {
    let big_uint_1 = BigUint::from(0u32);
    assert(big_uint_1.number_of_limbs() == 1);
    assert(big_uint_1.is_zero());

    let big_uint_2 = BigUint::from(1u32);
    assert(big_uint_2.number_of_limbs() == 1);
    assert(big_uint_2.get_limb(0).unwrap() == 1);

    let big_uint_3 = BigUint::from(u32::max());
    assert(big_uint_3.number_of_limbs() == 1);
    assert(big_uint_3.get_limb(0).unwrap() == u32::max().as_u64());
}

#[test]
fn big_uint_try_into_u32() {
    let big_uint_1 = BigUint::zero();
    assert(<BigUint as TryInto<u32>>::try_into(big_uint_1).unwrap() == 0u32);

    let big_uint_2 = BigUint::from(1u32);
    assert(<BigUint as TryInto<u32>>::try_into(big_uint_2).unwrap() == 1u32);

    let big_uint_3 = BigUint::from(u32::max());
    assert(<BigUint as TryInto<u32>>::try_into(big_uint_3).unwrap() == u32::max());

    let big_uint_4 = BigUint::from(u32::max().as_u64() + 1u64);
    assert(<BigUint as TryInto<u32>>::try_into(big_uint_4) == None);
}

#[test]
fn big_uint_from_u64() {
    let big_uint_1 = BigUint::from(0u64);
    assert(big_uint_1.number_of_limbs() == 1);
    assert(big_uint_1.is_zero());

    let big_uint_2 = BigUint::from(1u64);
    assert(big_uint_2.number_of_limbs() == 1);
    assert(big_uint_2.get_limb(0).unwrap() == 1);

    let big_uint_3 = BigUint::from(u64::max());
    assert(big_uint_3.number_of_limbs() == 1);
    assert(big_uint_3.get_limb(0).unwrap() == u64::max());
}

#[test]
fn big_uint_try_into_u64() {
    let big_uint_1 = BigUint::zero();
    assert(<BigUint as TryInto<u64>>::try_into(big_uint_1).unwrap() == 0u64);

    let big_uint_2 = BigUint::from(1u64);
    assert(<BigUint as TryInto<u64>>::try_into(big_uint_2).unwrap() == 1u64);

    let big_uint_3 = BigUint::from(u64::max());
    assert(<BigUint as TryInto<u64>>::try_into(big_uint_3).unwrap() == u64::max());

    let big_uint_4 = BigUint::from(u64::max().as_u256() + 1u64.as_u256());
    assert(<BigUint as TryInto<u64>>::try_into(big_uint_4) == None);
}

#[test]
fn big_uint_from_u128() {
    let big_uint_1 = BigUint::from(U128::zero());
    assert(big_uint_1.number_of_limbs() == 1);
    assert(big_uint_1.is_zero());

    let big_uint_2 = BigUint::from(U128::from((0, 1)));
    assert(big_uint_2.number_of_limbs() == 1);
    assert(big_uint_2.get_limb(0).unwrap() == 1);

    let big_uint_3 = BigUint::from(U128::from((1, 0)));
    assert(big_uint_3.number_of_limbs() == 2);
    assert(big_uint_3.get_limb(0).unwrap() == 0);
    assert(big_uint_3.get_limb(1).unwrap() == 1);

    let big_uint_4 = BigUint::from(U128::max());
    assert(big_uint_4.number_of_limbs() == 2);
    assert(big_uint_4.get_limb(0).unwrap() == u64::max());
    assert(big_uint_4.get_limb(1).unwrap() == u64::max());
}

#[test]
fn big_uint_try_into_u128() {
    let big_uint_1 = BigUint::zero();
    assert(<BigUint as TryInto<U128>>::try_into(big_uint_1).unwrap() == U128::zero());

    let big_uint_2 = BigUint::from(1u64);
    assert(<BigUint as TryInto<U128>>::try_into(big_uint_2).unwrap() == U128::from((0, 1)));

    let big_uint_3 = BigUint::from(u64::max());
    assert(
        <BigUint as TryInto<U128>>::try_into(big_uint_3)
            .unwrap() == U128::from((0, u64::max())),
    );

    let big_uint_4 = BigUint::from(u64::max().as_u256() + 1u64.as_u256());
    assert(<BigUint as TryInto<U128>>::try_into(big_uint_4).unwrap() == U128::from((1, 0)));

    let big_uint_5 = BigUint::from(u256::from(U128::max()) + 1u64.as_u256());
    assert(<BigUint as TryInto<U128>>::try_into(big_uint_5) == None);
}

#[test]
fn big_uint_from_u256() {
    let big_uint_1 = BigUint::from(u256::zero());
    assert(big_uint_1.number_of_limbs() == 1);
    assert(big_uint_1.is_zero());

    let big_uint_2 = BigUint::from(0x0000000000000000000000000000000000000000000000000000000000000001u256);
    assert(big_uint_2.number_of_limbs() == 1);
    assert(big_uint_2.get_limb(0).unwrap() == 1);

    let big_uint_3 = BigUint::from(0x0000000000000000000000000000000000000000000000010000000000000000u256);
    assert(big_uint_3.number_of_limbs() == 2);
    assert(big_uint_3.get_limb(0).unwrap() == 0);
    assert(big_uint_3.get_limb(1).unwrap() == 1);

    let big_uint_4 = BigUint::from(0x0000000000000000000000000000000100000000000000000000000000000000u256);
    assert(big_uint_4.number_of_limbs() == 3);
    assert(big_uint_4.get_limb(0).unwrap() == 0);
    assert(big_uint_4.get_limb(1).unwrap() == 0);
    assert(big_uint_4.get_limb(2).unwrap() == 1);

    let big_uint_5 = BigUint::from(u256::max());
    assert(big_uint_5.number_of_limbs() == 4);
    assert(big_uint_5.get_limb(0).unwrap() == u64::max());
    assert(big_uint_5.get_limb(1).unwrap() == u64::max());
    assert(big_uint_5.get_limb(2).unwrap() == u64::max());
    assert(big_uint_5.get_limb(3).unwrap() == u64::max());
}

#[test]
fn big_uint_try_into_u256() {
    let big_uint_1 = BigUint::zero();
    assert(<BigUint as TryInto<u256>>::try_into(big_uint_1).unwrap() == u256::zero());

    let big_uint_2 = BigUint::from(0x0000000000000000000000000000000000000000000000000000000000000001u256);
    assert(
        <BigUint as TryInto<u256>>::try_into(big_uint_2)
            .unwrap() == 0x0000000000000000000000000000000000000000000000000000000000000001u256,
    );

    let big_uint_3 = BigUint::from(0x0000000000000000000000000000000000000000000000010000000000000000u256);
    assert(
        <BigUint as TryInto<u256>>::try_into(big_uint_3)
            .unwrap() == 0x0000000000000000000000000000000000000000000000010000000000000000u256,
    );

    let big_uint_4 = BigUint::from(0x0000000000000000000000000000000100000000000000000000000000000000u256);
    assert(
        <BigUint as TryInto<u256>>::try_into(big_uint_4)
            .unwrap() == 0x0000000000000000000000000000000100000000000000000000000000000000u256,
    );

    let big_uint_5 = BigUint::from(u256::max());
    assert(<BigUint as TryInto<u256>>::try_into(big_uint_5).unwrap() == u256::max());

    let big_uint_6 = BigUint::from(u256::max()) + BigUint::from(1u64);
    assert(<BigUint as TryInto<u64>>::try_into(big_uint_6) == None);
}

#[test]
fn big_uint_from_bytes() {
    // New is zero
    let big_uint_1 = BigUint::from(Bytes::new());
    assert(big_uint_1.number_of_limbs() == 1);
    assert(big_uint_1.is_zero());

    // One 0u8 is zero
    let mut bytes_2 = Bytes::new();
    bytes_2.push(0u8);
    let big_uint_2 = BigUint::from(bytes_2);
    assert(big_uint_2.number_of_limbs() == 1);
    assert(big_uint_2.is_zero());

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
    let big_uint_3 = BigUint::from(bytes_3);
    assert(big_uint_3.number_of_limbs() == 1);
    assert(big_uint_3.is_zero());

    // Single u8
    let mut bytes_4 = Bytes::new();
    bytes_4.push(1u8);
    let big_uint_4 = BigUint::from(bytes_4);
    assert(big_uint_4.number_of_limbs() == 1);
    assert(big_uint_4.get_limb(0).unwrap() == 1);

    // u8 with leading zeros
    let mut bytes_5 = Bytes::new();
    bytes_5.push(0u8);
    bytes_5.push(1u8);
    let big_uint_5 = BigUint::from(bytes_5);
    assert(big_uint_5.number_of_limbs() == 1);
    assert(big_uint_5.get_limb(0).unwrap() == 1);

    // two u8 
    let mut bytes_6 = Bytes::new();
    bytes_6.push(0u8);
    bytes_6.insert(0, 1u8);
    let big_uint_6 = BigUint::from(bytes_6);
    assert(big_uint_6.number_of_limbs() == 1);
    assert(big_uint_6.get_limb(0).unwrap() == 256);

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
    let big_uint_7 = BigUint::from(bytes_7);
    assert(big_uint_7.number_of_limbs() == 1);
    assert(big_uint_7.get_limb(0).unwrap() == u64::max());

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
    let big_uint_8 = BigUint::from(bytes_8);
    assert(big_uint_8.number_of_limbs() == 1);
    assert(big_uint_8.get_limb(0).unwrap() == u64::max());

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
    let big_uint_9 = BigUint::from(bytes_9);
    assert(big_uint_9.number_of_limbs() == 2);
    assert(big_uint_9.get_limb(0).unwrap() == 0);
    assert(big_uint_9.get_limb(1).unwrap() == 1);

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
    let big_uint_10 = BigUint::from(bytes_10);
    assert(big_uint_10.number_of_limbs() == 3);
    assert(big_uint_10.get_limb(0).unwrap() == 0);
    assert(big_uint_10.get_limb(1).unwrap() == 0);
    assert(big_uint_10.get_limb(2).unwrap() == 1);
}

#[test]
fn big_uint_into_bytes() {
    // New is 0
    let big_uint_1 = BigUint::from(Bytes::new());
    let converted_bytes_1: Bytes = <BigUint as Into<Bytes>>::into(big_uint_1);
    assert(converted_bytes_1.len() == 0);

    // One 0u8 is zero
    let mut bytes_2 = Bytes::new();
    bytes_2.push(0u8);
    let big_uint_2 = BigUint::from(bytes_2);
    let converted_bytes_2: Bytes = <BigUint as Into<Bytes>>::into(big_uint_2);
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
    let big_uint_3 = BigUint::from(bytes_3);
    let converted_bytes_3: Bytes = <BigUint as Into<Bytes>>::into(big_uint_3);
    assert(converted_bytes_3.len() == 0);

    // Single u8
    let mut bytes_4 = Bytes::new();
    bytes_4.push(1u8);
    let big_uint_4 = BigUint::from(bytes_4);
    let converted_bytes_4: Bytes = <BigUint as Into<Bytes>>::into(big_uint_4);
    assert(converted_bytes_4.len() == 1);
    assert(converted_bytes_4.get(0).unwrap() == 1);

    // single u8 with leading zeros
    let mut bytes_5 = Bytes::new();
    bytes_5.push(0u8);
    bytes_5.push(1u8);
    let big_uint_5 = BigUint::from(bytes_5);
    let converted_bytes_5: Bytes = <BigUint as Into<Bytes>>::into(big_uint_5);
    assert(converted_bytes_5.len() == 1);
    assert(converted_bytes_5.get(0).unwrap() == 1);

    // two u8 
    let mut bytes_6 = Bytes::new();
    bytes_6.push(0u8);
    bytes_6.insert(0, 1u8);
    let big_uint_6 = BigUint::from(bytes_6);
    let converted_bytes_6: Bytes = <BigUint as Into<Bytes>>::into(big_uint_6);
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
    let big_uint_7 = BigUint::from(bytes_7);
    let converted_bytes_7: Bytes = <BigUint as Into<Bytes>>::into(big_uint_7);
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
    let big_uint_8 = BigUint::from(bytes_8);
    let converted_bytes_8: Bytes = <BigUint as Into<Bytes>>::into(big_uint_8);
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
    let big_uint_9 = BigUint::from(bytes_9);
    let converted_bytes_9: Bytes = <BigUint as Into<Bytes>>::into(big_uint_9);
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
    let big_uint_10 = BigUint::from(bytes_10);
    let converted_bytes_10: Bytes = <BigUint as Into<Bytes>>::into(big_uint_10);
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
fn big_uint_eq() {
    let big_uint_1 = BigUint::zero();
    let big_uint_2 = BigUint::zero();
    let big_uint_3 = BigUint::from(1u64);
    let big_uint_4 = BigUint::from(1u64);
    let big_uint_5 = BigUint::from(20u64);
    let big_uint_6 = BigUint::from(20u64);
    let big_uint_7 = BigUint::from(u64::max());
    let big_uint_8 = BigUint::from(u64::max());
    let big_uint_9 = BigUint::from(U128::from((1, 0)));
    let big_uint_10 = BigUint::from(U128::from((1, 0)));
    let big_uint_11 = BigUint::from(U128::from((u64::max(), u64::max())));
    let big_uint_12 = BigUint::from(U128::from((u64::max(), u64::max())));
    let big_uint_13 = BigUint::from(u256::max());
    let big_uint_14 = BigUint::from(u256::max());

    assert(big_uint_1 == big_uint_2);
    assert(big_uint_3 == big_uint_4);
    assert(big_uint_5 == big_uint_6);
    assert(big_uint_7 == big_uint_8);
    assert(big_uint_9 == big_uint_10);
    assert(big_uint_11 == big_uint_12);
    assert(big_uint_13 == big_uint_14);

    assert(big_uint_1 != big_uint_3);
    assert(big_uint_1 != big_uint_5);
    assert(big_uint_1 != big_uint_7);
    assert(big_uint_1 != big_uint_9);
    assert(big_uint_1 != big_uint_11);
    assert(big_uint_1 != big_uint_13);

    assert(big_uint_3 != big_uint_5);
    assert(big_uint_3 != big_uint_7);
    assert(big_uint_3 != big_uint_9);
    assert(big_uint_3 != big_uint_11);
    assert(big_uint_3 != big_uint_13);

    assert(big_uint_5 != big_uint_7);
    assert(big_uint_5 != big_uint_9);
    assert(big_uint_5 != big_uint_11);
    assert(big_uint_5 != big_uint_13);

    assert(big_uint_7 != big_uint_9);
    assert(big_uint_7 != big_uint_11);
    assert(big_uint_7 != big_uint_13);

    assert(big_uint_9 != big_uint_11);
    assert(big_uint_9 != big_uint_13);

    assert(big_uint_11 != big_uint_13);
}

#[test]
fn big_uint_ord() {
    let big_uint_zero = BigUint::zero();
    let big_uint_1 = BigUint::from(1u64);
    let big_uint_2 = BigUint::from(20u64);
    let big_uint_3 = BigUint::from(u64::max());
    let big_uint_4 = BigUint::from(U128::from((1, 0)));
    let big_uint_5 = BigUint::from(U128::from((u64::max(), u64::max())));
    let big_uint_6 = BigUint::from(u256::max());

    assert(big_uint_zero < big_uint_1);
    assert(big_uint_zero < big_uint_2);
    assert(big_uint_zero < big_uint_3);
    assert(big_uint_zero < big_uint_4);
    assert(big_uint_zero < big_uint_5);
    assert(big_uint_zero < big_uint_6);
    assert(big_uint_1 > big_uint_zero);
    assert(big_uint_2 > big_uint_zero);
    assert(big_uint_3 > big_uint_zero);
    assert(big_uint_4 > big_uint_zero);
    assert(big_uint_5 > big_uint_zero);
    assert(big_uint_6 > big_uint_zero);

    assert(big_uint_1 < big_uint_2);
    assert(big_uint_1 < big_uint_3);
    assert(big_uint_1 < big_uint_4);
    assert(big_uint_1 < big_uint_5);
    assert(big_uint_1 < big_uint_6);
    assert(big_uint_2 > big_uint_1);
    assert(big_uint_3 > big_uint_1);
    assert(big_uint_4 > big_uint_1);
    assert(big_uint_5 > big_uint_1);
    assert(big_uint_6 > big_uint_1);

    assert(big_uint_2 < big_uint_3);
    assert(big_uint_2 < big_uint_4);
    assert(big_uint_2 < big_uint_5);
    assert(big_uint_2 < big_uint_6);
    assert(big_uint_3 > big_uint_2);
    assert(big_uint_4 > big_uint_2);
    assert(big_uint_5 > big_uint_2);
    assert(big_uint_6 > big_uint_2);

    assert(big_uint_3 < big_uint_4);
    assert(big_uint_3 < big_uint_5);
    assert(big_uint_3 < big_uint_6);
    assert(big_uint_4 > big_uint_3);
    assert(big_uint_5 > big_uint_3);
    assert(big_uint_6 > big_uint_3);

    assert(big_uint_4 < big_uint_5);
    assert(big_uint_4 < big_uint_6);
    assert(big_uint_5 > big_uint_4);
    assert(big_uint_6 > big_uint_4);

    assert(big_uint_5 < big_uint_6);
    assert(big_uint_6 > big_uint_5);
}

#[test]
fn big_uint_add() {
    let big_uint_zero = BigUint::zero();
    let big_uint_1 = BigUint::from(1u64);
    let big_uint_2 = BigUint::from(20u64);
    let big_uint_3 = BigUint::from(u64::max());
    let big_uint_4 = BigUint::from(U128::from((1, 0)));
    let big_uint_5 = BigUint::from(U128::from((u64::max(), u64::max())));
    let big_uint_6 = BigUint::from(u256::max());

    // Two zeros added is zero
    assert(big_uint_zero + big_uint_zero == big_uint_zero);

    // Order does not matter
    assert(big_uint_1 + big_uint_2 == big_uint_2 + big_uint_1);

    // Add zero stays the same
    let result_1 = big_uint_1 + big_uint_zero;
    assert(result_1 == big_uint_1);
    assert(result_1.limbs().get(0).unwrap() == 1);
    assert(result_1.limbs().len() == 1);

    // Add two numbers with no overflow
    let result_2 = big_uint_1 + big_uint_2;
    assert(result_2 == BigUint::from(21u64));
    assert(result_2.limbs().get(0).unwrap() == 21);
    assert(result_2.limbs().len() == 1);

    // Add self to self
    let result_3 = big_uint_1 + big_uint_1;
    assert(result_3 == BigUint::from(2u64));
    assert(result_3.limbs().get(0).unwrap() == 2);
    assert(result_3.limbs().len() == 1);

    // Add results in new limb
    let result_4 = big_uint_1 + big_uint_3;
    assert(result_4.limbs().get(0).unwrap() == 0);
    assert(result_4.limbs().get(1).unwrap() == 1);
    assert(result_4.limbs().len() == 2);

    // Add two limbs to one limb
    let result_5 = big_uint_1 + big_uint_4;
    assert(result_5.limbs().get(0).unwrap() == 1);
    assert(result_5.limbs().get(1).unwrap() == 1);
    assert(result_5.limbs().len() == 2);

    // Add two limbs to one limb resulting in 3 limbs
    let result_6 = big_uint_1 + big_uint_5;
    assert(result_6.limbs().get(0).unwrap() == 0);
    assert(result_6.limbs().get(1).unwrap() == 0);
    assert(result_6.limbs().get(2).unwrap() == 1);
    assert(result_6.limbs().len() == 3);

    // Add goes over u256 in size
    let result_7 = big_uint_1 + big_uint_6;
    assert(result_7.limbs().get(0).unwrap() == 0);
    assert(result_7.limbs().get(1).unwrap() == 0);
    assert(result_7.limbs().get(2).unwrap() == 0);
    assert(result_7.limbs().get(3).unwrap() == 0);
    assert(result_7.limbs().get(4).unwrap() == 1);
    assert(result_7.limbs().len() == 5);
}

#[test]
fn big_uint_add_enable_overflow() {
    let _ = disable_panic_on_overflow();

    let big_uint_zero = BigUint::zero();
    let big_uint_1 = BigUint::from(1u64);
    let big_uint_2 = BigUint::from(20u64);
    let big_uint_3 = BigUint::from(u64::max());
    let big_uint_4 = BigUint::from(U128::from((1, 0)));
    let big_uint_5 = BigUint::from(U128::from((u64::max(), u64::max())));
    let big_uint_6 = BigUint::from(u256::max());

    // Two zeros added is zero
    assert(big_uint_zero + big_uint_zero == big_uint_zero);

    // Order does not matter
    assert(big_uint_1 + big_uint_2 == big_uint_2 + big_uint_1);

    // Add zero stays the same
    let result_1 = big_uint_1 + big_uint_zero;
    assert(result_1 == big_uint_1);
    assert(result_1.limbs().get(0).unwrap() == 1);
    assert(result_1.limbs().len() == 1);

    // Add two numbers with no overflow
    let result_2 = big_uint_1 + big_uint_2;
    assert(result_2 == BigUint::from(21u64));
    assert(result_2.limbs().get(0).unwrap() == 21);
    assert(result_2.limbs().len() == 1);

    // Add self to self
    let result_3 = big_uint_1 + big_uint_1;
    assert(result_3 == BigUint::from(2u64));
    assert(result_3.limbs().get(0).unwrap() == 2);
    assert(result_3.limbs().len() == 1);

    // Add results in new limb
    let result_4 = big_uint_1 + big_uint_3;
    assert(result_4.limbs().get(0).unwrap() == 0);
    assert(result_4.limbs().get(1).unwrap() == 1);
    assert(result_4.limbs().len() == 2);

    // Add two limbs to one limb
    let result_5 = big_uint_1 + big_uint_4;
    assert(result_5.limbs().get(0).unwrap() == 1);
    assert(result_5.limbs().get(1).unwrap() == 1);
    assert(result_5.limbs().len() == 2);

    // Add two limbs to one limb resulting in 3 limbs
    let result_6 = big_uint_1 + big_uint_5;
    assert(result_6.limbs().get(0).unwrap() == 0);
    assert(result_6.limbs().get(1).unwrap() == 0);
    assert(result_6.limbs().get(2).unwrap() == 1);
    assert(result_6.limbs().len() == 3);

    // Add goes over u256 in size
    let result_7 = big_uint_1 + big_uint_6;
    assert(result_7.limbs().get(0).unwrap() == 0);
    assert(result_7.limbs().get(1).unwrap() == 0);
    assert(result_7.limbs().get(2).unwrap() == 0);
    assert(result_7.limbs().get(3).unwrap() == 0);
    assert(result_7.limbs().get(4).unwrap() == 1);
    assert(result_7.limbs().len() == 5);
}

#[test]
fn big_uint_add_enable_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let big_uint_zero = BigUint::zero();
    let big_uint_1 = BigUint::from(1u64);
    let big_uint_2 = BigUint::from(20u64);
    let big_uint_3 = BigUint::from(u64::max());
    let big_uint_4 = BigUint::from(U128::from((1, 0)));
    let big_uint_5 = BigUint::from(U128::from((u64::max(), u64::max())));
    let big_uint_6 = BigUint::from(u256::max());

    // Two zeros added is zero
    assert(big_uint_zero + big_uint_zero == big_uint_zero);

    // Order does not matter
    assert(big_uint_1 + big_uint_2 == big_uint_2 + big_uint_1);

    // Add zero stays the same
    let result_1 = big_uint_1 + big_uint_zero;
    assert(result_1 == big_uint_1);
    assert(result_1.limbs().get(0).unwrap() == 1);
    assert(result_1.limbs().len() == 1);

    // Add two numbers with no overflow
    let result_2 = big_uint_1 + big_uint_2;
    assert(result_2 == BigUint::from(21u64));
    assert(result_2.limbs().get(0).unwrap() == 21);
    assert(result_2.limbs().len() == 1);

    // Add self to self
    let result_3 = big_uint_1 + big_uint_1;
    assert(result_3 == BigUint::from(2u64));
    assert(result_3.limbs().get(0).unwrap() == 2);
    assert(result_3.limbs().len() == 1);

    // Add results in new limb
    let result_4 = big_uint_1 + big_uint_3;
    assert(result_4.limbs().get(0).unwrap() == 0);
    assert(result_4.limbs().get(1).unwrap() == 1);
    assert(result_4.limbs().len() == 2);

    // Add two limbs to one limb
    let result_5 = big_uint_1 + big_uint_4;
    assert(result_5.limbs().get(0).unwrap() == 1);
    assert(result_5.limbs().get(1).unwrap() == 1);
    assert(result_5.limbs().len() == 2);

    // Add two limbs to one limb resulting in 3 limbs
    let result_6 = big_uint_1 + big_uint_5;
    assert(result_6.limbs().get(0).unwrap() == 0);
    assert(result_6.limbs().get(1).unwrap() == 0);
    assert(result_6.limbs().get(2).unwrap() == 1);
    assert(result_6.limbs().len() == 3);

    // Add goes over u256 in size
    let result_7 = big_uint_1 + big_uint_6;
    assert(result_7.limbs().get(0).unwrap() == 0);
    assert(result_7.limbs().get(1).unwrap() == 0);
    assert(result_7.limbs().get(2).unwrap() == 0);
    assert(result_7.limbs().get(3).unwrap() == 0);
    assert(result_7.limbs().get(4).unwrap() == 1);
    assert(result_7.limbs().len() == 5);
}

#[test]
fn big_uint_mul() {
    let big_uint_zero = BigUint::zero();
    let big_uint_1 = BigUint::from(1u64);
    let big_uint_2 = BigUint::from(2u64);
    let big_uint_3 = BigUint::from(u64::max());
    let big_uint_4 = BigUint::from(U128::from((1, 0)));
    let big_uint_5 = BigUint::from(U128::from((9223372036854775808, 0)));
    let big_uint_6 = BigUint::from(0x8000000000000000000000000000000000000000000000000000000000000000u256);

    // Two zeros mul is zero
    assert(big_uint_zero * big_uint_zero == big_uint_zero);

    // Order does not matter
    assert(big_uint_1 * big_uint_2 == big_uint_2 * big_uint_1);

    // Mul zero to anything is zero
    let result_1 = big_uint_1 * big_uint_zero;
    assert(result_1 == big_uint_zero);
    assert(result_1.limbs().get(0).unwrap() == 0);
    assert(result_1.limbs().len() == 1);

    // Mul one to anything is anything
    let result_2 = big_uint_1 * big_uint_2;
    assert(result_2 == big_uint_2);
    assert(result_2.limbs().get(0).unwrap() == 2);
    assert(result_2.limbs().len() == 1);

    // Mul self to self
    let result_3 = big_uint_2 * big_uint_2;
    assert(result_3 == BigUint::from(4u64));
    assert(result_3.limbs().get(0).unwrap() == 4);
    assert(result_3.limbs().len() == 1);

    // Mul results in new limb
    let result_4 = big_uint_2 * big_uint_3;
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
    let result_5 = big_uint_2 * big_uint_4;
    assert(result_5.limbs().get(0).unwrap() == 0);
    assert(result_5.limbs().get(1).unwrap() == 2);
    assert(result_5.limbs().len() == 2);

    // Mul two limbs to one limb resulting in 3 limbs
    let result_6 = big_uint_2 * big_uint_5;
    assert(result_6.limbs().get(0).unwrap() == 0);
    assert(result_6.limbs().get(1).unwrap() == 0);
    assert(result_6.limbs().get(2).unwrap() == 1);
    assert(result_6.limbs().len() == 3);

    // Add goes over u256 in size
    let result_7 = big_uint_2 * big_uint_6;
    assert(result_7.limbs().get(0).unwrap() == 0);
    assert(result_7.limbs().get(1).unwrap() == 0);
    assert(result_7.limbs().get(2).unwrap() == 0);
    assert(result_7.limbs().get(3).unwrap() == 0);
    assert(result_7.limbs().get(4).unwrap() == 1);
    assert(result_7.limbs().len() == 5);
}

#[test]
fn big_uint_mul_enable_overfow() {
    let _ = disable_panic_on_overflow();

    let big_uint_zero = BigUint::zero();
    let big_uint_1 = BigUint::from(1u64);
    let big_uint_2 = BigUint::from(2u64);
    let big_uint_3 = BigUint::from(u64::max());
    let big_uint_4 = BigUint::from(U128::from((1, 0)));
    let big_uint_5 = BigUint::from(U128::from((9223372036854775808, 0)));
    let big_uint_6 = BigUint::from(0x8000000000000000000000000000000000000000000000000000000000000000u256);

    // Two zeros mul is zero
    assert(big_uint_zero * big_uint_zero == big_uint_zero);

    // Order does not matter
    assert(big_uint_1 * big_uint_2 == big_uint_2 * big_uint_1);

    // Mul zero to anything is zero
    let result_1 = big_uint_1 * big_uint_zero;
    assert(result_1 == big_uint_zero);
    assert(result_1.limbs().get(0).unwrap() == 0);
    assert(result_1.limbs().len() == 1);

    // Mul one to anything is anything
    let result_2 = big_uint_1 * big_uint_2;
    assert(result_2 == big_uint_2);
    assert(result_2.limbs().get(0).unwrap() == 2);
    assert(result_2.limbs().len() == 1);

    // Mul self to self
    let result_3 = big_uint_2 * big_uint_2;
    assert(result_3 == BigUint::from(4u64));
    assert(result_3.limbs().get(0).unwrap() == 4);
    assert(result_3.limbs().len() == 1);

    // Mul results in new limb
    let result_4 = big_uint_2 * big_uint_3;
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
    let result_5 = big_uint_2 * big_uint_4;
    assert(result_5.limbs().get(0).unwrap() == 0);
    assert(result_5.limbs().get(1).unwrap() == 2);
    assert(result_5.limbs().len() == 2);

    // Mul two limbs to one limb resulting in 3 limbs
    let result_6 = big_uint_2 * big_uint_5;
    assert(result_6.limbs().get(0).unwrap() == 0);
    assert(result_6.limbs().get(1).unwrap() == 0);
    assert(result_6.limbs().get(2).unwrap() == 1);
    assert(result_6.limbs().len() == 3);

    // Add goes over u256 in size
    let result_7 = big_uint_2 * big_uint_6;
    assert(result_7.limbs().get(0).unwrap() == 0);
    assert(result_7.limbs().get(1).unwrap() == 0);
    assert(result_7.limbs().get(2).unwrap() == 0);
    assert(result_7.limbs().get(3).unwrap() == 0);
    assert(result_7.limbs().get(4).unwrap() == 1);
    assert(result_7.limbs().len() == 5);
}

#[test]
fn big_uint_mul_enable_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let big_uint_zero = BigUint::zero();
    let big_uint_1 = BigUint::from(1u64);
    let big_uint_2 = BigUint::from(2u64);
    let big_uint_3 = BigUint::from(u64::max());
    let big_uint_4 = BigUint::from(U128::from((1, 0)));
    let big_uint_5 = BigUint::from(U128::from((9223372036854775808, 0)));
    let big_uint_6 = BigUint::from(0x8000000000000000000000000000000000000000000000000000000000000000u256);

    // Two zeros mul is zero
    assert(big_uint_zero * big_uint_zero == big_uint_zero);

    // Order does not matter
    assert(big_uint_1 * big_uint_2 == big_uint_2 * big_uint_1);

    // Mul zero to anything is zero
    let result_1 = big_uint_1 * big_uint_zero;
    assert(result_1 == big_uint_zero);
    assert(result_1.limbs().get(0).unwrap() == 0);
    assert(result_1.limbs().len() == 1);

    // Mul one to anything is anything
    let result_2 = big_uint_1 * big_uint_2;
    assert(result_2 == big_uint_2);
    assert(result_2.limbs().get(0).unwrap() == 2);
    assert(result_2.limbs().len() == 1);

    // Mul self to self
    let result_3 = big_uint_2 * big_uint_2;
    assert(result_3 == BigUint::from(4u64));
    assert(result_3.limbs().get(0).unwrap() == 4);
    assert(result_3.limbs().len() == 1);

    // Mul results in new limb
    let result_4 = big_uint_2 * big_uint_3;
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
    let result_5 = big_uint_2 * big_uint_4;
    assert(result_5.limbs().get(0).unwrap() == 0);
    assert(result_5.limbs().get(1).unwrap() == 2);
    assert(result_5.limbs().len() == 2);

    // Mul two limbs to one limb resulting in 3 limbs
    let result_6 = big_uint_2 * big_uint_5;
    assert(result_6.limbs().get(0).unwrap() == 0);
    assert(result_6.limbs().get(1).unwrap() == 0);
    assert(result_6.limbs().get(2).unwrap() == 1);
    assert(result_6.limbs().len() == 3);

    // Add goes over u256 in size
    let result_7 = big_uint_2 * big_uint_6;
    assert(result_7.limbs().get(0).unwrap() == 0);
    assert(result_7.limbs().get(1).unwrap() == 0);
    assert(result_7.limbs().get(2).unwrap() == 0);
    assert(result_7.limbs().get(3).unwrap() == 0);
    assert(result_7.limbs().get(4).unwrap() == 1);
    assert(result_7.limbs().len() == 5);
}

#[test]
fn big_uint_sub() {
    let big_uint_zero = BigUint::zero();
    let big_uint_1 = BigUint::from(1u64);
    let big_uint_2 = BigUint::from(2u64);
    let big_uint_3 = BigUint::from(u64::max());
    let big_uint_4 = BigUint::from(U128::from((1, 0)));
    let big_uint_5 = BigUint::from(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000u256);
    let big_uint_6 = BigUint::from(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000u256);
    let big_uint_7 = BigUint::from(0xFFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000u256);
    let big_uint_8 = BigUint::from(u256::max());

    // Zero sub is zero
    assert(big_uint_zero - big_uint_zero == big_uint_zero);

    // Sub zero to anything is zero
    let result_1 = big_uint_1 - big_uint_zero;
    assert(result_1 == big_uint_1);
    assert(result_1.limbs().get(0).unwrap() == 1);
    assert(result_1.limbs().len() == 1);

    // Sub to zero
    let result_2 = (big_uint_2 - big_uint_1) - big_uint_1;
    assert(result_2 == big_uint_zero);
    assert(result_2.limbs().get(0).unwrap() == 0);
    assert(result_2.limbs().len() == 1);

    // Sub self to self
    let result_3 = big_uint_2 - big_uint_2;
    assert(result_3 == big_uint_zero);
    assert(result_3.limbs().get(0).unwrap() == 0);
    assert(result_3.limbs().len() == 1);

    // Sub results in less limbs
    let result_4 = big_uint_4 - big_uint_1;
    assert(result_4.limbs().get(0).unwrap() == u64::max());
    assert(result_4.limbs().len() == 1);

    // Sub two limbs to one limb
    let result_5 = big_uint_4 - big_uint_3;
    assert(result_5.limbs().get(0).unwrap() == 1);
    assert(result_5.limbs().len() == 1);

    // Sub four limbs to three limbs
    let result_6 = big_uint_8 - big_uint_7;
    assert(result_6.limbs().get(0).unwrap() == u64::max());
    assert(result_6.limbs().get(1).unwrap() == u64::max());
    assert(result_6.limbs().get(2).unwrap() == u64::max());
    assert(result_6.limbs().len() == 3);

    // Sub four limbs to two limbs
    let result_7 = big_uint_8 - big_uint_6;
    assert(result_7.limbs().get(0).unwrap() == u64::max());
    assert(result_7.limbs().get(1).unwrap() == u64::max());
    assert(result_7.limbs().len() == 2);

    // Sub four limbs to one limb
    let result_7 = big_uint_8 - big_uint_5;
    assert(result_7.limbs().get(0).unwrap() == u64::max());
    assert(result_7.limbs().len() == 1);
}

#[test]
fn big_uint_sub_enable_overflow() {
    let _ = disable_panic_on_overflow();

    let big_uint_zero = BigUint::zero();
    let big_uint_1 = BigUint::from(1u64);
    let big_uint_2 = BigUint::from(2u64);
    let big_uint_3 = BigUint::from(u64::max());
    let big_uint_4 = BigUint::from(U128::from((1, 0)));
    let big_uint_5 = BigUint::from(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000u256);
    let big_uint_6 = BigUint::from(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000u256);
    let big_uint_7 = BigUint::from(0xFFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000u256);
    let big_uint_8 = BigUint::from(u256::max());

    // Zero sub is zero
    assert(big_uint_zero - big_uint_zero == big_uint_zero);

    // Sub zero to anything is zero
    let result_1 = big_uint_1 - big_uint_zero;
    assert(result_1 == big_uint_1);
    assert(result_1.limbs().get(0).unwrap() == 1);
    assert(result_1.limbs().len() == 1);

    // Sub to zero
    let result_2 = (big_uint_2 - big_uint_1) - big_uint_1;
    assert(result_2 == big_uint_zero);
    assert(result_2.limbs().get(0).unwrap() == 0);
    assert(result_2.limbs().len() == 1);

    // Sub self to self
    let result_3 = big_uint_2 - big_uint_2;
    assert(result_3 == big_uint_zero);
    assert(result_3.limbs().get(0).unwrap() == 0);
    assert(result_3.limbs().len() == 1);

    // Sub results in less limbs
    let result_4 = big_uint_4 - big_uint_1;
    assert(result_4.limbs().get(0).unwrap() == u64::max());
    assert(result_4.limbs().len() == 1);

    // Sub two limbs to one limb
    let result_5 = big_uint_4 - big_uint_3;
    assert(result_5.limbs().get(0).unwrap() == 1);
    assert(result_5.limbs().len() == 1);

    // Sub four limbs to three limbs
    let result_6 = big_uint_8 - big_uint_7;
    assert(result_6.limbs().get(0).unwrap() == u64::max());
    assert(result_6.limbs().get(1).unwrap() == u64::max());
    assert(result_6.limbs().get(2).unwrap() == u64::max());
    assert(result_6.limbs().len() == 3);

    // Sub four limbs to two limbs
    let result_7 = big_uint_8 - big_uint_6;
    assert(result_7.limbs().get(0).unwrap() == u64::max());
    assert(result_7.limbs().get(1).unwrap() == u64::max());
    assert(result_7.limbs().len() == 2);

    // Sub four limbs to one limb
    let result_7 = big_uint_8 - big_uint_5;
    assert(result_7.limbs().get(0).unwrap() == u64::max());
    assert(result_7.limbs().len() == 1);
}

#[test]
fn big_uint_sub_enable_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let big_uint_zero = BigUint::zero();
    let big_uint_1 = BigUint::from(1u64);
    let big_uint_2 = BigUint::from(2u64);
    let big_uint_3 = BigUint::from(u64::max());
    let big_uint_4 = BigUint::from(U128::from((1, 0)));
    let big_uint_5 = BigUint::from(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000u256);
    let big_uint_6 = BigUint::from(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000u256);
    let big_uint_7 = BigUint::from(0xFFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000u256);
    let big_uint_8 = BigUint::from(u256::max());

    // Zero sub is zero
    assert(big_uint_zero - big_uint_zero == big_uint_zero);

    // Sub zero to anything is zero
    let result_1 = big_uint_1 - big_uint_zero;
    assert(result_1 == big_uint_1);
    assert(result_1.limbs().get(0).unwrap() == 1);
    assert(result_1.limbs().len() == 1);

    // Sub to zero
    let result_2 = (big_uint_2 - big_uint_1) - big_uint_1;
    assert(result_2 == big_uint_zero);
    assert(result_2.limbs().get(0).unwrap() == 0);
    assert(result_2.limbs().len() == 1);

    // Sub self to self
    let result_3 = big_uint_2 - big_uint_2;
    assert(result_3 == big_uint_zero);
    assert(result_3.limbs().get(0).unwrap() == 0);
    assert(result_3.limbs().len() == 1);

    // Sub results in less limbs
    let result_4 = big_uint_4 - big_uint_1;
    assert(result_4.limbs().get(0).unwrap() == u64::max());
    assert(result_4.limbs().len() == 1);

    // Sub two limbs to one limb
    let result_5 = big_uint_4 - big_uint_3;
    assert(result_5.limbs().get(0).unwrap() == 1);
    assert(result_5.limbs().len() == 1);

    // Sub four limbs to three limbs
    let result_6 = big_uint_8 - big_uint_7;
    assert(result_6.limbs().get(0).unwrap() == u64::max());
    assert(result_6.limbs().get(1).unwrap() == u64::max());
    assert(result_6.limbs().get(2).unwrap() == u64::max());
    assert(result_6.limbs().len() == 3);

    // Sub four limbs to two limbs
    let result_7 = big_uint_8 - big_uint_6;
    assert(result_7.limbs().get(0).unwrap() == u64::max());
    assert(result_7.limbs().get(1).unwrap() == u64::max());
    assert(result_7.limbs().len() == 2);

    // Sub four limbs to one limb
    let result_7 = big_uint_8 - big_uint_5;
    assert(result_7.limbs().get(0).unwrap() == u64::max());
    assert(result_7.limbs().len() == 1);
}

#[test(should_revert)]
fn revert_big_uint_sub_underflow() {
    let _ = disable_panic_on_overflow();
    let big_uint_zero = BigUint::zero();
    let big_uint_1 = BigUint::from(1u64);
    let result = big_uint_zero - big_uint_1;
    log(result);
}

#[test(should_revert)]
fn revert_big_uint_sub_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();
    let big_uint_zero = BigUint::zero();
    let big_uint_1 = BigUint::from(1u64);
    let result = big_uint_zero - big_uint_1;
    log(result);
}

#[test(should_revert)]
fn revert_big_uint_sub_negative() {
    let big_uint_zero = BigUint::zero();
    let big_uint_1 = BigUint::from(1u64);
    let result = big_uint_zero - big_uint_1;
    log(result);
}
