script;

use sway_libs::signed_integers::i256::I256;
use std::u256::U256;

fn main() -> bool {
    let u128_one = U256 {
        a: 0,
        b: 0,
        c: 0,
        d: 1,
    };
    let u128_two = U256 {
        a: 0,
        b: 0,
        c: 0,
        d: 2,
    };
    let one = I256::from(u128_one);
    let mut res = one + I256::from(u128_one);
    assert(res == I256::from(u128_two));

    let u128_10 = U256 {
        a: 0,
        b: 0,
        c: 0,
        d: 10,
    };
    let u128_11 = U256 {
        a: 0,
        b: 0,
        c: 0,
        d: 11,
    };
    res = I256::from(u128_10) - I256::from(u128_11);
    assert(res.underlying.c == u64::max());
    assert(res.underlying.d == u64::max());

    res = I256::from(u128_10) * I256::neg_from(u128_one);
    assert(res == I256::neg_from(u128_10));

    res = I256::from(u128_10) * I256::from(u128_10);
    let u128_100 = U256 {
        a: 0,
        b: 0,
        c: 0,
        d: 100,
    };
    assert(res == I256::from(u128_100));

    let u128_lower_max_u64 = U256 {
        a: 0,
        b: 0,
        c: 0,
        d: u64::max(),
    };

    res = I256::from(u128_10) / I256 {
        underlying: u128_lower_max_u64,
    };
    assert(res == I256::neg_from(u128_10));

    let u128_5 = U256 {
        a: 0,
        b: 0,
        c: 0,
        d: 5,
    };

    let u128_2 = U256 {
        a: 0,
        b: 0,
        c: 0,
        d: 2,
    };

    let i256_10 = I256::from(u128_10);
    let i256_5 = I256::from(u128_5);
    let i256_2 = I256::from(u128_2);

    res = i256_10 / i256_5;
    assert(res == i256_2);

    true
}
