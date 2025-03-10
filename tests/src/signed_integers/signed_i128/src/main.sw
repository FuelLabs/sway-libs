library;

use sway_libs::signed_integers::i128::I128;
use std::convert::*;
use std::flags::{disable_panic_on_overflow, disable_panic_on_unsafe_math};
use std::u128::U128;

#[test]
fn signed_i128_indent() {
    assert(I128::indent() == U128::from((9223372036854775808, 0)));
}

#[test]
fn signed_i128_eq() {
    let i128_1 = I128::zero();
    let i128_2 = I128::zero();
    let i128_3 = I128::try_from(U128::from((0, 1))).unwrap();
    let i128_4 = I128::try_from(U128::from((0, 1))).unwrap();
    let i128_5 = I128::MAX;
    let i128_6 = I128::MAX;
    let i128_7 = I128::MIN;
    let i128_8 = I128::MIN;
    let i128_9 = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let i128_10 = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let i128_11 = I128::try_from(U128::from((1, 0))).unwrap();
    let i128_12 = I128::try_from(U128::from((1, 0))).unwrap();
    let i128_13 = I128::neg_try_from(U128::from((1, 0))).unwrap();
    let i128_14 = I128::neg_try_from(U128::from((1, 0))).unwrap();

    assert(i128_1 == i128_2);
    assert(i128_3 == i128_4);
    assert(i128_5 == i128_6);
    assert(i128_7 == i128_8);
    assert(i128_9 == i128_10);
    assert(i128_11 == i128_12);
    assert(i128_13 == i128_14);

    assert(i128_1 != i128_3);
    assert(i128_1 != i128_5);
    assert(i128_1 != i128_7);
    assert(i128_1 != i128_9);
    assert(i128_1 != i128_11);
    assert(i128_1 != i128_13);

    assert(i128_3 != i128_5);
    assert(i128_3 != i128_7);
    assert(i128_3 != i128_9);
    assert(i128_3 != i128_11);
    assert(i128_3 != i128_13);

    assert(i128_5 != i128_7);
    assert(i128_5 != i128_9);
    assert(i128_5 != i128_11);
    assert(i128_5 != i128_13);

    assert(i128_7 != i128_9);
    assert(i128_7 != i128_11);
    assert(i128_7 != i128_13);

    assert(i128_9 != i128_11);
    assert(i128_9 != i128_13);

    assert(i128_11 != i128_13);
}

#[test]
fn signed_i128_ord() {
    let i128_1 = I128::zero();
    let i128_2 = I128::zero();
    let i128_3 = I128::try_from(U128::from((0, 1))).unwrap();
    let i128_4 = I128::try_from(U128::from((0, 1))).unwrap();
    let i128_5 = I128::MAX;
    let i128_6 = I128::MAX;
    let i128_7 = I128::MIN;
    let i128_8 = I128::MIN;
    let i128_9 = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let i128_10 = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let i128_11 = I128::try_from(U128::from((1, 0))).unwrap();
    let i128_12 = I128::try_from(U128::from((1, 0))).unwrap();
    let i128_13 = I128::neg_try_from(U128::from((1, 0))).unwrap();
    let i128_14 = I128::neg_try_from(U128::from((1, 0))).unwrap();

    assert(!(i128_1 > i128_2));
    assert(!(i128_3 > i128_4));
    assert(!(i128_5 > i128_6));
    assert(!(i128_7 > i128_8));
    assert(!(i128_9 > i128_10));
    assert(!(i128_11 > i128_12));
    assert(!(i128_13 > i128_14));

    assert(i128_1 >= i128_2);
    assert(i128_3 >= i128_4);
    assert(i128_5 >= i128_6);
    assert(i128_7 >= i128_8);
    assert(i128_9 >= i128_10);
    assert(i128_11 >= i128_12);
    assert(i128_13 >= i128_14);

    assert(!(i128_1 < i128_2));
    assert(!(i128_3 < i128_4));
    assert(!(i128_5 < i128_6));
    assert(!(i128_7 < i128_8));
    assert(!(i128_9 < i128_10));
    assert(!(i128_11 < i128_12));
    assert(!(i128_13 < i128_14));

    assert(i128_1 <= i128_2);
    assert(i128_3 <= i128_4);
    assert(i128_5 <= i128_6);
    assert(i128_7 <= i128_8);
    assert(i128_9 <= i128_10);
    assert(i128_11 <= i128_12);
    assert(i128_13 <= i128_14);

    assert(i128_1 < i128_3);
    assert(i128_1 < i128_5);
    assert(i128_3 < i128_5);
    assert(i128_7 < i128_5);
    assert(i128_9 < i128_5);
    assert(i128_9 < i128_1);
    assert(i128_9 < i128_3);
    assert(i128_7 < i128_9);
    assert(i128_9 < i128_12);
    assert(i128_13 < i128_9);
    assert(i128_13 < i128_11);

    assert(i128_5 > i128_1);
    assert(i128_5 > i128_3);
    assert(i128_5 > i128_7);
    assert(i128_5 > i128_9);
    assert(i128_3 > i128_1);
    assert(i128_3 > i128_7);
    assert(i128_3 > i128_9);
    assert(i128_9 > i128_7);
    assert(i128_11 > i128_9);
    assert(i128_9 > i128_13);
    assert(i128_11 > i128_13);
}

