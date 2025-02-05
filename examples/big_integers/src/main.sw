library;

use std::u128::U128;

// ANCHOR: import
use sway_libs::bigint::*;
// ANCHOR_END: import

// ANCHOR: import_big_uint
use sway_libs::bigint::BigUint;
// ANCHOR_END: import_big_uint

fn initialize() {
    // ANCHOR: initialize
    let mut big_int = BigUint::new();
    // ANCHOR_END: initialize

    // ANCHOR: zero
    let zero = BigUint::zero();
    // ANCHOR_END: zero
}

fn conversion() {
    // ANCHOR: positive_conversion
    let one = I8::try_from(1u8).unwrap();
    // ANCHOR_END: positive_conversion

    // ANCHOR: negative_conversion
    let negative_one = I8::neg_try_from(1u8).unwrap();
    // ANCHOR_END: negative_conversion
}

fn mathematical_ops(val1: I8, val2: I8) {
    // ANCHOR: mathematical_ops
    let big_uint_1 = BigUint::from(1u64);
    let big_uint_2 = BigUint::from(2u64);

    // Add
    let result: BigUInt = big_uint_1 + big_uint_2;

    // Multiply
    let result: BigUInt = big_uint_1 * big_uint_2;

    // Subtract
    let result: BigUInt = big_uint_2 - big_uint_1;

    // Eq
    let result: bool = big_uint_1 == big_uint_2;

    // Ord
    let result: bool = big_uint_1 < big_uint_2;     
    // ANCHOR_END: mathematical_ops
}

fn from() {
    // ANCHOR: from
    // u8
    let u8_big_int = BigUint::from(u8::max());

    // u16
    let u16_big_int = BigUint::from(u16::max());

    // u32
    let u32_big_int = BigUint::from(u32::max());

    // u64
    let u64_big_int = BigUint::from(u64::max());

    // U128
    let u128_big_int = BigUint::from(U128::max());

    // u256
    let u256_big_int = BigUint::from(u256::max());

    // Bytes
    let bytes_big_int = BigUint::from(Bytes::new());
    // ANCHOR_END: from
}

fn try_into() {
    // ANCHOR: try_into
    let big_uint = BigUint::zero();

    // u8
    let u8_result: Option<u8> = big_uint.try_into();

    // u16
    let u16_result: Option<u16> = big_uint.try_into();

    // u32
    let u32_result: Option<u32> = big_uint.try_into();

    // u64
    let u64_result: Option<u64> = big_uint.try_into();

    // U128
    let u128_big_int: Option<U128> = big_uint.try_into();

    // u256
    let u256_big_int: Option<u256> = big_uint.try_into();
    // ANCHOR_END: try_into
}

fn into() {
    let big_uint = BigUint::zero();

    // ANCHOR: into
    // Bytes
    let bytes_big_int: Bytes = big_uint.into();
    // ANCHOR_END: into
}

// ANCHOR: is_zero
fn is_zero() {
    let big_int = BitUint::zero();
    assert(big_int.is_zero());
}
// ANCHOR_END: is_zero
