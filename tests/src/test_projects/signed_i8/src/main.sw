script;

use sway_libs::i8::I8;

fn main() -> bool {
    let one = I8::from(1u8);
    let mut res = one + I8::from(1u8);
    assert(res == I8::from(2u8));

    res = I8::from(10u8) - I8::from(11u8);
    assert(res == I8 { underlying: 127u8 });

    res = I8::from(10u8) * I8 { underlying: 127u8 };
    assert(res == I8 { underlying: 118u8 });

    res = I8::from(10u8) * I8::from(10u8);
    assert(res == I8::from(100u8));

    res = I8::from(10u8) / I8 { underlying: 127u8 };
    assert(res == I8 { underlying: 118u8 });

    res = I8::from(10u8) / I8::from(5u8);
    assert(res == I8::from(2u8));

    //flip test
    assert(one.flip() == I8::neg_from(1));
    //ge test
    assert(one >= one);
    assert(I8::from(2) >= one);
    assert(one >= one.flip());
    assert(one.flip() >= I8::from(2).flip());
    //le test
    assert(one <= one);
    assert(one <= I8::from(2));
    assert(one.flip() <= one);
    assert(I8::from(2).flip() <= one.flip());

    true
}
