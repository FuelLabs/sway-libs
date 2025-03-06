script;

use sway_libs::signed_integers::i32::I32;
use std::convert::*;

fn main() -> bool {
    let one = I32::try_from(1u32).unwrap();
    let mut res = one + I32::try_from(1u32).unwrap();
    assert(res == I32::try_from(2u32).unwrap());

    res = I32::try_from(10u32).unwrap() - I32::try_from(11u32).unwrap();
    assert(res == I32::try_from(2147483647u32).unwrap());

    res = I32::try_from(10u32).unwrap() * I32::try_from(1u32).unwrap();
    assert(res == I32::neg_try_from(10u32).unwrap());

    res = I32::try_from(10u32).unwrap() * I32::try_from(10u32).unwrap();
    assert(res == I32::try_from(100u32).unwrap());

    res = I32::try_from(10u32).unwrap() / I32::neg_try_from(1u32).unwrap();
    assert(res == I32::neg_try_from(10u32).unwrap());

    res = I32::try_from(10u32).unwrap() / I32::try_from(5u32).unwrap();
    assert(res == I32::try_from(2u32).unwrap());

    // Subtraction Tests
    let pos1 = I32::try_from(1).unwrap();
    let pos2 = I32::try_from(2).unwrap();
    let neg1 = I32::neg_try_from(1).unwrap();
    let neg2 = I32::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 - pos2;
    let res1_2 = pos2 - pos1;
    assert(res1 == I32::neg_try_from(1).unwrap());

    let res2 = pos2 - pos1;
    assert(res2 == I32::try_from(1).unwrap());

    // First positive
    let res3 = pos1 - neg1;
    assert(res3 == I32::try_from(2).unwrap());

    // Second positive
    let res4 = neg1 - pos1;
    assert(res4 == I32::neg_try_from(2).unwrap());

    // Both negative
    let res5 = neg1 - neg2;
    assert(res5 == I32::try_from(1).unwrap());

    let res6 = neg2 - neg1;
    assert(res6 == I32::neg_try_from(1).unwrap());

    // OrqEq Tests
    let one_1 = I32::try_from(1u32).unwrap();
    let one_2 = I32::try_from(1u32).unwrap();
    let neg_one_1 = I32::neg_try_from(1u32).unwrap();
    let neg_one_2 = I32::neg_try_from(1u32).unwrap();
    let max_1 = I32::MAX;
    let max_2 = I32::MAX;
    let min_1 = I32::MIN;
    let min_2 = I32::MIN;

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
    let indent = I32::indent();

    let neg_try_from_zero = I32::neg_try_from(u32::min());
    assert(neg_try_from_zero.is_some());
    assert(neg_try_from_zero.unwrap() == I32::zero());

    let neg_try_from_one = I32::neg_try_from(1u32);
    assert(neg_try_from_one.is_some());
    assert(neg_try_from_one.unwrap().underlying() == I32::indent() - 1u32);

    let neg_try_from_max = I32::neg_try_from(indent);
    assert(neg_try_from_max.is_some());
    assert(neg_try_from_max.unwrap().underlying() == u32::min());

    let neg_try_from_overflow = I32::neg_try_from(indent + 1u32);
    assert(neg_try_from_overflow.is_none());

    // Test into I32
    let indent: u32 = I32::indent();

    let i32_max_try_from = I32::try_from(indent);
    assert(i32_max_try_from.is_some());
    assert(i32_max_try_from.unwrap() == I32::MAX);

    let i32_min_try_from = I32::try_from(u32::min());
    assert(i32_min_try_from.is_some());
    assert(i32_min_try_from.unwrap() == I32::zero());

    let i32_overflow_try_from = I32::try_from(indent + 1);
    assert(i32_overflow_try_from.is_none());

    let i32_max_try_into: Option<I32> = indent.try_into();
    assert(i32_max_try_into.is_some());
    assert(i32_max_try_into.unwrap() == I32::MAX);

    let i32_min_try_into: Option<I32> = u32::min().try_into();
    assert(i32_min_try_into.is_some());
    assert(i32_min_try_into.unwrap() == I32::zero());

    let i32_overflow_try_into: Option<I32> = (indent + 1).try_into();
    assert(i32_overflow_try_into.is_none());

    // Test into u32
    let zero = I32::zero();
    let negative = I32::neg_try_from(1).unwrap();
    let max = I32::MAX;

    let u32_max_try_from: Option<u32> = u32::try_from(max);
    assert(u32_max_try_from.is_some());
    assert(u32_max_try_from.unwrap() == indent);

    let u32_min_try_from: Option<u32> = u32::try_from(zero);
    assert(u32_min_try_from.is_some());
    assert(u32_min_try_from.unwrap() == u32::zero());

    let u32_overflow_try_from: Option<u32> = u32::try_from(negative);
    assert(u32_overflow_try_from.is_none());

    let u32_max_try_into: Option<u32> = zero.try_into();
    assert(u32_max_try_into.is_some());
    assert(u32_max_try_into.unwrap() == indent);

    let u32_min_try_into: Option<u32> = zero.try_into();
    assert(u32_min_try_into.is_some());
    assert(u32_min_try_into.unwrap() == u32::zero());

    let u32_overflow_try_into: Option<u32> = negative.try_into();
    assert(u32_overflow_try_into.is_none());

    // TotalOrd tests
    assert(zero.min(one) == zero);
    assert(zero.max(one) == one);
    assert(one.min(zero) == zero);
    assert(one.max(zero) == one);

    assert(max_1.min(one) == one);
    assert(max_1.max(one) == max_1);
    assert(one.min(max_1) == one);
    assert(one.max(max_1) == max_1);

    assert(min_1.min(one) == min_1);
    assert(min_1.max(one) == one);
    assert(one.min(min_1) == min_1);
    assert(one.max(min_1) == one);

    assert(max_1.min(min_1) == min_1);
    assert(max_1.max(min_1) == max_1);
    assert(min_1.min(max_1) == min_1);
    assert(min_1.max(max_1) == max_1);

    assert(neg_one_1.min(one) == neg_one_1);
    assert(neg_one_1.max(one) == one);
    assert(one.min(neg_one_1) == neg_one_1);

    true
}