#[test]
fn signed_i128_total_ord() {
    let zero = I128::zero();
    let one = I128::try_from(U128::from((0, 1))).unwrap();
    let max_1 = I128::MAX;
    let min_1 = I128::MIN;
    let neg_one_1 = I128::neg_try_from(U128::from((0, 1))).unwrap();

    assert(zero.min(one) == zero);
    assert(zero.max(one) == one);
    assert(one.min(zero) == zero);
    assert(one.max(zero) == one);

    assert(max_1.min(one) == one);
    assert(max_1.max(one) == max_1);
    assert(one.min(max_1) == one);
    assert(one.max(max_1) == max_1);

    assert(min_1.min(one) == min_1);
    assert(min_1.max(one) == one);
    assert(one.min(min_1) == min_1);
    assert(one.max(min_1) == one);

    assert(max_1.min(min_1) == min_1);
    assert(max_1.max(min_1) == max_1);
    assert(min_1.min(max_1) == min_1);
    assert(min_1.max(max_1) == max_1);

    assert(neg_one_1.min(one) == neg_one_1);
    assert(neg_one_1.max(one) == one);
    assert(one.min(neg_one_1) == neg_one_1);
    assert(one.max(neg_one_1) == one);
}

#[test]
fn signed_i128_bits() {
    assert(I128::bits() == 128);
}

#[test]
fn signed_i128_from_uint() {
    let zero = I128::from_uint(U128::zero());
    let one = I128::from_uint(U128::from((0, 1)));
    let upper = I128::from_uint(U128::from((1, 0)));
    let max = I128::from_uint(U128::max());

    assert(zero.underlying() == U128::zero());
    assert(one.underlying() == U128::from((0, 1)));
    assert(upper.underlying() == U128::from((1, 0)));
    assert(max.underlying() == U128::max());
}

#[test]
fn signed_i128_max_constant() {
    let max = I128::MAX;
    assert(max.underlying() == U128::max());
}

#[test]
fn signed_i128_min_constant() {
    let max = I128::MIN;
    assert(max.underlying() == U128::min());
}

#[test]
fn signed_i128_neg_try_from() {
    let indent = I128::indent();

    let neg_try_from_zero = I128::neg_try_from(U128::min());
    assert(neg_try_from_zero.is_some());
    assert(neg_try_from_zero.unwrap() == I128::zero());

    let neg_try_from_one = I128::neg_try_from(U128::from((0, 1)));
    assert(neg_try_from_one.is_some());
    assert(neg_try_from_one.unwrap().underlying() == I128::indent() - U128::from((0, 1)));

    let neg_try_from_max = I128::neg_try_from(indent);
    assert(neg_try_from_max.is_some());
    assert(neg_try_from_max.unwrap().underlying() == U128::min());

    let neg_try_from_overflow = I128::neg_try_from(indent + U128::from((0, 1)));
    assert(neg_try_from_overflow.is_none());
}

#[test]
fn signed_i128_new() {
    let new = I128::new();

    assert(new.underlying() == U128::from((9223372036854775808, 0)));
}

#[test]
fn signed_i128_zero() {
    let zero = I128::zero();

    assert(zero.underlying() == U128::from((9223372036854775808, 0)));
}

