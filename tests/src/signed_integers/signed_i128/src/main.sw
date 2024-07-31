script;

use sway_libs::signed_integers::i128::I128;
use std::u128::U128;

fn main() -> bool {
    let u128_one = U128::from((0, 1));
    let u128_two = U128::from((0, 2));
    let one = I128::from(u128_one);
    let mut res = one + I128::from(u128_one);
    assert(res == I128::from(u128_two));

    let u128_10 = U128::from((0, 10));
    let u128_11 = U128::from((0, 11));
    res = I128::from(u128_10) - I128::from(u128_11);
    assert(res.underlying().lower() == u64::max());

    res = I128::from(u128_10) * I128::neg_try_from(u128_one).unwrap();
    assert(res == I128::neg_try_from(u128_10).unwrap());

    res = I128::from(u128_10) * I128::from(u128_10);
    let u128_100 = U128::from((0, 100));
    assert(res == I128::from(u128_100));

    let u128_lower_max_u64 = U128::from((0, u64::max()));

    res = I128::from(u128_10) / I128::from(u128_lower_max_u64);
    assert(res == I128::neg_try_from(u128_10).unwrap());

    let u128_5 = U128::from((0, 5));

    let u128_2 = U128::from((0, 2));

    res = I128::from(u128_10) / I128::from(u128_5);
    assert(res == I128::from(u128_2));

    // Subtraction tests
    let pos1 = I128::from(U128::from((0, 1)));
    let pos2 = I128::from(U128::from((0, 2)));
    let neg1 = I128::neg_from(U128::from((0, 1)));
    let neg2 = I128::neg_from(U128::from((0, 2)));

    // Both positive:
    let res1 = pos1 - pos2;
    let res1_2 = pos2 - pos1;
    assert(res1 == I128::neg_from(U128::from((0, 1))));

    let res2 = pos2 - pos1;
    assert(res2 == I128::from(U128::from((0, 1))));

    // First positive
    let res3 = pos1 - neg1;
    assert(res3 == I128::from(U128::from((0, 2))));

    // Second positive
    let res4 = neg1 - pos1;
    assert(res4 == I128::neg_from(U128::from((0, 2))));

    // Both negative
    let res5 = neg1 - neg2;
    assert(res5 == I128::from(U128::from((0, 1))));

    let res6 = neg2 - neg1;
    assert(res6 == I128::neg_from(U128::from((0, 1))));

    // OrqEq Tests
    let one_1 = I128::from(U128::from((0, 1)));
    let one_2 = I128::from(U128::from((0, 1)));
    let neg_one_1 = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let neg_one_2 = I128::neg_try_from(U128::from((0, 1))).unwrap();
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

    true
}
