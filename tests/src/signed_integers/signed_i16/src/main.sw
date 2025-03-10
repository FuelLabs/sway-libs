library;

use sway_libs::signed_integers::i16::I16;
use std::convert::*;
use std::flags::{disable_panic_on_overflow, disable_panic_on_unsafe_math};

#[test]
fn signed_i16_indent() {
    assert(I16::indent() == 32768u16);
}

#[test]
fn signed_i16_eq() {
    let i16_1 = I16::zero();
    let i16_2 = I16::zero();
    let i16_3 = I16::try_from(1u16).unwrap();
    let i16_4 = I16::try_from(1u16).unwrap();
    let i16_5 = I16::MAX;
    let i16_6 = I16::MAX;
    let i16_7 = I16::MIN;
    let i16_8 = I16::MIN;
    let i16_9 = I16::neg_try_from(1u16).unwrap();
    let i16_10 = I16::neg_try_from(1u16).unwrap();

    assert(i16_1 == i16_2);
    assert(i16_3 == i16_4);
    assert(i16_5 == i16_6);
    assert(i16_7 == i16_8);
    assert(i16_9 == i16_10);

    assert(i16_1 != i16_3);
    assert(i16_1 != i16_5);
    assert(i16_1 != i16_7);
    assert(i16_1 != i16_9);

    assert(i16_3 != i16_5);
    assert(i16_3 != i16_7);
    assert(i16_3 != i16_9);

    assert(i16_5 != i16_7);
    assert(i16_5 != i16_9);

    assert(i16_7 != i16_9);
}

#[test]
fn signed_i16_ord() {
    let i16_1 = I16::zero();
    let i16_2 = I16::zero();
    let i16_3 = I16::try_from(1u16).unwrap();
    let i16_4 = I16::try_from(1u16).unwrap();
    let i16_5 = I16::MAX;
    let i16_6 = I16::MAX;
    let i16_7 = I16::MIN;
    let i16_8 = I16::MIN;
    let i16_9 = I16::neg_try_from(1u16).unwrap();
    let i16_10 = I16::neg_try_from(1u16).unwrap();

    assert(!(i16_1 > i16_2));
    assert(!(i16_3 > i16_4));
    assert(!(i16_5 > i16_6));
    assert(!(i16_7 > i16_8));
    assert(!(i16_9 > i16_10));

    assert(i16_1 >= i16_2);
    assert(i16_3 >= i16_4);
    assert(i16_5 >= i16_6);
    assert(i16_7 >= i16_8);
    assert(i16_9 >= i16_10);

    assert(!(i16_1 < i16_2));
    assert(!(i16_3 < i16_4));
    assert(!(i16_5 < i16_6));
    assert(!(i16_7 < i16_8));
    assert(!(i16_9 < i16_10));

    assert(i16_1 <= i16_2);
    assert(i16_3 <= i16_4);
    assert(i16_5 <= i16_6);
    assert(i16_7 <= i16_8);
    assert(i16_9 <= i16_10);

    assert(i16_1 < i16_3);
    assert(i16_1 < i16_5);
    assert(i16_3 < i16_5);
    assert(i16_7 < i16_5);
    assert(i16_9 < i16_5);
    assert(i16_9 < i16_1);
    assert(i16_9 < i16_3);
    assert(i16_7 < i16_9);

    assert(i16_5 > i16_1);
    assert(i16_5 > i16_3);
    assert(i16_5 > i16_7);
    assert(i16_5 > i16_9);
    assert(i16_3 > i16_1);
    assert(i16_3 > i16_7);
    assert(i16_3 > i16_9);
    assert(i16_9 > i16_7);
}