#[test]
fn signed_i128_is_zero() {
    let zero = I128::zero();
    assert(zero.is_zero());

    let other_1 = I128::from_uint(U128::from((0, 1)));
    let other_2 = I128::MAX;
    assert(!other_1.is_zero());
    assert(!other_2.is_zero());
}

#[test]
fn signed_i128_underlying() {
    let zero = I128::from_uint(U128::zero());
    let one = I128::from_uint(U128::from((0, 1)));
    let max = I128::from_uint(U128::max());
    let indent = I128::zero();

    assert(zero.underlying() == U128::zero());
    assert(one.underlying() == U128::from((0, 1)));
    assert(max.underlying() == U128::max());
    assert(indent.underlying() == U128::from((9223372036854775808, 0)));
}

#[test]
fn signed_i128_add() {
    let pos1 = I128::try_from(U128::from((0, 1))).unwrap();
    let pos2 = I128::try_from(U128::from((0, 2))).unwrap();
    let neg1 = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let neg2 = I128::neg_try_from(U128::from((0, 2))).unwrap();
    let upper1 = I128::try_from(U128::from((1, 0))).unwrap();
    let upper2 = I128::try_from(U128::from((2, 0))).unwrap();
    let neg_upper1 = I128::neg_try_from(U128::from((1, 0))).unwrap();
    let neg_upper2 = I128::neg_try_from(U128::from((2, 0))).unwrap();
    // Both positive:
    let res1 = pos1 + pos2;
    assert(res1 == I128::try_from(U128::from((0, 3))).unwrap());

    let res2 = pos2 + pos1;
    assert(res2 == I128::try_from(U128::from((0, 3))).unwrap());

    let upper_res1 = upper1 + upper2;
    assert(upper_res1 == I128::try_from(U128::from((3, 0))).unwrap());

    let upper_res2 = upper2 + upper1;
    assert(upper_res2 == I128::try_from(U128::from((3, 0))).unwrap());

    // First positive
    let res3 = pos1 + neg1;
    assert(res3 == I128::zero());

    let res4 = pos2 + neg1;
    assert(res4 == I128::try_from(U128::from((0, 1))).unwrap());

    let res5 = pos1 + neg2;
    assert(res5 == I128::neg_try_from(U128::from((0, 1))).unwrap());

    let upper_res3 = upper1 + neg_upper1;
    assert(upper_res3 == I128::zero());

    let upper_res4 = upper2 + neg_upper1;
    assert(upper_res4 == I128::try_from(U128::from((1, 0))).unwrap());

    let upper_res5 = upper1 + neg_upper2;
    assert(upper_res5 == I128::neg_try_from(U128::from((1, 0))).unwrap());

    // Second positive
    let res6 = neg1 + pos1;
    assert(res6 == I128::zero());

    let res7 = neg2 + pos1;
    assert(res7 == I128::neg_try_from(U128::from((0, 1))).unwrap());

    let res8 = neg1 + pos2;
    assert(res8 == I128::try_from(U128::from((0, 1))).unwrap());

    let upper_res6 = neg_upper1 + upper1;
    assert(upper_res6 == I128::zero());

    let upper_res7 = neg_upper2 + upper1;
    assert(upper_res7 == I128::neg_try_from(U128::from((1, 0))).unwrap());

    let upper_res8 = neg_upper1 + upper2;
    assert(upper_res8 == I128::try_from(U128::from((1, 0))).unwrap());

    // Both negative
    let res9 = neg1 + neg2;
    assert(res9 == I128::neg_try_from(U128::from((0, 3))).unwrap());

    let res10 = neg2 + neg1;
    assert(res10 == I128::neg_try_from(U128::from((0, 3))).unwrap());

    let upper_res9 = neg_upper1 + neg_upper2;
    assert(upper_res9 == I128::neg_try_from(U128::from((3, 0))).unwrap());

    let upper_res10 = neg_upper2 + neg_upper1;
    assert(upper_res10 == I128::neg_try_from(U128::from((3, 0))).unwrap());

    // Edge Cases
    let res11 = I128::MIN + I128::MAX;
    assert(res11 == I128::neg_try_from(U128::from((0, 1))).unwrap());

    let res12 = I128::MAX + I128::zero();
    assert(res12 == I128::MAX);

    let res13 = I128::MIN + I128::zero();
    assert(res13 == I128::MIN);

    let res14 = I128::zero() + I128::zero();
    assert(res14 == I128::zero());
}

