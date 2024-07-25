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

    true
}
