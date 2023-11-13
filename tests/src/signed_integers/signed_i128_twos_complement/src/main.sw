script;

use signed_integers::i128::I128;
use std::u128::U128;

fn main() -> bool {
    let u_one = U128::from((0, 1));
    let one = I128::from(u_one);
    let mut res = one + I128::from(U128::from((0, 1)));
    assert(res.twos_complement() == I128::from(U128::from((0, 2))));

    res = I128::from(U128::from((0, 10)));
    assert(res.twos_complement() == I128::from(U128::from((0, 10))));

    res = I128::neg_from(U128::from((0, 5)));
    assert(
        res
            .twos_complement()
            .underlying - u_one + res.underlying == U128::max(),
    );

    res = I128::neg_from(U128::from((0, 27)));
    assert(
        res
            .twos_complement()
            .underlying - u_one + res.underlying == U128::max(),
    );

    res = I128::neg_from(U128::from((0, 110)));
    assert(
        res
            .twos_complement()
            .underlying - u_one + res.underlying == U128::max(),
    );

    res = I128::neg_from(U128::from((0, 93)));
    assert(
        res
            .twos_complement()
            .underlying - u_one + res.underlying == U128::max(),
    );

    res = I128::neg_from(U128::from((0, 78)));
    assert(
        res
            .twos_complement()
            .underlying - u_one + res.underlying == U128::max(),
    );

    true
}
