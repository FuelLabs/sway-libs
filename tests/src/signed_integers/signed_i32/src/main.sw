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

    true
}
