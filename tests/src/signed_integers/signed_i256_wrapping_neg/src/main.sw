script;

use sway_libs::signed_integers::i256::I256;

fn main() -> bool {
    let parts_one = (0, 0, 0, 1);
    let parts_two = (0, 0, 0, 2);
    let parts_ten = (0, 0, 0, 10);
    let parts_twenty_seven = (0, 0, 0, 27);
    let parts_ninty_three = (0, 0, 0, 93);
    let u_one = asm(r1: parts_one) {
        r1: u256
    };
    let u_two = asm(r1: parts_two) {
        r1: u256
    };
    let u_ten = asm(r1: parts_ten) {
        r1: u256
    };
    let u_twenty_seven = asm(r1: parts_twenty_seven) {
        r1: u256
    };
    let u_ninty_three = asm(r1: parts_ninty_three) {
        r1: u256
    };

    let one = I256::try_from(u_one).unwrap();
    let neg_one = I256::neg_from(u_one);

    let two = I256::try_from(u_two).unwrap();
    let neg_two = I256::neg_from(u_two);

    let ten = I256::try_from(u_ten).unwrap();
    let neg_ten = I256::neg_from(u_ten);

    let twenty_seven = I256::try_from(u_twenty_seven).unwrap();
    let neg_twenty_seven = I256::neg_from(u_twenty_seven);

    let ninty_three = I256::try_from(u_ninty_three).unwrap();
    let neg_ninty_three = I256::neg_from(u_ninty_three);

    let zero = I256::try_from(u256::zero()).unwrap();
    let max = I256::max();
    let min = I256::min();
    let neg_min_plus_one = I256::min() + I256::try_from(u_one).unwrap();

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
