script;

use sway_libs::signed_integers::i256::I256;

fn main() -> bool {
    let parts_one = (0, 0, 0, 1);
    let parts_two = (0, 0, 0, 2);
    let u256_one = asm(r1: parts_one) {
        r1: u256
    };
    let u256_two = asm(r1: parts_two) {
        r1: u256
    };

    let one = I256::from(u256_one);
    let mut res = one + I256::from(u256_one);
    assert(res == I256::from(u256_two));

    let parts_10 = (0, 0, 0, 10);
    let u256_10 = asm(r1: parts_10) {
        r1: u256
    };

    let parts_11 = (0, 0, 0, 11);
    let u256_11 = asm(r1: parts_11) {
        r1: u256
    };

    res = I256::from(u256_10) - I256::from(u256_11);
    let (a, b, c, d) = asm(r1: res) {
        r1: (u64, u64, u64, u64)
    };
    assert(c == u64::max());
    assert(d == u64::max());

    res = I256::from(u256_10) * I256::neg_try_from(u256_one).unwrap();
    assert(res == I256::neg_try_from(u256_10).unwrap());

    res = I256::from(u256_10) * I256::from(u256_10);
    let parts_100 = (0, 0, 0, 100);
    let u256_100 = asm(r1: parts_100) {
        r1: u256
    };
    assert(res == I256::from(u256_100));

    let parts_lower_max_u64 = (0, 0, 0, u64::max());
    let u256_lower_max_u64 = asm(r1: parts_lower_max_u64) {
        r1: u256
    };

    res = I256::from(u256_10) / I256::from(u256_lower_max_u64);
    assert(res == I256::neg_try_from(u256_10).unwrap());

    let parts_5 = (0, 0, 0, 5);
    let u256_5 = asm(r1: parts_5) {
        r1: u256
    };

    let parts_2 = (0, 0, 0, 2);
    let u256_2 = asm(r1: parts_2) {
        r1: u256
    };

    let i256_10 = I256::from(u256_10);
    let i256_5 = I256::from(u256_5);
    let i256_2 = I256::from(u256_2);

    res = i256_10 / i256_5;
    assert(res == i256_2);

    // Subtraction tests
    let pos1 = I256::from(u256_one);
    let pos2 = I256::from(u256_two);
    let neg1 = I256::neg_from(u256_one);
    let neg2 = I256::neg_from(u256_two);

    // Both positive:
    let res1 = pos1 - pos2;
    assert(res1 == I256::neg_from(u256_one));

    let res2 = pos2 - pos1;
    assert(res2 == I256::from(u256_one));

    // First positive
    let res3 = pos1 - neg1;
    assert(res3 == I256::from(u256_two));

    // Second positive
    let res4 = neg1 - pos1;
    assert(res4 == I256::neg_from(u256_two));

    // Both negative
    let res5 = neg1 - neg2;
    assert(res5 == I256::from(u256_one));

    let res6 = neg2 - neg1;
    assert(res6 == I256::neg_from(u256_one));

    // OrqEq Tests
    let one_1 = I256::from(u256_one);
    let one_2 = I256::from(u256_one);
    let neg_one_1 = I256::neg_try_from(u256_one).unwrap();
    let neg_one_2 = I256::neg_try_from(u256_one).unwrap();
    let max_1 = I256::max();
    let max_2 = I256::max();
    let min_1 = I256::min();
    let min_2 = I256::min();

    assert(one_1 >= one_2);
    assert(one_1 <= one_2);
    assert(neg_one_1 >= neg_one_2);
    assert(neg_one_1 <= neg_one_2);
    assert(max_1 >= max_1);
    assert(max_1 <= max_1);
    assert(min_1 >= min_1);
    assert(min_1 <= min_1);

    assert(min_1 <= one_1);
    assert(min_1 <= neg_one_1);
    assert(min_1 <= max_1);
    assert(neg_one_1 <= max_1);
    assert(neg_one_1 <= one_1);
    assert(one_1 <= max_1);

    assert(max_1 >= one_1);
    assert(max_1 >= neg_one_1);
    assert(max_1 >= min_1);
    assert(one_1 >= neg_one_1);
    assert(one_1 >= min_1);
    assert(neg_one_1 >= min_1);

    // Test neg try from
    let indent = I256::indent();

    let neg_try_from_zero = I256::neg_try_from(u256::min());
    assert(neg_try_from_zero.is_some());
    assert(neg_try_from_zero.unwrap() == I256::zero());

    let neg_try_from_one = I256::neg_try_from(u256_one);
    assert(neg_try_from_one.is_some());
    assert(neg_try_from_one.unwrap().underlying() == I256::indent() - u256_one);

    let neg_try_from_max = I256::neg_try_from(indent);
    assert(neg_try_from_max.is_some());
    assert(neg_try_from_max.unwrap().underlying() == u256::min());

    let neg_try_from_overflow = I256::neg_try_from(indent + u256_one);
    assert(neg_try_from_overflow.is_none());

    true
}
