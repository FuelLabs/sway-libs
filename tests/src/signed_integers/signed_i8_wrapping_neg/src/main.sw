script;

use sway_libs::signed_integers::i8::I8;

fn main() -> bool {
    let one = I8::try_from(1u8).unwrap();
    let neg_one = I8::neg_try_from(1u8).unwrap();

    let two = I8::try_from(2u8).unwrap();
    let neg_two = I8::neg_try_from(2u8).unwrap();

    let ten = I8::try_from(10u8).unwrap();
    let neg_ten = I8::neg_try_from(10u8).unwrap();

    let twenty_seven = I8::try_from(27u8).unwrap();
    let neg_twenty_seven = I8::neg_try_from(27u8).unwrap();

    let ninty_three = I8::try_from(93u8).unwrap();
    let neg_ninty_three = I8::neg_try_from(93u8).unwrap();

    let zero = I8::try_from(0u8).unwrap();
    let max = I8::MAX;
    let min = I8::MIN;
    let neg_min_plus_one = I8::MIN + I8::try_from(1u8).unwrap();

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