#[test]
fn signed_i16_total_ord() {
    let zero = I16::zero();
    let one = I16::try_from(1u16).unwrap();
    let max_1 = I16::MAX;
    let min_1 = I16::MIN;
    let neg_one_1 = I16::neg_try_from(1u16).unwrap();
    
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
fn signed_i16_bits() {
    assert(I16::bits() == 16);
}

#[test]
fn signed_i16_from_uint() {
    let zero = I16::from_uint(0u16);
    let one = I16::from_uint(1u16);
    let max = I16::from_uint(u16::max());

    assert(zero.underlying() == 0u16);
    assert(one.underlying() == 1u16);
    assert(max.underlying() == u16::max());
}

#[test]
fn signed_i16_max_constant() {
    let max = I16::MAX;
    assert(max.underlying() == u16::max());
}

#[test]
fn signed_i16_min_constant() {
    let max = I16::MIN;
    assert(max.underlying() == u16::min());
}

#[test]
fn signed_i16_neg_try_from() {
    let indent = I16::indent();

    let neg_try_from_zero = I16::neg_try_from(u16::min());
    assert(neg_try_from_zero.is_some());
    assert(neg_try_from_zero.unwrap() == I16::zero());

    let neg_try_from_one = I16::neg_try_from(1u16);
    assert(neg_try_from_one.is_some());
    assert(neg_try_from_one.unwrap().underlying() == I16::indent() - 1u16);

    let neg_try_from_max = I16::neg_try_from(indent);
    assert(neg_try_from_max.is_some());
    assert(neg_try_from_max.unwrap().underlying() == u16::min());

    let neg_try_from_overflow = I16::neg_try_from(indent + 1u16);
    assert(neg_try_from_overflow.is_none());
}

#[test]
fn signed_i16_new() {
    let new = I16::new();

    assert(new.underlying() == 32768u16);
}

#[test]
fn signed_i16_zero() {
    let zero = I16::zero();

    assert(zero.underlying() == 32768u16);
}

#[test]
fn signed_i16_is_zero() {
    let zero = I16::zero();
    assert(zero.is_zero());

    let other_1 = I16::from_uint(1);
    let other_2 = I16::MAX;
    assert(!other_1.is_zero());
    assert(!other_2.is_zero());
}

#[test]
fn signed_i16_underlying() {
    let zero = I16::from_uint(0u16);
    let one = I16::from_uint(1u16);
    let max = I16::from_uint(u16::max());
    let indent = I16::zero();

    assert(zero.underlying() == 0u16);
    assert(one.underlying() == 1u16);
    assert(max.underlying() == u16::max());
    assert(indent.underlying() == 32768u16);
}

#[test]
fn signed_i16_add() {
    let pos1 = I16::try_from(1).unwrap();
    let pos2 = I16::try_from(2).unwrap();
    let neg1 = I16::neg_try_from(1).unwrap();
    let neg2 = I16::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 + pos2;
    assert(res1 == I16::try_from(3).unwrap());

    let res2 = pos2 + pos1;
    assert(res2 == I16::try_from(3).unwrap());

    // First positive
    let res3 = pos1 + neg1;
    assert(res3 == I16::zero());

    let res4 = pos2 + neg1;
    assert(res4 == I16::try_from(1).unwrap());

    let res5 = pos1 + neg2;
    assert(res5 == I16::neg_try_from(1).unwrap());

    // Second positive
    let res6 = neg1 + pos1;
    assert(res6 == I16::zero());

    let res7 = neg2 + pos1;
    assert(res7 == I16::neg_try_from(1).unwrap());

    let res8 = neg1 + pos2;
    assert(res8 == I16::try_from(1).unwrap());

    // Both negative
    let res9 = neg1 + neg2;
    assert(res9 == I16::neg_try_from(3).unwrap());

    let res10 = neg2 + neg1;
    assert(res10 == I16::neg_try_from(3).unwrap());

    // Edge Cases
    let res11 = I16::MIN + I16::MAX;
    assert(res11 == I16::neg_try_from(1).unwrap());

    let res12 = I16::MAX + I16::zero();
    assert(res12 == I16::MAX);

    let res13 = I16::MIN + I16::zero();
    assert(res13 == I16::MIN);

    let res14 = I16::zero() + I16::zero();
    assert(res14 == I16::zero());
}

#[test(should_revert)]
fn revert_signed_i16_add() {
    let one = I16::try_from(1u16).unwrap();
    let max = I16::MAX;

    let _ = max + one;
}

#[test(should_revert)]
fn revert_signed_i16_add_negative() {
    let neg_one = I16::neg_try_from(1u16).unwrap();
    let min = I16::MIN;

    let _ = min + neg_one;
}

#[test(should_revert)]
fn revert_signed_i16_add_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let one = I16::try_from(1u16).unwrap();
    let max = I16::MAX;

    let _ = max + one;
}

#[test]
fn signed_i16_add_overflow() {
    let _ = disable_panic_on_overflow();

    let one = I16::try_from(1u16).unwrap();
    let max = I16::MAX;

    assert(max + one == I16::MIN);
}

#[test]
fn signed_i16_subtract() {
    let pos1 = I16::try_from(1).unwrap();
    let pos2 = I16::try_from(2).unwrap();
    let neg1 = I16::neg_try_from(1).unwrap();
    let neg2 = I16::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 - pos2;
    assert(res1 == I16::neg_try_from(1).unwrap());

    let res2 = pos2 - pos1;
    assert(res2 == I16::try_from(1).unwrap());

    // First positive
    let res3 = pos1 - neg1;
    assert(res3 == I16::try_from(2).unwrap());

    let res4 = pos2 - neg1;
    assert(res4 == I16::try_from(3).unwrap());

    // Second positive
    let res5 = neg1 - pos1;
    assert(res5 == I16::neg_try_from(2).unwrap());

    let res6 = neg2 - pos1;
    assert(res6 == I16::neg_try_from(3).unwrap());

    // Both negative
    let res7 = neg1 - neg2;
    assert(res7 == I16::try_from(1).unwrap());

    let res8 = neg2 - neg1;
    assert(res8 == I16::neg_try_from(1).unwrap());

    // Edge Cases
    let res11 = I16::zero() - (I16::MIN + I16::try_from(1).unwrap());
    assert(res11 == I16::MAX);

    let res12 = I16::MAX - I16::zero();
    assert(res12 == I16::MAX);

    let res13 = I16::MIN - I16::zero();
    assert(res13 == I16::MIN);

    let res14 = I16::zero() - I16::zero();
    assert(res14 == I16::zero());
}