#[test(should_revert)]
fn revert_signed_i128_add() {
    let one = I128::try_from(U128::from((0, 1))).unwrap();
    let max = I128::MAX;

    let _ = max + one;
}

#[test(should_revert)]
fn revert_signed_i128_add_negative() {
    let neg_one = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let min = I128::MIN;

    let _ = min + neg_one;
}

#[test(should_revert)]
fn revert_signed_i128_add_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let one = I128::try_from(U128::from((0, 1))).unwrap();
    let max = I128::MAX;

    let _ = max + one;
}

#[test]
fn signed_i128_add_overflow() {
    let _ = disable_panic_on_overflow();

    let one = I128::try_from(U128::from((0, 1))).unwrap();
    let max = I128::MAX;

    assert(max + one == I128::MIN);
}

#[test]
fn signed_i128_subtract() {
    let pos1 = I128::try_from(U128::from((0, 1))).unwrap();
    let pos2 = I128::try_from(U128::from((0, 2))).unwrap();
    let neg1 = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let neg2 = I128::neg_try_from(U128::from((0, 2))).unwrap();

    // Both positive:
    let res1 = pos1 - pos2;
    assert(res1 == I128::neg_try_from(U128::from((0, 1))).unwrap());

    let res2 = pos2 - pos1;
    assert(res2 == I128::try_from(U128::from((0, 1))).unwrap());

    // First positive
    let res3 = pos1 - neg1;
    assert(res3 == I128::try_from(U128::from((0, 2))).unwrap());

    let res4 = pos2 - neg1;
    assert(res4 == I128::try_from(U128::from((0, 3))).unwrap());

    // Second positive
    let res5 = neg1 - pos1;
    assert(res5 == I128::neg_try_from(U128::from((0, 2))).unwrap());

    let res6 = neg2 - pos1;
    assert(res6 == I128::neg_try_from(U128::from((0, 3))).unwrap());

    // Both negative
    let res7 = neg1 - neg2;
    assert(res7 == I128::try_from(U128::from((0, 1))).unwrap());

    let res8 = neg2 - neg1;
    assert(res8 == I128::neg_try_from(U128::from((0, 1))).unwrap());

    // Edge Cases
    let res11 = I128::zero() - (I128::MIN + I128::try_from(U128::from((0, 1))).unwrap());
    assert(res11 == I128::MAX);

    let res12 = I128::MAX - I128::zero();
    assert(res12 == I128::MAX);

    let res13 = I128::MIN - I128::zero();
    assert(res13 == I128::MIN);

    let res14 = I128::zero() - I128::zero();
    assert(res14 == I128::zero());
}

#[test(should_revert)]
fn revert_signed_i128_sub() {
    let min = I128::MIN;
    let one = I128::try_from(U128::from((0, 1))).unwrap();

    let _ = min - one;
}

#[test(should_revert)]
fn revert_signed_i128_sub_negative() {
    let max = I128::MAX;
    let neg_one = I128::neg_try_from(U128::from((0, 1))).unwrap();

    let _ = max - neg_one;
}

#[test(should_revert)]
fn revert_signed_i128_sub_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let min = I128::MIN;
    let one = I128::try_from(U128::from((0, 1))).unwrap();

    let _ = min - one;
}

#[test]
fn signed_i128_sub_underflow() {
    let _ = disable_panic_on_overflow();

    let min = I128::MIN;
    let one = I128::try_from(U128::from((0, 1))).unwrap();

    let result = min - one;
    assert(result == I128::MAX);
}

