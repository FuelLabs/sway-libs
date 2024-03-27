script;

use libraries::signed_integers::i64::I64;

fn main() -> bool {
    let one = I64::from(1);
    let mut res = one + I64::from(1);
    assert(res.twos_complement() == I64::from(2));

    res = I64::from(10);
    assert(res.twos_complement() == I64::from(10));

    res = I64::neg_from(5);
    assert(res.twos_complement().underlying + res.underlying == u64::max() + 1);

    res = I64::neg_from(27);
    assert(res.twos_complement().underlying + res.underlying == u64::max() + 1);

    res = I64::neg_from(110);
    assert(res.twos_complement().underlying + res.underlying == u64::max() + 1);

    res = I64::neg_from(93);
    assert(res.twos_complement().underlying + res.underlying == u64::max() + 1);

    res = I64::neg_from(78);
    assert(res.twos_complement().underlying + res.underlying == u64::max() + 1);

    true
}
