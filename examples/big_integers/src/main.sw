library;

use std::u128::U128;
use std::bytes::Bytes;

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

fn mathematical_ops() {
    // ANCHOR: mathematical_ops
    let big_uint_1 = BigUint::from(1u64);
    let big_uint_2 = BigUint::from(2u64);

    // Add
    let result: BigUint = big_uint_1 + big_uint_2;

    // Multiply
    let result: BigUint = big_uint_1 * big_uint_2;

    // Subtract
    let result: BigUint = big_uint_2 - big_uint_1;

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

fn try_into_example() {
    // ANCHOR: try_into
    let big_uint = BigUint::zero();

    // u8
    let u8_result: Option<u8> = <BigUint as TryInto<u8>>::try_into(big_uint);

    // u16
    let u16_result: Option<u16> = <BigUint as TryInto<u16>>::try_into(big_uint);

    // u32
    let u32_result: Option<u32> = <BigUint as TryInto<u32>>::try_into(big_uint);

    // u64
    let u64_result: Option<u64> = <BigUint as TryInto<u64>>::try_into(big_uint);

    // U128
    let u128_big_int: Option<U128> = <BigUint as TryInto<U128>>::try_into(big_uint);

    // u256
    let u256_big_int: Option<u256> = <BigUint as TryInto<u256>>::try_into(big_uint);
    // ANCHOR_END: try_into

    // Replace the above with this when https://github.com/FuelLabs/sway/issues/6858 is resolved
    // // u8
    // let u8_result: Option<u8> = big_uint.try_into();

    // // u16
    // let u16_result: Option<u16> = big_uint.try_into();

    // // u32
    // let u32_result: Option<u32> = big_uint.try_into();

    // // u64
    // let u64_result: Option<u64> = big_uint.try_into();

    // // U128
    // let u128_big_int: Option<U128> = big_uint.try_into();

    // // u256
    // let u256_big_int: Option<u256> = big_uint.try_into();
}

fn into_example() {
    let big_uint = BigUint::zero();

    // ANCHOR: into
    // Bytes
    let bytes_big_int: Bytes = <BigUint as Into<Bytes>>::into(big_uint);
    // ANCHOR_END: into

    // Replace the above with this when https://github.com/FuelLabs/sway/issues/6858 is resolved
    // // Bytes
    // let bytes_big_int: Bytes = big_uint.into();
}

// ANCHOR: is_zero
fn is_zero() {
    let big_int = BigUint::zero();
    assert(big_int.is_zero());
}
// ANCHOR_END: is_zero

fn limbs(big_int: BigUint) {
    // ANCHOR: limbs
    let limbs: Vec<u64> = big_int.limbs();
    // ANCHOR_END: limbs
}

fn get_limb(big_int: BigUint) {
    // ANCHOR: get_limb
    let limb: Option<u64> = big_int.get_limb(0);
    // ANCHOR_END: get_limb
}

fn number_of_limbs(big_int: BigUint) {
    // ANCHOR: number_of_limbs
    let number_of_limbs: u64 = big_int.number_of_limbs();
    // ANCHOR_END: number_of_limbs
}

fn equal_limb_size(big_int_1: BigUint, big_int_2: BigUint) {
    // ANCHOR: equal_limb_size
    let result: bool = big_int_1.equal_limb_size(big_int_2);
    // ANCHOR_END: equal_limb_size
}
