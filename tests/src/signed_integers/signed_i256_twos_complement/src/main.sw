script;

use libraries::signed_integers::i256::I256;
use std::u256::U256;

fn main() -> bool {
    let u_one = U256::from((0, 0, 0, 1));
    let one = I256::from(u_one);
    let mut res = one + I256::from(U256::from((0, 0, 0, 1)));
    assert(res.twos_complement() == I256::from(U256::from((0, 0, 0, 2))));

    res = I256::from(U256::from((0, 0, 0, 10)));
    assert(res.twos_complement() == I256::from(U256::from((0, 0, 0, 10))));

    res = I256::neg_from(U256::from((0, 0, 0, 5)));
    assert(res.twos_complement().underlying - u_one + res.underlying == U256::max());

    res = I256::neg_from(U256::from((0, 0, 0, 27)));
    assert(res.twos_complement().underlying - u_one + res.underlying == U256::max());

    res = I256::neg_from(U256::from((0, 0, 0, 110)));
    assert(res.twos_complement().underlying - u_one + res.underlying == U256::max());

    res = I256::neg_from(U256::from((0, 0, 0, 93)));
    assert(res.twos_complement().underlying - u_one + res.underlying == U256::max());

    res = I256::neg_from(U256::from((0, 0, 0, 78)));
    assert(res.twos_complement().underlying - u_one + res.underlying == U256::max());

    true
}
