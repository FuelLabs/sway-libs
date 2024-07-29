script;

use sway_libs::signed_integers::i32::I32;

fn main() -> bool {
    let one = I32::from(1u32);
    let mut res = one + I32::from(1u32);
    assert(res == I32::from(2u32));

    res = I32::from(10u32) - I32::from(11u32);
    assert(res == I32::from(2147483647u32));

    res = I32::from(10u32) * I32::from(1u32);
    assert(res == I32::neg_from(10u32));

    res = I32::from(10u32) * I32::from(10u32);
    assert(res == I32::from(100u32));

    res = I32::from(10u32) / I32::neg_from(1u32);
    assert(res == I32::neg_from(10u32));

    res = I32::from(10u32) / I32::from(5u32);
    assert(res == I32::from(2u32));

    // OrqEq Tests
    let one_1 = I32::from(1u32);
    let one_2 = I32::from(1u32);
    let neg_one_1 = I32::neg_from(1u32);
    let neg_one_2 = I32::neg_from(1u32);
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

    true
}
