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

    res = I128::try_from(u128_10).unwrap() * I128::neg_from(u128_one);
    assert(res == I128::neg_from(u128_10));

    res = I128::try_from(u128_10).unwrap() * I128::try_from(u128_10).unwrap();
    let u128_100 = U128::from((0, 100));
    assert(res == I128::try_from(u128_100).unwrap());

    let u128_lower_max_u64 = U128::from((0, u64::max()));

    res = I128::try_from(u128_10).unwrap() / I128::try_from(u128_lower_max_u64).unwrap();
    assert(res == I128::neg_from(u128_10));

    let u128_5 = U128::from((0, 5));

    let u128_2 = U128::from((0, 2));

    res = I128::try_from(u128_10).unwrap() / I128::try_from(u128_5).unwrap();
    assert(res == I128::try_from(u128_2).unwrap());

    // OrqEq Tests
    let one_1 = I128::try_from(U128::from((0, 1))).unwrap();
    let one_2 = I128::try_from(U128::from((0, 1))).unwrap();
    let neg_one_1 = I128::neg_from(U128::from((0, 1)));
    let neg_one_2 = I128::neg_from(U128::from((0, 1)));
    let max_1 = I128::max();
    let max_2 = I128::max();
    let min_1 = I128::min();
    let min_2 = I128::min();

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

    // Test into I128
    let indent: U128 = I128::indent();

    let i128_max_try_from = I128::try_from(indent);
    assert(i128_max_try_from.is_some());
    assert(i128_max_try_from.unwrap() == I128::max());

    let i128_min_try_from = I128::try_from(U128::min());
    assert(i128_min_try_from.is_some());
    assert(i128_min_try_from.unwrap() == I128::zero());

    let i128_overflow_try_from = I128::try_from(indent + U128::from((0, 1)));
    assert(i128_overflow_try_from.is_none());

    let i128_max_try_into: Option<I128> = indent.try_into();
    assert(i128_max_try_into.is_some());
    assert(i128_max_try_into.unwrap() == I128::max());

    let i128_min_try_into: Option<I128> = U128::min().try_into();
    assert(i128_min_try_into.is_some());
    assert(i128_min_try_into.unwrap() == I128::zero());

    let i128_overflow_try_into: Option<I128> = (indent + U128::from((0, 1))).try_into();
    assert(i128_overflow_try_into.is_none());

    // Test into U128
    let zero = I128::zero();
    let negative = I128::neg_from(U128::from((0, 1)));
    let max = I128::max();

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

    true
}
