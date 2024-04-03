script;

use sway_libs::signed_integers::i256::I256;

fn main() -> bool {
    let parts_one = (0, 0, 0, 1);
    let parts_two = (0, 0, 0, 2);
    let u_one = asm(r1: parts_one) { r1: u256 };
    let u_two = asm(r1: parts_two) { r1: u256 };
    let one = I256::from(u_one);
    let mut res = one + I256::from(u_one);
    assert(res.twos_complement() == I256::from(u_two));

    let parts_10 = (0, 0, 0, 10);
    let u_10 = asm(r1: parts_10) { r1: u256 };
    res = I256::from(u_10);
    assert(res.twos_complement() == I256::from(u_10));

    let parts_5 = (0, 0, 0, 5);
    let u_5 = asm(r1: parts_5) { r1: u256 };
    res = I256::neg_from(u_5);
    assert(res.twos_complement().underlying - u_one + res.underlying == U256::max());

    let parts_27 = (0, 0, 0, 27);
    let u_27 = asm(r1: parts_27) { r1: u256 };
    res = I256::neg_from(u_27);
    assert(res.twos_complement().underlying - u_one + res.underlying == U256::max());

    let parts_110 = (0, 0, 0, 110);
    let u_110 = asm(r1: parts_110) { r1: u256 };
    res = I256::neg_from(u_110);
    assert(res.twos_complement().underlying - u_one + res.underlying == U256::max());

    let parts_93 = (0, 0, 0, 93);
    let u_93 = asm(r1: parts_93) { r1: u256 };
    res = I256::neg_from(parts_93);
    assert(res.twos_complement().underlying - u_one + res.underlying == U256::max());

    let parts_78 = (0, 0, 0, 78);
    let u_78 = asm(r1: parts_78) { r1: u256 };
    res = I256::neg_from(u_78);
    assert(res.twos_complement().underlying - u_one + res.underlying == U256::max());

    true
}