#[test(should_revert)]
fn revert_signed_i16_sub() {
    let min = I16::MIN;
    let one = I16::try_from(1u16).unwrap();

    let _ = min - one;
}

#[test(should_revert)]
fn revert_signed_i16_sub_negative() {
    let max = I16::MAX;
    let neg_one = I16::neg_try_from(1u16).unwrap();

    let _ = max - neg_one;
}

#[test(should_revert)]
fn revert_signed_i16_sub_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let min = I16::MIN;
    let one = I16::try_from(1u16).unwrap();

    let _ = min - one;
}

#[test]
fn signed_i16_sub_underflow() {
    let _ = disable_panic_on_overflow();

    let min = I16::MIN;
    let one = I16::try_from(1u16).unwrap();

    let result = min - one;
    assert(result == I16::MAX);
}

#[test]
fn signed_i16_multiply() {
    let pos1 = I16::try_from(1).unwrap();
    let pos2 = I16::try_from(2).unwrap();
    let neg1 = I16::neg_try_from(1).unwrap();
    let neg2 = I16::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 * pos2;
    assert(res1 == I16::try_from(2).unwrap());

    let res2 = pos2 * pos1;
    assert(res2 == I16::try_from(2).unwrap());

    // First positive
    let res3 = pos1 * neg1;
    assert(res3 == I16::neg_try_from(1).unwrap());

    let res4 = pos2 * neg1;
    assert(res4 == I16::neg_try_from(2).unwrap());

    let res5 = pos1 * neg2;
    assert(res5 == I16::neg_try_from(2).unwrap());

    // Second positive
    let res6 = neg1 * pos1;
    assert(res6 == I16::neg_try_from(1).unwrap());

    let res7 = neg2 * pos1;
    assert(res7 == I16::neg_try_from(2).unwrap());

    let res8 = neg1 * pos2;
    assert(res8 == I16::neg_try_from(2).unwrap());

    // Both negative
    let res9 = neg1 * neg2;
    assert(res9 == I16::try_from(2).unwrap());

    let res10 = neg2 * neg1;
    assert(res10 == I16::try_from(2).unwrap());

    // Edge Cases
    let res12 = I16::MAX * I16::zero();
    assert(res12 == I16::zero());

    let res13 = I16::MIN * I16::zero();
    assert(res13 == I16::zero());

    let res14 = I16::zero() * I16::zero();
    assert(res14 == I16::zero());
}

#[test(should_revert)]
fn revert_signed_i16_mul() {
    let max = I16::MAX;
    let two = I16::try_from(2u16).unwrap();

    let _ = max * two;
}

#[test(should_revert)]
fn revert_signed_i16_mul_negatice() {
    let max = I16::MAX;
    let two = I16::neg_try_from(2u16).unwrap();

    let _ = max * two;
}

#[test(should_revert)]
fn revert_signed_i16_mul_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let max = I16::MAX;
    let two = I16::try_from(2u16).unwrap();

    let _ = max * two;
}

#[test]
fn signed_i16_mul() {
    let _ = disable_panic_on_overflow();

    let max = I16::MAX;
    let two = I16::try_from(2u16).unwrap();

    let result = max * two;
    assert(result == I16::neg_try_from(2).unwrap());
}

#[test]
fn signed_i16_divide() {
    let pos1 = I16::try_from(1).unwrap();
    let pos2 = I16::try_from(2).unwrap();
    let neg1 = I16::neg_try_from(1).unwrap();
    let neg2 = I16::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 / pos2;
    assert(res1 == I16::zero());

    let res2 = pos2 / pos1;
    assert(res2 == I16::try_from(2).unwrap());

    // First positive
    let res3 = pos1 / neg1;
    assert(res3 == I16::neg_try_from(1).unwrap());

    let res4 = pos2 / neg1;
    assert(res4 == I16::neg_try_from(2).unwrap());

    let res5 = pos1 / neg2;
    assert(res5 == I16::zero());

    // Second positive
    let res6 = neg1 / pos1;
    assert(res6 == I16::neg_try_from(1).unwrap());

    let res7 = neg2 / pos1;
    assert(res7 == I16::neg_try_from(2).unwrap());

    let res8 = neg1 / pos2;
    assert(res8 == I16::zero());

    // Both negative
    let res9 = neg1 / neg2;
    assert(res9 == I16::zero());

    let res10 = neg2 / neg1;
    assert(res10 == I16::try_from(2).unwrap());

    // Edge Cases
    let res12 = I16::zero() / I16::MAX;
    assert(res12 == I16::zero());

    let res13 = I16::zero() / I16::MIN;
    assert(res13 == I16::zero());
}

