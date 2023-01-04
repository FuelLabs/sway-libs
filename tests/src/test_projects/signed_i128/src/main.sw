script;

use sway_libs::i128::I128;
use std::u128::U128;

fn main() -> bool {
    let u128_one = U128 {
        upper: 0,
        lower: 1,
    };
    let u128_two = U128 {
        upper: 0,
        lower: 2,
    };
    let one = I128::from(u128_one);
    let mut res = one + I128::from(u128_one);
    assert(res == I128::from(u128_two));

    let u128_10 = U128 {
        upper: 0,
        lower: 10,
    };
    let u128_11 = U128 {
        upper: 0,
        lower: 11,
    };
    res = I128::from(u128_10) - I128::from(u128_11);
    assert(res.underlying.lower == u64::max());

    res = I128::from(u128_10) * I128::neg_from(u128_one);
    assert(res == I128::neg_from(u128_10));

    res = I128::from(u128_10) * I128::from(u128_10);
    let u128_100 = U128 {
        upper: 0,
        lower: 100,
    };
    assert(res == I128::from(u128_100));

    let u128_lower_max_u64 = U128 {
        upper: 0,
        lower: u64::max(),
    };

    res = I128::from(u128_10) / I128 { underlying: u128_lower_max_u64 };
    assert(res == I128::neg_from(u128_10));

    let u128_5 = U128 {
        upper: 0,
        lower: 5,
    };

    let u128_2 = U128 {
        upper: 0,
        lower: 2,
    };

    res = I128::from(u128_10) / I128::from(u128_5);
    assert(res == I128::from(u128_2));

    //from_u64 test
    assert(one == I128::from_u64(1));
    //as_u64 test
    assert(1 == one.as_u64());
    //flip test
    assert(one.flip() == I128::neg_from(u128_one));
    //ge test
    assert(one >= one);
    assert(I128::from_u64(2) >= one);
    assert(one >= one.flip());
    assert(one.flip() >= I128::from_u64(2).flip());
    //le test
    assert(one <= one);
    assert(one <= I128::from_u64(2));
    assert(one.flip() <= one);
    assert(I128::from_u64(2).flip() <= one.flip());
    //zero test
    assert(I128::zero() == I128::from_u64(0));
    
    true
}
