script;

use sway_libs::signed_integers::i64::I64;

fn main() -> bool {
    let one = I64::from(1u64);
    let mut res = one + I64::from(1u64);
    assert(res == I64::from(2u64));

    res = I64::from(10u64) - I64::from(11u64);
    assert(res == I64::from(9223372036854775807u64));
    res = I64::from(10u64) * I64::neg_from(1);
    assert(res == I64::neg_from(10));

    res = I64::from(10u64) * I64::from(10u64);
    assert(res == I64::from(100u64));

    res = I64::from(10u64) / I64::from(9223372036854775807u64);
    assert(res == I64::neg_from(10u64));

    res = I64::from(10u64) / I64::from(5u64);
    assert(res == I64::from(2u64));

    // Subtraction Tests
    let pos1 = I64::from(1);
    let pos2 = I64::from(2);
    let neg1 = I64::neg_from(1);
    let neg2 = I64::neg_from(2);

    // Both positive:
    let res1 = pos1 - pos2;
    let res1_2 = pos2 - pos1;
    assert(res1 == I64::neg_from(1));

    let res2 = pos2 - pos1;
    assert(res2 == I64::from(1));

    // First positive
    let res3 = pos1 - neg1;
    assert(res3 == I64::from(2));

    // Second positive
    let res4 = neg1 - pos1;
    assert(res4 == I64::neg_from(2));

    // Both negative
    let res5 = neg1 - neg2;
    assert(res5 == I64::from(1));

    let res6 = neg2 - neg1;
    assert(res6 == I64::neg_from(1));

    // OrqEq Tests
    let one_1 = I64::from(1u64);
    let one_2 = I64::from(1u64);
    let neg_one_1 = I64::neg_from(1u64);
    let neg_one_2 = I64::neg_from(1u64);
    let max_1 = I64::max();
    let max_2 = I64::max();
    let min_1 = I64::min();
    let min_2 = I64::min();

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

    true
}
