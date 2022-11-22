script;

use sway_libs::i16::I16;

fn main() -> bool {
    let one = I16::from(1u16);
    let mut res = one + I16::from(1u16);
    assert(res == I16::from(2u16));

    res = I16::from(10u16) - I16::from(11u16);
    assert(res == I16::from_uint(32767u16));

    res = I16::from(10u16) * I16::neg_from(1u16);
    assert(res == I16::neg_from(10u16));

    res = I16::from(10u16) * I16::from(10u16);
    assert(res == I16::from(100u16));

    res = I16::from(10u16) / I16::neg_from(1u16);
    assert(res == I16::neg_from(10u16));

    res = I16::from(10u16) / I16::from(5u16);
    assert(res == I16::from(2u16));

    true
}
