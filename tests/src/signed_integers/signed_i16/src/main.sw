script;

use sway_libs::signed_integers::i16::I16;

fn main() -> bool {
    let one = I16::from(1u16);
    let mut res = one + I16::from(1u16);
    assert(res == I16::from(2u16));

    res = I16::from(10u16) - I16::from(11u16);
    assert(res == I16::from(32767u16));

    res = I16::from(10u16) * I16::neg_from(1u16);
    assert(res == I16::neg_from(10u16));

    res = I16::from(10u16) * I16::from(10u16);
    assert(res == I16::from(100u16));

    res = I16::from(10u16) / I16::neg_from(1u16);
    assert(res == I16::neg_from(10u16));

    res = I16::from(10u16) / I16::from(5u16);
    assert(res == I16::from(2u16));

    // OrqEq Tests
    let one_1 = I16::from(1u16);
    let one_2 = I16::from(1u16);
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

    true
}
