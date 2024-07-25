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

    true
}
