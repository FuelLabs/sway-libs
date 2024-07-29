script;

use sway_libs::signed_integers::i64::I64;
use std::convert::*;

fn main() -> bool {
    let one = I64::try_from(1u64).unwrap();
    let mut res = one + I64::try_from(1u64).unwrap();
    assert(res == I64::try_from(2u64).unwrap());

    res = I64::try_from(10u64).unwrap() - I64::try_from(11u64).unwrap();
    assert(res == I64::try_from(9223372036854775807u64).unwrap());
    res = I64::try_from(10u64).unwrap() * I64::neg_from(1);
    assert(res == I64::neg_from(10));

    res = I64::try_from(10u64).unwrap() * I64::try_from(10u64).unwrap();
    assert(res == I64::try_from(100u64).unwrap());

    res = I64::try_from(10u64).unwrap() / I64::try_from(9223372036854775807u64).unwrap();
    assert(res == I64::neg_from(10u64));

    res = I64::try_from(10u64).unwrap() / I64::try_from(5u64).unwrap();
    assert(res == I64::try_from(2u64).unwrap());

    // OrqEq Tests
    let one_1 = I64::try_from(1u64).unwrap();
    let one_2 = I64::try_from(1u64).unwrap();
    let neg_one_1 = I64::neg_from(1u64);
    let neg_one_2 = I64::neg_from(1u64);
    let max_1 = I64::max();
    let max_2 = I64::max();
    let min_1 = I64::min();
    let min_2 = I64::min();

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

    // Test into I64
    let indent: u64 = I64::indent();

    let i64_max_try_from = I64::try_from(indent);
    assert(i64_max_try_from.is_some());
    assert(i64_max_try_from.unwrap() == I64::max());

    let i64_min_try_from = I64::try_from(u64::min());
    assert(i64_min_try_from.is_some());
    assert(i64_min_try_from.unwrap() == I64::zero());

    let i64_overflow_try_from = I64::try_from(indent + 1);
    assert(i64_overflow_try_from.is_none());

    let i64_max_try_into: Option<I64> = indent.try_into();
    assert(i64_max_try_into.is_some());
    assert(i64_max_try_into.unwrap() == I64::max());

    let i64_min_try_into: Option<I64> = u64::min().try_into();
    assert(i64_min_try_into.is_some());
    assert(i64_min_try_into.unwrap() == I64::zero());

    let i64_overflow_try_into: Option<I64> = (indent + 1).try_into();
    assert(i64_overflow_try_into.is_none());

    // Test into u64
    let zero = I64::zero();
    let negative = I64::neg_from(1);
    let max = I64::max();

    let u64_max_try_from: Option<u64> = u64::try_from(max);
    assert(u64_max_try_from.is_some());
    assert(u64_max_try_from.unwrap() == indent);

    let u64_min_try_from: Option<u64> = u64::try_from(zero);
    assert(u64_min_try_from.is_some());
    assert(u64_min_try_from.unwrap() == u64::zero());

    let u64_overflow_try_from: Option<u64> = u64::try_from(negative);
    assert(u64_overflow_try_from.is_none());

    let u64_max_try_into: Option<u64> = zero.try_into();
    assert(u64_max_try_into.is_some());
    assert(u64_max_try_into.unwrap() == indent);

    let u64_min_try_into: Option<u64> = zero.try_into();
    assert(u64_min_try_into.is_some());
    assert(u64_min_try_into.unwrap() == u64::zero());

    let u64_overflow_try_into: Option<u64> = negative.try_into();
    assert(u64_overflow_try_into.is_none());

    true
}
