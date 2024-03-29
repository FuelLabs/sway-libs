script;

use sway_libs::signed_integers::i8::I8;

fn main() -> bool {
    let one = I8::from(1u8);
    let mut res = one + I8::from(1u8);
    assert(res == I8::from(2u8));

    res = I8::from(10u8) - I8::from(11u8);
    assert(res == I8 {
        underlying: 127u8,
    });

    res = I8::from(10u8) * I8 {
        underlying: 127u8,
    };
    assert(res == I8 {
        underlying: 118u8,
    });

    res = I8::from(10u8) * I8::from(10u8);
    assert(res == I8::from(100u8));

    res = I8::from(10u8) / I8 {
        underlying: 127u8,
    };
    assert(res == I8 {
        underlying: 118u8,
    });

    res = I8::from(10u8) / I8::from(5u8);
    assert(res == I8::from(2u8));

    true
}
