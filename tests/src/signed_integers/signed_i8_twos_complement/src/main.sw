script;

use sway_libs::signed_integers::i8::I8;

fn main() -> bool {
    let one = I8::from(1u8);
    let mut res = one + I8::from(1u8);
    assert(res.twos_complement() == I8::from(2u8));

    res = I8::from(10u8);
    assert(res.twos_complement() == I8::from(10u8));

    res = I8::neg_from(5);
    assert(res.twos_complement().underlying() + res.underlying() == u8::max() + 1);

    res = I8::neg_from(27u8);
    assert(res.twos_complement().underlying() + res.underlying() == u8::max() + 1);

    res = I8::neg_from(110u8);
    assert(res.twos_complement().underlying() + res.underlying() == u8::max() + 1);

    res = I8::neg_from(93u8);
    assert(res.twos_complement().underlying() + res.underlying() == u8::max() + 1);

    res = I8::neg_from(78u8);
    assert(res.twos_complement().underlying() + res.underlying() == u8::max() + 1);

    true
}
