script;

use sway_libs::signed_integers::i128::I128;
use std::u128::U128;

fn main() -> bool {
    let one = I128::from(U128::from(1u64));
    let neg_one = I128::neg_from(U128::from(1u64));

    let two = I128::from(U128::from(2u64));
    let neg_two = I128::neg_from(U128::from(2u64));

    let ten = I128::from(U128::from(10u64));
    let neg_ten = I128::neg_from(U128::from(10u64));

    let twenty_seven = I128::from(U128::from(27u64));
    let neg_twenty_seven = I128::neg_from(U128::from(27u64));

    let ninty_three = I128::from(U128::from(93u64));
    let neg_ninty_three = I128::neg_from(U128::from(93u64));

    let zero = I128::from(U128::zero());
    let max = I128::max();
    let min = I128::min();
    let neg_min_plus_one = I128::min() + I128::from(U128::from((0, 1)));

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

    true
}
