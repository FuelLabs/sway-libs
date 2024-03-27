script;

use libraries::signed_integers::i32::I32;

fn main() -> bool {
    let one = I32::from(1u32);
    let mut res = one + I32::from(1u32);
    assert(res.twos_complement() == I32::from(2u32));

    res = I32::from(10u32);
    assert(res.twos_complement() == I32::from(10u32));

    res = I32::neg_from(5);
    assert(res.twos_complement().underlying + res.underlying == u32::max() + 1);

    res = I32::neg_from(27u32);
    assert(res.twos_complement().underlying + res.underlying == u32::max() + 1);

    res = I32::neg_from(110u32);
    assert(res.twos_complement().underlying + res.underlying == u32::max() + 1);

    res = I32::neg_from(93u32);
    assert(res.twos_complement().underlying + res.underlying == u32::max() + 1);

    res = I32::neg_from(78u32);
    assert(res.twos_complement().underlying + res.underlying == u32::max() + 1);

    true
}