#[test(should_revert)]
fn revert_signed_i16_divide() {
    let zero = I16::zero();
    let one = I16::try_from(1u16).unwrap();

    let _ = one / zero;
}

#[test]
fn signed_i16_divide_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();
    let zero = I16::zero();
    let one = I16::try_from(1u16).unwrap();

    let res = one / zero;
    assert(res == I16::zero());
}

#[test(should_revert)]
fn revert_signed_i16_divide_disable_overflow() {
    let _ = disable_panic_on_overflow();
    let zero = I16::zero();
    let one = I16::try_from(1u16).unwrap();

    let _ = one / zero;
}

#[test]
fn signed_i16_wrapping_neg() {
    let one = I16::try_from(1u16).unwrap();
    let neg_one = I16::neg_try_from(1u16).unwrap();
    let two = I16::try_from(2u16).unwrap();
    let neg_two = I16::neg_try_from(2u16).unwrap();
    let ten = I16::try_from(10u16).unwrap();
    let neg_ten = I16::neg_try_from(10u16).unwrap();
    let twenty_seven = I16::try_from(27u16).unwrap();
    let neg_twenty_seven = I16::neg_try_from(27u16).unwrap();
    let ninty_three = I16::try_from(93u16).unwrap();
    let neg_ninty_three = I16::neg_try_from(93u16).unwrap();
    let zero = I16::try_from(0u16).unwrap();
    let max = I16::MAX;
    let min = I16::MIN;
    let neg_min_plus_one = I16::MIN + I16::try_from(1u16).unwrap();

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

#[test]
fn signed_i16_try_from_u16() {
    let indent: u16 = I16::indent();

    let i16_max_try_from = I16::try_from(indent - 1);
    assert(i16_max_try_from.is_some());
    assert(i16_max_try_from.unwrap() == I16::MAX);

    let i16_min_try_from = I16::try_from(u16::min());
    assert(i16_min_try_from.is_some());
    assert(i16_min_try_from.unwrap() == I16::zero());

    let i16_overflow_try_from = I16::try_from(indent);
    assert(i16_overflow_try_from.is_none());
}

#[test]
fn signed_i16_try_into_u16() {
    let zero = I16::zero();
    let negative = I16::neg_try_from(1).unwrap();
    let max = I16::MAX;
    let indent: u16 = I16::indent();

    let u16_max_try_into: Option<u16> = max.try_into();
    assert(u16_max_try_into.is_some());
    assert(u16_max_try_into.unwrap() == indent - 1);

    let u16_min_try_into: Option<u16> = zero.try_into();
    assert(u16_min_try_into.is_some());
    assert(u16_min_try_into.unwrap() == u16::zero());

    let u16_overflow_try_into: Option<u16> = negative.try_into();
    assert(u16_overflow_try_into.is_none());
}

#[test]
fn signed_i16_u16_try_from() {
    let zero = I16::zero();
    let negative = I16::neg_try_from(1).unwrap();
    let max = I16::MAX;
    let indent: u16 = I16::indent();

    let u16_max_try_from: Option<u16> = u16::try_from(max);
    assert(u16_max_try_from.is_some());
    assert(u16_max_try_from.unwrap() == indent - 1);

    let u16_min_try_from: Option<u16> = u16::try_from(zero);
    assert(u16_min_try_from.is_some());
    assert(u16_min_try_from.unwrap() == u16::zero());

    let u16_overflow_try_from: Option<u16> = u16::try_from(negative);
    assert(u16_overflow_try_from.is_none());
}

#[test]
fn signed_i16_u16_try_into() {
    let indent: u16 = I16::indent();

    let i16_max_try_into: Option<I16> = (indent - 1).try_into();
    assert(i16_max_try_into.is_some());
    assert(i16_max_try_into.unwrap() == I16::MAX);

    let i16_min_try_into: Option<I16> = u16::min().try_into();
    assert(i16_min_try_into.is_some());
    assert(i16_min_try_into.unwrap() == I16::zero());

    let i16_overflow_try_into: Option<I16> = indent.try_into();
    assert(i16_overflow_try_into.is_none());
}
