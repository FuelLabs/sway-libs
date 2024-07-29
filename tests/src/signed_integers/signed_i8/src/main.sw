script;

use sway_libs::signed_integers::i8::I8;
use std::convert::*;

fn main() -> bool {
    let one = I8::try_from(1u8).unwrap();
    let mut res = one + I8::try_from(1u8).unwrap();
    assert(res == I8::try_from(2u8).unwrap());

    res = I8::try_from(10u8).unwrap() - I8::try_from(11u8).unwrap();
    assert(res == I8::try_from(127u8).unwrap());

    res = I8::try_from(10u8).unwrap() * I8::try_from(127u8).unwrap();
    assert(res == I8::try_from(118u8).unwrap());

    res = I8::try_from(10u8).unwrap() * I8::try_from(10u8).unwrap();
    assert(res == I8::try_from(100u8).unwrap());

    res = I8::try_from(10u8).unwrap() / I8::try_from(127u8).unwrap();
    assert(res == I8::try_from(118u8).unwrap());

    res = I8::try_from(10u8).unwrap() / I8::try_from(5u8).unwrap();
    assert(res == I8::try_from(2u8).unwrap());

    // OrqEq Tests
    let one_1 = I8::try_from(1u8).unwrap();
    let one_2 = I8::try_from(1u8).unwrap();
    let neg_one_1 = I8::neg_from(1u8);
    let neg_one_2 = I8::neg_from(1u8);
    let max_1 = I8::max();
    let max_2 = I8::max();
    let min_1 = I8::min();
    let min_2 = I8::min();

    assert(one_1 >= one_2);
    assert(one_1 <= one_2);
    assert(neg_one_1 >= neg_one_2);
    assert(neg_one_1 <= neg_one_2);
    assert(max_1 >= max_1);
    assert(max_1 <= max_1);
    assert(min_1 >= min_1);
    assert(min_1 <= min_1);

    assert(min_1 <= one_1);
    assert(min_1 <= neg_one_1);
    assert(min_1 <= max_1);
    assert(neg_one_1 <= max_1);
    assert(neg_one_1 <= one_1);
    assert(one_1 <= max_1);

    assert(max_1 >= one_1);
    assert(max_1 >= neg_one_1);
    assert(max_1 >= min_1);
    assert(one_1 >= neg_one_1);
    assert(one_1 >= min_1);
    assert(neg_one_1 >= min_1);

    // Test into I8
    let indent: u8 = I8::indent();

    let i8_max_try_from = I8::try_from(indent);
    assert(i8_max_try_from.is_some());
    assert(i8_max_try_from.unwrap() == I8::max());

    let i8_min_try_from = I8::try_from(u8::min());
    assert(i8_min_try_from.is_some());
    assert(i8_min_try_from.unwrap() == I8::zero());

    let i8_overflow_try_from = I8::try_from(indent + 1);
    assert(i8_overflow_try_from.is_none());

    let i8_max_try_into: Option<I8> = indent.try_into();
    assert(i8_max_try_into.is_some());
    assert(i8_max_try_into.unwrap() == I8::max());

    let i8_min_try_into: Option<I8> = u8::min().try_into();
    assert(i8_min_try_into.is_some());
    assert(i8_min_try_into.unwrap() == I8::zero());

    let i8_overflow_try_into: Option<I8> = (indent + 1).try_into();
    assert(i8_overflow_try_into.is_none());

    // Test into u8
    let zero = I8::zero();
    let negative = I8::neg_from(1);
    let max = I8::max();

    let u8_max_try_from: Option<u8> = u8::try_from(max);
    assert(u8_max_try_from.is_some());
    assert(u8_max_try_from.unwrap() == indent);

    let u8_min_try_from: Option<u8> = u8::try_from(zero);
    assert(u8_min_try_from.is_some());
    assert(u8_min_try_from.unwrap() == u8::zero());

    let u8_overflow_try_from: Option<u8> = u8::try_from(negative);
    assert(u8_overflow_try_from.is_none());

    let u8_max_try_into: Option<u8> = zero.try_into();
    assert(u8_max_try_into.is_some());
    assert(u8_max_try_into.unwrap() == indent);

    let u8_min_try_into: Option<u8> = zero.try_into();
    assert(u8_min_try_into.is_some());
    assert(u8_min_try_into.unwrap() == u8::zero());

    let u8_overflow_try_into: Option<u8> = negative.try_into();
    assert(u8_overflow_try_into.is_none());

    true
}
