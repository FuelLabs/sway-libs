script;

use sway_libs::signed_integers::i16::I16;

fn main() -> bool {
    let one = I16::from(1u16);
    let mut res = one + I16::from(1u16);
    assert(res == I16::from(2u16));

    res = I16::from(10u16) - I16::from(11u16);
    assert(res == I16::from(32767u16));

    res = I16::from(10u16) * I16::neg_try_from(1u16).unwrap();
    assert(res == I16::neg_try_from(10u16).unwrap());

    res = I16::from(10u16) * I16::from(10u16);
    assert(res == I16::from(100u16));

    res = I16::from(10u16) / I16::neg_try_from(1u16).unwrap();
    assert(res == I16::neg_try_from(10u16).unwrap());

    res = I16::from(10u16) / I16::from(5u16);
    assert(res == I16::from(2u16));

    // Subtraction tests
    let pos1 = I16::from(1);
    let pos2 = I16::from(2);
    let neg1 = I16::neg_from(1);
    let neg2 = I16::neg_from(2);

    // Both positive:
    let res1 = pos1 - pos2;
    let res1_2 = pos2 - pos1;
    assert(res1 == I16::neg_from(1));

    let res2 = pos2 - pos1;
    assert(res2 == I16::from(1));

    // First positive
    let res3 = pos1 - neg1;
    assert(res3 == I16::from(2));

    // Second positive
    let res4 = neg1 - pos1;
    assert(res4 == I16::neg_from(2));

    // Both negative
    let res5 = neg1 - neg2;
    assert(res5 == I16::from(1));

    let res6 = neg2 - neg1;
    assert(res6 == I16::neg_from(1));

    // OrqEq Tests
    let one_1 = I16::from(1u16);
    let one_2 = I16::from(1u16);
    let neg_one_1 = I16::neg_try_from(1u16).unwrap();
    let neg_one_2 = I16::neg_try_from(1u16).unwrap();
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

    // Test neg try from
    let indent = I16::indent();

    let neg_try_from_zero = I16::neg_try_from(u16::min());
    assert(neg_try_from_zero.is_some());
    assert(neg_try_from_zero.unwrap() == I16::zero());

    let neg_try_from_one = I16::neg_try_from(1u16);
    assert(neg_try_from_one.is_some());
    assert(neg_try_from_one.unwrap().underlying() == I16::indent() - 1u16);

    let neg_try_from_max = I16::neg_try_from(indent);
    assert(neg_try_from_max.is_some());
    assert(neg_try_from_max.unwrap().underlying() == u16::min());

    let neg_try_from_overflow = I16::neg_try_from(indent + 1u16);
    assert(neg_try_from_overflow.is_none());

    true
}