#[test]
fn signed_i128_multiply() {
    let pos1 = I128::try_from(U128::from((0, 1))).unwrap();
    let pos2 = I128::try_from(U128::from((0, 2))).unwrap();
    let neg1 = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let neg2 = I128::neg_try_from(U128::from((0, 2))).unwrap();

    // Both positive:
    let res1 = pos1 * pos2;
    assert(res1 == I128::try_from(U128::from((0, 2))).unwrap());

    let res2 = pos2 * pos1;
    assert(res2 == I128::try_from(U128::from((0, 2))).unwrap());

    // First positive
    let res3 = pos1 * neg1;
    assert(res3 == I128::neg_try_from(U128::from((0, 1))).unwrap());

    let res4 = pos2 * neg1;
    assert(res4 == I128::neg_try_from(U128::from((0, 2))).unwrap());

    let res5 = pos1 * neg2;
    assert(res5 == I128::neg_try_from(U128::from((0, 2))).unwrap());

    // Second positive
    let res6 = neg1 * pos1;
    assert(res6 == I128::neg_try_from(U128::from((0, 1))).unwrap());

    let res7 = neg2 * pos1;
    assert(res7 == I128::neg_try_from(U128::from((0, 2))).unwrap());

    let res8 = neg1 * pos2;
    assert(res8 == I128::neg_try_from(U128::from((0, 2))).unwrap());

    // Both negative
    let res9 = neg1 * neg2;
    assert(res9 == I128::try_from(U128::from((0, 2))).unwrap());

    let res10 = neg2 * neg1;
    assert(res10 == I128::try_from(U128::from((0, 2))).unwrap());

    // Edge Cases
    let res12 = I128::MAX * I128::zero();
    assert(res12 == I128::zero());

    let res13 = I128::MIN * I128::zero();
    assert(res13 == I128::zero());

    let res14 = I128::zero() * I128::zero();
    assert(res14 == I128::zero());
}

#[test(should_revert)]
fn revert_signed_i128_mul() {
    let max = I128::MAX;
    let two = I128::try_from(U128::from((0, 2))).unwrap();

    let _ = max * two;
}

#[test(should_revert)]
fn revert_signed_i128_mul_negatice() {
    let max = I128::MAX;
    let two = I128::neg_try_from(U128::from((0, 2))).unwrap();

    let _ = max * two;
}

#[test(should_revert)]
fn revert_signed_i128_mul_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let max = I128::MAX;
    let two = I128::try_from(U128::from((0, 2))).unwrap();

    let _ = max * two;
}

#[test]
fn signed_i128_mul() {
    let _ = disable_panic_on_overflow();

    let max = I128::MAX;
    let two = I128::try_from(U128::from((0, 2))).unwrap();

    let result = max * two;
    assert(result == I128::neg_try_from(U128::from((0, 2))).unwrap());
}

#[test]
fn signed_i128_divide() {
    let pos1 = I128::try_from(U128::from((0, 1))).unwrap();
    let pos2 = I128::try_from(U128::from((0, 2))).unwrap();
    let neg1 = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let neg2 = I128::neg_try_from(U128::from((0, 2))).unwrap();

    // Both positive:
    let res1 = pos1 / pos2;
    assert(res1 == I128::zero());

    let res2 = pos2 / pos1;
    assert(res2 == I128::try_from(U128::from((0, 2))).unwrap());

    // First positive
    let res3 = pos1 / neg1;
    assert(res3 == I128::neg_try_from(U128::from((0, 1))).unwrap());

    let res4 = pos2 / neg1;
    assert(res4 == I128::neg_try_from(U128::from((0, 2))).unwrap());

    let res5 = pos1 / neg2;
    assert(res5 == I128::zero());

    // Second positive
    let res6 = neg1 / pos1;
    assert(res6 == I128::neg_try_from(U128::from((0, 1))).unwrap());

    let res7 = neg2 / pos1;
    assert(res7 == I128::neg_try_from(U128::from((0, 2))).unwrap());

    let res8 = neg1 / pos2;
    assert(res8 == I128::zero());

    // Both negative
    let res9 = neg1 / neg2;
    assert(res9 == I128::zero());

    let res10 = neg2 / neg1;
    assert(res10 == I128::try_from(U128::from((0, 2))).unwrap());

    // Edge Cases
    let res12 = I128::zero() / I128::MAX;
    assert(res12 == I128::zero());

    let res13 = I128::zero() / I128::MIN;
    assert(res13 == I128::zero());
}

#[test(should_revert)]
fn revert_signed_i128_divide() {
    let zero = I128::zero();
    let one = I128::try_from(U128::from((0, 1))).unwrap();

    let _ = one / zero;
}

#[test]
fn signed_i128_divide_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();
    let zero = I128::zero();
    let one = I128::try_from(U128::from((0, 1))).unwrap();

    let res = one / zero;
    assert(res == I128::zero());
}

