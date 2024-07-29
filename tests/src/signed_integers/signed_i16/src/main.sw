script;

use sway_libs::signed_integers::i16::I16;
use std::convert::*;

fn main() -> bool {
    let one = I16::try_from(1u16).unwrap();
    let mut res = one + I16::try_from(1u16).unwrap();
    assert(res == I16::try_from(2u16).unwrap());

    res = I16::try_from(10u16).unwrap() - I16::try_from(11u16).unwrap();
    assert(res == I16::try_from(32767u16).unwrap());

    res = I16::try_from(10u16).unwrap() * I16::neg_from(1u16);
    assert(res == I16::neg_from(10u16));

    res = I16::try_from(10u16).unwrap() * I16::try_from(10u16).unwrap();
    assert(res == I16::try_from(100u16).unwrap());

    res = I16::try_from(10u16).unwrap() / I16::neg_from(1u16);
    assert(res == I16::neg_from(10u16));

    res = I16::try_from(10u16).unwrap() / I16::try_from(5u16).unwrap();
    assert(res == I16::try_from(2u16).unwrap());

    // OrqEq Tests
    let one_1 = I16::try_from(1u16).unwrap();
    let one_2 = I16::try_from(1u16).unwrap();
    let neg_one_1 = I16::neg_from(1u16);
    let neg_one_2 = I16::neg_from(1u16);
    let max_1 = I16::max();
    let max_2 = I16::max();
    let min_1 = I16::min();
    let min_2 = I16::min();

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

    // Test into I16
    let indent: u16 = I16::indent();

    let i16_max_try_from = I16::try_from(indent);
    assert(i16_max_try_from.is_some());
    assert(i16_max_try_from.unwrap() == I16::max());

    let i16_min_try_from = I16::try_from(u16::min());
    assert(i16_min_try_from.is_some());
    assert(i16_min_try_from.unwrap() == I16::zero());

    let i16_overflow_try_from = I16::try_from(indent + 1);
    assert(i16_overflow_try_from.is_none());

    let i16_max_try_into: Option<I16> = indent.try_into();
    assert(i16_max_try_into.is_some());
    assert(i16_max_try_into.unwrap() == I16::max());

    let i16_min_try_into: Option<I16> = u16::min().try_into();
    assert(i16_min_try_into.is_some());
    assert(i16_min_try_into.unwrap() == I16::zero());

    let i16_overflow_try_into: Option<I16> = (indent + 1).try_into();
    assert(i16_overflow_try_into.is_none());

    // Test into u16
    let zero = I16::zero();
    let negative = I16::neg_from(1);
    let max = I16::max();

    let u16_max_try_from: Option<u16> = u16::try_from(max);
    assert(u16_max_try_from.is_some());
    assert(u16_max_try_from.unwrap() == indent);

    let u16_min_try_from: Option<u16> = u16::try_from(zero);
    assert(u16_min_try_from.is_some());
    assert(u16_min_try_from.unwrap() == u16::zero());

    let u16_overflow_try_from: Option<u16> = u16::try_from(negative);
    assert(u16_overflow_try_from.is_none());

    let u16_max_try_into: Option<u16> = zero.try_into();
    assert(u16_max_try_into.is_some());
    assert(u16_max_try_into.unwrap() == indent);

    let u16_min_try_into: Option<u16> = zero.try_into();
    assert(u16_min_try_into.is_some());
    assert(u16_min_try_into.unwrap() == u16::zero());

    let u16_overflow_try_into: Option<u16> = negative.try_into();
    assert(u16_overflow_try_into.is_none());

    true
}
