script;

use sway_libs::signed_integers::i128::I128;
use std::u128::U128;
use std::convert::*;

fn main() -> bool {
    let u128_one = U128::from((0, 1));
    let u128_two = U128::from((0, 2));
    let one = I128::try_from(u128_one).unwrap();
    let mut res = one + I128::try_from(u128_one).unwrap();
    assert(res == I128::try_from(u128_two).unwrap());

    let u128_10 = U128::from((0, 10));
    let u128_11 = U128::from((0, 11));
    res = I128::try_from(u128_10).unwrap() - I128::try_from(u128_11).unwrap();
    assert(res.underlying().lower() == u64::max());

    res = I128::try_from(u128_10).unwrap() * I128::neg_try_from(u128_one).unwrap();
    assert(res == I128::neg_try_from(u128_10).unwrap());

    res = I128::try_from(u128_10).unwrap() * I128::try_from(u128_10).unwrap();
    let u128_100 = U128::from((0, 100));
    assert(res == I128::try_from(u128_100).unwrap());

    let u128_lower_max_u64 = U128::from((0, u64::max()));

    res = I128::try_from(u128_10).unwrap() / I128::try_from(u128_lower_max_u64).unwrap();
    assert(res == I128::neg_try_from(u128_10).unwrap());

    let u128_5 = U128::from((0, 5));

    let u128_2 = U128::from((0, 2));

    res = I128::try_from(u128_10).unwrap() / I128::try_from(u128_5).unwrap();
    assert(res == I128::try_from(u128_2).unwrap());

    // Subtraction tests
    let pos1 = I128::try_from(U128::from((0, 1))).unwrap();
    let pos2 = I128::try_from(U128::from((0, 2))).unwrap();
    let neg1 = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let neg2 = I128::neg_try_from(U128::from((0, 2))).unwrap();

    // Both positive:
    let res1 = pos1 - pos2;
    let res1_2 = pos2 - pos1;
    assert(res1 == I128::neg_try_from(U128::from((0, 1))).unwrap());

    let res2 = pos2 - pos1;
    assert(res2 == I128::try_from(U128::from((0, 1))).unwrap());

    // First positive
    let res3 = pos1 - neg1;
    assert(res3 == I128::try_from(U128::from((0, 2))).unwrap());

    // Second positive
    let res4 = neg1 - pos1;
    assert(res4 == I128::neg_try_from(U128::from((0, 2))).unwrap());

    // Both negative
    let res5 = neg1 - neg2;
    assert(res5 == I128::try_from(U128::from((0, 1))).unwrap());

    let res6 = neg2 - neg1;
    assert(res6 == I128::neg_try_from(U128::from((0, 1))).unwrap());

    // OrqEq Tests
    let one_1 = I128::try_from(U128::from((0, 1))).unwrap();
    let one_2 = I128::try_from(U128::from((0, 1))).unwrap();
    let neg_one_1 = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let neg_one_2 = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let max_1 = I128::MAX;
    let max_2 = I128::MAX;
    let min_1 = I128::MIN;
    let min_2 = I128::MIN;

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
    let indent = I128::indent();

    let neg_try_from_zero = I128::neg_try_from(U128::min());
    assert(neg_try_from_zero.is_some());
    assert(neg_try_from_zero.unwrap() == I128::zero());

    let neg_try_from_one = I128::neg_try_from(U128::from((0, 1)));
    assert(neg_try_from_one.is_some());
    assert(neg_try_from_one.unwrap().underlying() == I128::indent() - U128::from((0, 1)));

    let neg_try_from_max = I128::neg_try_from(indent);
    assert(neg_try_from_max.is_some());
    assert(neg_try_from_max.unwrap().underlying() == U128::min());

    let neg_try_from_overflow = I128::neg_try_from(indent + U128::from((0, 1)));
    assert(neg_try_from_overflow.is_none());

    // Test into I128
    let indent: U128 = I128::indent();

    let i128_max_try_from = I128::try_from(indent);
    assert(i128_max_try_from.is_some());
    assert(i128_max_try_from.unwrap() == I128::MAX);

    let i128_min_try_from = I128::try_from(U128::min());
    assert(i128_min_try_from.is_some());
    assert(i128_min_try_from.unwrap() == I128::zero());

    let i128_overflow_try_from = I128::try_from(indent + U128::from((0, 1)));
    assert(i128_overflow_try_from.is_none());

    let i128_max_try_into: Option<I128> = indent.try_into();
    assert(i128_max_try_into.is_some());
    assert(i128_max_try_into.unwrap() == I128::MAX);

    let i128_min_try_into: Option<I128> = U128::min().try_into();
    assert(i128_min_try_into.is_some());
    assert(i128_min_try_into.unwrap() == I128::zero());

    let i128_overflow_try_into: Option<I128> = (indent + U128::from((0, 1))).try_into();
    assert(i128_overflow_try_into.is_none());

    // Test into U128
    let zero = I128::zero();
    let negative = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let max = I128::MAX;

    let U128_max_try_from: Option<U128> = U128::try_from(max);
    assert(U128_max_try_from.is_some());
    assert(U128_max_try_from.unwrap() == indent);

    let U128_min_try_from: Option<U128> = U128::try_from(zero);
    assert(U128_min_try_from.is_some());
    assert(U128_min_try_from.unwrap() == U128::zero());

    let U128_overflow_try_from: Option<U128> = U128::try_from(negative);
    assert(U128_overflow_try_from.is_none());

    let U128_max_try_into: Option<U128> = zero.try_into();
    assert(U128_max_try_into.is_some());
    assert(U128_max_try_into.unwrap() == indent);

    let U128_min_try_into: Option<U128> = zero.try_into();
    assert(U128_min_try_into.is_some());
    assert(U128_min_try_into.unwrap() == U128::zero());

    let U128_overflow_try_into: Option<U128> = negative.try_into();
    assert(U128_overflow_try_into.is_none());

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