#[test(should_revert)]
fn revert_signed_i128_divide_disable_overflow() {
    let _ = disable_panic_on_overflow();
    let zero = I128::zero();
    let one = I128::try_from(U128::from((0, 1))).unwrap();

    let _ = one / zero;
}

#[test]
fn signed_i128_wrapping_neg() {
    let one = I128::try_from(U128::from((0, 1))).unwrap();
    let neg_one = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let two = I128::try_from(U128::from((0, 2))).unwrap();
    let neg_two = I128::neg_try_from(U128::from((0, 2))).unwrap();
    let ten = I128::try_from(U128::from((0, 10))).unwrap();
    let neg_ten = I128::neg_try_from(U128::from((0, 10))).unwrap();
    let twenty_seven = I128::try_from(U128::from((0, 27))).unwrap();
    let neg_twenty_seven = I128::neg_try_from(U128::from((0, 27))).unwrap();
    let ninty_three = I128::try_from(U128::from((0, 93))).unwrap();
    let neg_ninty_three = I128::neg_try_from(U128::from((0, 93))).unwrap();
    let upper_u128 = I128::try_from(U128::from((1, 0))).unwrap();
    let neg_upper_u128 = I128::neg_try_from(U128::from((1, 0))).unwrap();
    let zero = I128::try_from(U128::from((0, 0))).unwrap();
    let max = I128::MAX;
    let min = I128::MIN;
    let neg_min_plus_one = I128::MIN + I128::try_from(U128::from((0, 1))).unwrap();

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

    let res14 = upper_u128.wrapping_neg();
    let res15 = neg_upper_u128.wrapping_neg();
    assert(res14 == neg_upper_u128);
    assert(res15 == upper_u128);

    assert(res11 == zero);
    assert(res12 == neg_min_plus_one);
    assert(res13 == min);
}

#[test]
fn signed_i128_try_from_u128() {
    let indent: U128 = I128::indent();

    let i128_max_try_from = I128::try_from(indent - U128::from((0, 1)));
    assert(i128_max_try_from.is_some());
    assert(i128_max_try_from.unwrap() == I128::MAX);

    let i128_min_try_from = I128::try_from(U128::min());
    assert(i128_min_try_from.is_some());
    assert(i128_min_try_from.unwrap() == I128::zero());

    let i128_overflow_try_from = I128::try_from(indent);
    assert(i128_overflow_try_from.is_none());
}

#[test]
fn signed_i128_try_into_u128() {
    let zero = I128::zero();
    let negative = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let max = I128::MAX;
    let indent: U128 = I128::indent();

    let U128_max_try_into: Option<U128> = max.try_into();
    assert(U128_max_try_into.is_some());
    assert(U128_max_try_into.unwrap() == indent - U128::from((0, 1)));

    let U128_min_try_into: Option<U128> = zero.try_into();
    assert(U128_min_try_into.is_some());
    assert(U128_min_try_into.unwrap() == U128::zero());

    let U128_overflow_try_into: Option<U128> = negative.try_into();
    assert(U128_overflow_try_into.is_none());
}

#[test]
fn signed_i128_u128_try_from() {
    let zero = I128::zero();
    let negative = I128::neg_try_from(U128::from((0, 1))).unwrap();
    let max = I128::MAX;
    let indent: U128 = I128::indent();

    let U128_max_try_from: Option<U128> = U128::try_from(max);
    assert(U128_max_try_from.is_some());
    assert(U128_max_try_from.unwrap() == indent - U128::from((0, 1)));

    let U128_min_try_from: Option<U128> = U128::try_from(zero);
    assert(U128_min_try_from.is_some());
    assert(U128_min_try_from.unwrap() == U128::zero());

    let U128_overflow_try_from: Option<U128> = U128::try_from(negative);
    assert(U128_overflow_try_from.is_none());
}

#[test]
fn signed_i128_u128_try_into() {
    let indent: U128 = I128::indent();

    let i128_max_try_into: Option<I128> = (indent - U128::from((0, 1))).try_into();
    assert(i128_max_try_into.is_some());
    assert(i128_max_try_into.unwrap() == I128::MAX);

    let i128_min_try_into: Option<I128> = U128::min().try_into();
    assert(i128_min_try_into.is_some());
    assert(i128_min_try_into.unwrap() == I128::zero());

    let i128_overflow_try_into: Option<I128> = indent.try_into();
    assert(i128_overflow_try_into.is_none());
}
