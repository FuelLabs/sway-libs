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

    // Subtraction Tests
    let pos1 = I8::try_from(1).unwrap();
    let pos2 = I8::try_from(2).unwrap();
    let neg1 = I8::neg_try_from(1).unwrap();
    let neg2 = I8::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 - pos2;
    assert(res1 == I8::neg_try_from(1).unwrap());

    let res2 = pos2 - pos1;
    assert(res2 == I8::try_from(1).unwrap());

    // First positive
    let res3 = pos1 - neg1;
    assert(res3 == I8::try_from(2).unwrap());

    // Second positive
    let res4 = neg1 - pos1;
    assert(res4 == I8::neg_try_from(2).unwrap());

    // Both negative
    let res5 = neg1 - neg2;
    assert(res5 == I8::try_from(1).unwrap());

    let res6 = neg2 - neg1;
    assert(res6 == I8::neg_try_from(1).unwrap());

    // OrqEq Tests
    let one_1 = I8::try_from(1u8).unwrap();
    let one_2 = I8::try_from(1u8).unwrap();
    let neg_one_1 = I8::neg_try_from(1u8).unwrap();
    let neg_one_2 = I8::neg_try_from(1u8).unwrap();
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

    // Test neg try from
    let indent = I8::indent();

    let neg_try_from_zero = I8::neg_try_from(u8::min());
    assert(neg_try_from_zero.is_some());
    assert(neg_try_from_zero.unwrap() == I8::zero());

    let neg_try_from_one = I8::neg_try_from(1u8);
    assert(neg_try_from_one.is_some());
    assert(neg_try_from_one.unwrap().underlying() == I8::indent() - 1u8);

    let neg_try_from_max = I8::neg_try_from(indent);
    assert(neg_try_from_max.is_some());
    assert(neg_try_from_max.unwrap().underlying() == u8::min());

    let neg_try_from_overflow = I8::neg_try_from(indent + 1u8);
    assert(neg_try_from_overflow.is_none());

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
    let negative = I8::neg_try_from(1).unwrap();
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
