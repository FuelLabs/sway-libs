script;

use sway_libs::i32::I32;

fn main() -> bool {
    let one = I32::from_uint(1u32);
    let mut res = one + I32::from_uint(1u32);
    assert(res == I32::from_uint(2u32));

    res = I32::from_uint(10u32) - I32::from_uint(11u32);
    assert(res == I32::from(2147483647u32));

    res = I32::from_uint(10u32) * I32::neg_from(1u32);
    assert(res == I32::neg_from(10u32));

    res = I32::from_uint(10u32) * I32::from_uint(10u32);
    assert(res == I32::from_uint(100u32));

    res = I32::from_uint(10u32) / I32::neg_from(1u32);
    assert(res == I32::neg_from(10u32));

    res = I32::from_uint(10u32) / I32::from_uint(5u32);
    assert(res == I32::from_uint(2u32));

    //flip test
    assert(one.flip() == I32::neg_from(1));
    //ge test
    assert(one >= one);
    assert(I32::from(2) >= one);
    assert(one >= one.flip());
    assert(one.flip() >= I32::from(2).flip());
    //le test
    assert(one <= one);
    assert(one <= I32::from(2));
    assert(one.flip() <= one);
    assert(I32::from(2).flip() <= one.flip());

    true
}
