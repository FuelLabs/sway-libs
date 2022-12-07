script;

use sway_libs::i64::I64;

fn main() -> bool {
    let one = I64::from(1u64);
    let mut res = one + I64::from(1u64);
    assert(res == I64::from(2u64));

    res = I64::from(10u64) - I64::from(11u64);
    assert(res == I64 { underlying: 9223372036854775807u64 });

    res = I64::from(10u64) * I64::neg_from(1);
    assert(res == I64::neg_from(10));

    res = I64::from(10u64) * I64::from(10u64);
    assert(res == I64::from(100u64));

    res = I64::from(10u64) / I64 { underlying: 9223372036854775807u64 };
    assert(res == I64::neg_from(10u64));

    res = I64::from(10u64) / I64::from(5u64);
    assert(res == I64::from(2u64));

    true
}
