script;

use sway_libs::signed_integers::i16::I16;

fn main() -> bool {
    let one = I16::from(1u16);
    let mut res = one + I16::from(1u16);
    assert(res.twos_complement() == I16::from(2u16));

    res = I16::from(10u16);
    assert(res.twos_complement() == I16::from(10u16));

    res = I16::neg_from(5);
    assert(res.twos_complement().underlying + res.underlying == u16::max() + 1);

    res = I16::neg_from(27u16);
    assert(res.twos_complement().underlying + res.underlying == u16::max() + 1);

    res = I16::neg_from(110u16);
    assert(res.twos_complement().underlying + res.underlying == u16::max() + 1);

    res = I16::neg_from(93u16);
    assert(res.twos_complement().underlying + res.underlying == u16::max() + 1);

    res = I16::neg_from(78u16);
    assert(res.twos_complement().underlying + res.underlying == u16::max() + 1);

    true
}
