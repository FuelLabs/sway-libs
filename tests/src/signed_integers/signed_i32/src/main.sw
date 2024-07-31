script;

use sway_libs::signed_integers::i32::I32;

fn main() -> bool {
    let one = I32::from(1u32);
    let mut res = one + I32::from(1u32);
    assert(res == I32::from(2u32));

    res = I32::from(10u32) - I32::from(11u32);
    assert(res == I32::from(2147483647u32));

    res = I32::from(10u32) * I32::from(1u32);
    assert(res == I32::neg_try_from(10u32).unwrap());

    res = I32::from(10u32) * I32::from(10u32);
    assert(res == I32::from(100u32));

    res = I32::from(10u32) / I32::neg_try_from(1u32).unwrap();
    assert(res == I32::neg_try_from(10u32).unwrap());

    res = I32::from(10u32) / I32::from(5u32);
    assert(res == I32::from(2u32));

    // Subtraction Tests
    let pos1 = I32::from(1);
    let pos2 = I32::from(2);
    let neg1 = I32::neg_from(1);
    let neg2 = I32::neg_from(2);

    // Both positive:
    let res1 = pos1 - pos2;
    let res1_2 = pos2 - pos1;
    assert(res1 == I32::neg_from(1));

    let res2 = pos2 - pos1;
    assert(res2 == I32::from(1));

    // First positive
    let res3 = pos1 - neg1;
    assert(res3 == I32::from(2));

    // Second positive
    let res4 = neg1 - pos1;
    assert(res4 == I32::neg_from(2));

    // Both negative
    let res5 = neg1 - neg2;
    assert(res5 == I32::from(1));

    let res6 = neg2 - neg1;
    assert(res6 == I32::neg_from(1));

    // OrqEq Tests
    let one_1 = I32::from(1u32);
    let one_2 = I32::from(1u32);
    let neg_one_1 = I32::neg_try_from(1u32).unwrap();
    let neg_one_2 = I32::neg_try_from(1u32).unwrap();
    let max_1 = I32::max();
    let max_2 = I32::max();
    let min_1 = I32::min();
    let min_2 = I32::min();

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

    true
}
