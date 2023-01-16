script;

use signed_integers::i32::I32;

fn main() -> bool {
    let one = I32 { underlying: 1u32 };
    let mut res = one + I32 { underlying: 1u32 };
    assert(res == I32 { underlying: 2u32 });

    res = I32 { underlying: 10u32 } - I32 { underlying: 11u32 };
    assert(res == I32::from(2147483647u32));

    res = I32 { underlying: 10u32 } * I32 { underlying: 1u32 };
    assert(res == I32::neg_from(10u32));

    res = I32 { underlying: 10u32 } * I32 { underlying: 10u32 };
    assert(res == I32 { underlying: 100u32 });

    res = I32 { underlying: 10u32 } / I32::neg_from(1u32);
    assert(res == I32::neg_from(10u32));

    res = I32 { underlying: 10u32 } / I32 { underlying: 5u32 };
    assert(res == I32 { underlying: 2u32 });

    true
}
