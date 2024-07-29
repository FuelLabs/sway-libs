script;

use sway_libs::signed_integers::i64::I64;

fn main() -> bool {
    let one = I64::from(1u64);
    let mut res = one + I64::from(1u64);
    assert(res == I64::from(2u64));

    res = I64::from(10u64) - I64::from(11u64);
    assert(res == I64::from(9223372036854775807u64));
    res = I64::from(10u64) * I64::neg_try_from(1).unwrap();
    assert(res == I64::neg_try_from(10).unwrap());

    res = I64::from(10u64) * I64::from(10u64);
    assert(res == I64::from(100u64));

    res = I64::from(10u64) / I64::from(9223372036854775807u64);
    assert(res == I64::neg_try_from(10u64).unwrap());

    res = I64::from(10u64) / I64::from(5u64);
    assert(res == I64::from(2u64));

    // OrqEq Tests
    let one_1 = I64::from(1u64);
    let one_2 = I64::from(1u64);
    let neg_one_1 = I64::neg_try_from(1u64).unwrap();
    let neg_one_2 = I64::neg_try_from(1u64).unwrap();
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

    // Test neg try from
    let neg_try_from_zero = I64::neg_try_from(u64::min());
    assert(neg_try_from_zero.is_some());
    assert(neg_try_from_zero.unwrap() == I64::zero());

    let neg_try_from_one = I64::neg_try_from(1u64);
    assert(neg_try_from_one.is_some());
    assert(neg_try_from_one.unwrap().underlying() == I64::indent() - 1u64);

    let neg_try_from_max = I64::neg_try_from(indent);
    assert(neg_try_from_max.is_some());
    assert(neg_try_from_max.unwrap().underlying() == u64::min());

    let neg_try_from_overflow = I64::neg_try_from(indent + 1u64);
    assert(neg_try_from_overflow.is_none());

    true
}
