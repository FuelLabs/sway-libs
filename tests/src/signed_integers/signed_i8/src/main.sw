script;

use sway_libs::signed_integers::i8::I8;

fn main() -> bool {
    let one = I8::from(1u8);
    let mut res = one + I8::from(1u8);
    assert(res == I8::from(2u8));

    res = I8::from(10u8) - I8::from(11u8);
    assert(res == I8::from(127u8));

    res = I8::from(10u8) * I8::from(127u8);
    assert(res == I8::from(118u8));

    res = I8::from(10u8) * I8::from(10u8);
    assert(res == I8::from(100u8));

    res = I8::from(10u8) / I8::from(127u8);
    assert(res == I8::from(118u8));

    res = I8::from(10u8) / I8::from(5u8);
    assert(res == I8::from(2u8));

    // OrqEq Tests
    let one_1 = I8::from(1u8);
    let one_2 = I8::from(1u8);
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

    true
}
