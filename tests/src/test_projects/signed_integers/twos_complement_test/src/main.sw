script;

use std::assert::assert;
use sway_libs::i8::I8;
use std::i16::I16;
use sway_libs::i32::I32;
use sway_libs::i64::I64;
use sway_libs::i128::I128;
use std::u128::U128;
use sway_libs::i256::I256;
use std::u256::U256;
use core::num::*;

fn main() -> bool {
    let one_i8 = ~I8::from_uint(1u8);
    let mut res_i8 = one.twos_complement();
    assert(res_i8 == ~I8::from_uint(2u8));

    let one = ~I16::from_uint(1u16);
    let mut res_i16 = one.twos_complement();
    assert(res_i16 == ~I16::from_uint(2u16));

    let one = ~I32::from_uint(1u32);
    let mut res_i32 = one.twos_complement();
    assert(res_i32 == ~I32::from_uint(2u32));

    let one = ~I64::from_uint(1u64);
    let mut res_i64 = one.twos_complement();
    assert(res_i64 == ~I64::from_uint(2u64));

    let u128_one = U128 {
        upper: 0,
        lower: 1,
    };
    let u128_two = U128 {
        upper: 0,
        lower: 2,
    };
    let one = ~I128::from_uint(u128_one);
    let mut res_i128 = one.twos_complement();
    assert(res_i128 == ~I128::from_uint(u128_two));

    let u256_one = U256 {
        a: 0,
        b: 0,
        c: 0,
        d: 1,
    };
    let u256_two = U256 {
        a: 0,
        b: 0,
        c: 0,
        d: 2,
    };
    let one = ~I256::from_uint(u128_one);
    let mut res_i256 = one.twos_complement();
    assert(res_i256 == ~I256::from_uint(u128_two));

    true
}
