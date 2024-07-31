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

    // Subtraction Tests
    let pos1 = I8::from(1);
    let pos2 = I8::from(2);
    let neg1 = I8::neg_from(1);
    let neg2 = I8::neg_from(2);

    // Both positive:
    let res1 = pos1 - pos2;
    assert(res1 == I8::neg_from(1));

    let res2 = pos2 - pos1;
    assert(res2 == I8::from(1));

    // First positive
    let res3 = pos1 - neg1;
    assert(res3 == I8::from(2));

    // Second positive
    let res4 = neg1 - pos1;
    assert(res4 == I8::neg_from(2));

    // Both negative
    let res5 = neg1 - neg2;
    assert(res5 == I8::from(1));

    let res6 = neg2 - neg1;
    assert(res6 == I8::neg_from(1));

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

    true
}
