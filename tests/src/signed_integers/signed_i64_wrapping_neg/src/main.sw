library;

use sway_libs::signed_integers::i64::I64;

#[test]
fn i64_wrapping_neg() {
    let one = I64::from(1u64);
    let neg_one = I64::from(0u64) - I64::from(1u64);

    let two = I64::from(2u64);
    let neg_two = I64::from(0u64) - I64::from(2u64);

    let ten = I64::from(10u64);
    let neg_ten = I64::from(0u64) - I64::from(10u64);

    let twenty_seven = I64::from(27u64);
    let neg_twenty_seven = I64::from(0u64) - I64::from(27u64);

    let ninty_three = I64::from(93u64);
    let neg_ninty_three = I64::from(0u64) - I64::from(93u64);

    let zero = I64::from(0u64);
    let max = I64::max();
    let min = I64::min();
    let neg_min_plus_one = I64::min() + I64::from(1);

    let res1 = one.wrapping_neg();
    let res2 = neg_one.wrapping_neg();
    assert(res1 == neg_one);
    assert(res2 == one);

    let res3 = two.wrapping_neg();
    let res4 = neg_two.wrapping_neg();
    assert(res3 == neg_two);
    assert(res4 == two);

    let res5 = ten.wrapping_neg();
    let res6 = neg_ten.wrapping_neg();
    assert(res5 == neg_ten);
    assert(res6 == ten);

    let res7 = twenty_seven.wrapping_neg();
    let res8 = neg_twenty_seven.wrapping_neg();
    assert(res7 == neg_twenty_seven);
    assert(res8 == twenty_seven);

    let res9 = ninty_three.wrapping_neg();
    let res10 = neg_ninty_three.wrapping_neg();
    assert(res9 == neg_ninty_three);
    assert(res10 == ninty_three);

    let res11 = zero.wrapping_neg();
    let res12 = max.wrapping_neg();
    let res13 = min.wrapping_neg();

    assert(res11 == zero);
    assert(res12 == neg_min_plus_one);
    assert(res13 == min);
}
