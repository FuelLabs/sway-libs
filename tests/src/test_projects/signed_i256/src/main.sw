script;

use sway_libs::i256::I256;
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

    res = I256::from(u128_10) / I256::from_uint(u128_lower_max_u64);
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

    res = I256::from(u128_10) / I256::from(u128_5);
    assert(res == I256::from(u128_2));

    //from_u64 test
    assert(one == I256::from_u64(1));
    //as_u64 test
    assert(1 == one.as_u64());
    //flip test
    assert(one.flip() == I256::neg_from(u128_one));
    //ge test
    assert(one >= one);
    assert(I256::from_u64(2) >= one);
    assert(one >= one.flip());
    assert(one.flip() >= I256::from_u64(2).flip());
    //le test
    assert(one <= one);
    assert(one <= I256::from_u64(2));
    assert(one.flip() <= one);
    assert(I256::from_u64(2).flip() <= one.flip());
    //zero test
    assert(I256::zero() == I256::from_u64(0));

    true
}
