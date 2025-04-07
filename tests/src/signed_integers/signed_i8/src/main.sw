library;

use sway_libs::signed_integers::i8::I8;
use std::convert::*;
use std::flags::{disable_panic_on_overflow, disable_panic_on_unsafe_math};

#[test]
fn signed_i8_indent() {
    assert(I8::indent() == 128u8);
}

#[test]
fn signed_i8_eq() {
    let i8_1 = I8::zero();
    let i8_2 = I8::zero();
    let i8_3 = I8::try_from(1u8).unwrap();
    let i8_4 = I8::try_from(1u8).unwrap();
    let i8_5 = I8::MAX;
    let i8_6 = I8::MAX;
    let i8_7 = I8::MIN;
    let i8_8 = I8::MIN;
    let i8_9 = I8::neg_try_from(1u8).unwrap();
    let i8_10 = I8::neg_try_from(1u8).unwrap();

    assert(i8_1 == i8_2);
    assert(i8_3 == i8_4);
    assert(i8_5 == i8_6);
    assert(i8_7 == i8_8);
    assert(i8_9 == i8_10);

    assert(i8_1 != i8_3);
    assert(i8_1 != i8_5);
    assert(i8_1 != i8_7);
    assert(i8_1 != i8_9);

    assert(i8_3 != i8_5);
    assert(i8_3 != i8_7);
    assert(i8_3 != i8_9);

    assert(i8_5 != i8_7);
    assert(i8_5 != i8_9);

    assert(i8_7 != i8_9);
}

#[test]
fn signed_i8_ord() {
    let i8_1 = I8::zero();
    let i8_2 = I8::zero();
    let i8_3 = I8::try_from(1u8).unwrap();
    let i8_4 = I8::try_from(1u8).unwrap();
    let i8_5 = I8::MAX;
    let i8_6 = I8::MAX;
    let i8_7 = I8::MIN;
    let i8_8 = I8::MIN;
    let i8_9 = I8::neg_try_from(1u8).unwrap();
    let i8_10 = I8::neg_try_from(1u8).unwrap();

    assert(!(i8_1 > i8_2));
    assert(!(i8_3 > i8_4));
    assert(!(i8_5 > i8_6));
    assert(!(i8_7 > i8_8));
    assert(!(i8_9 > i8_10));

    assert(i8_1 >= i8_2);
    assert(i8_3 >= i8_4);
    assert(i8_5 >= i8_6);
    assert(i8_7 >= i8_8);
    assert(i8_9 >= i8_10);

    assert(!(i8_1 < i8_2));
    assert(!(i8_3 < i8_4));
    assert(!(i8_5 < i8_6));
    assert(!(i8_7 < i8_8));
    assert(!(i8_9 < i8_10));

    assert(i8_1 <= i8_2);
    assert(i8_3 <= i8_4);
    assert(i8_5 <= i8_6);
    assert(i8_7 <= i8_8);
    assert(i8_9 <= i8_10);

    assert(i8_1 < i8_3);
    assert(i8_1 < i8_5);
    assert(i8_3 < i8_5);
    assert(i8_7 < i8_5);
    assert(i8_9 < i8_5);
    assert(i8_9 < i8_1);
    assert(i8_9 < i8_3);
    assert(i8_7 < i8_9);

    assert(i8_5 > i8_1);
    assert(i8_5 > i8_3);
    assert(i8_5 > i8_7);
    assert(i8_5 > i8_9);
    assert(i8_3 > i8_1);
    assert(i8_3 > i8_7);
    assert(i8_3 > i8_9);
    assert(i8_9 > i8_7);
}

#[test]
fn signed_i8_total_ord() {
    let zero = I8::zero();
    let one = I8::try_from(1u8).unwrap();
    let max_1 = I8::MAX;
    let min_1 = I8::MIN;
    let neg_one_1 = I8::neg_try_from(1u8).unwrap();

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
fn signed_i8_bits() {
    assert(I8::bits() == 8);
}

#[test]
fn signed_i8_from_uint() {
    let zero = I8::from_uint(0u8);
    let one = I8::from_uint(1u8);
    let max = I8::from_uint(u8::max());

    assert(zero.underlying() == 0u8);
    assert(one.underlying() == 1u8);
    assert(max.underlying() == u8::max());
}

#[test]
fn signed_i8_max_constant() {
    let max = I8::MAX;
    assert(max.underlying() == u8::max());
}

#[test]
fn signed_i8_min_constant() {
    let max = I8::MIN;
    assert(max.underlying() == u8::min());
}

#[test]
fn signed_i8_neg_try_from() {
    let indent = I8::indent();

    let neg_try_from_zero = I8::neg_try_from(u8::min());
    assert(neg_try_from_zero.is_some());
    assert(neg_try_from_zero.unwrap() == I8::zero());

    let neg_try_from_one = I8::neg_try_from(1u8);
    assert(neg_try_from_one.is_some());
    assert(neg_try_from_one.unwrap().underlying() == I8::indent() - 1u8);

    let neg_try_from_max = I8::neg_try_from(indent);
    assert(neg_try_from_max.is_some());
    assert(neg_try_from_max.unwrap().underlying() == u8::min());

    let neg_try_from_overflow = I8::neg_try_from(indent + 1u8);
    assert(neg_try_from_overflow.is_none());
}

#[test]
fn signed_i8_new() {
    let new = I8::new();

    assert(new.underlying() == 128u8);
}

#[test]
fn signed_i8_zero() {
    let zero = I8::zero();

    assert(zero.underlying() == 128u8);
}

#[test]
fn signed_i8_is_zero() {
    let zero = I8::zero();
    assert(zero.is_zero());

    let other_1 = I8::from_uint(1);
    let other_2 = I8::MAX;
    assert(!other_1.is_zero());
    assert(!other_2.is_zero());
}

#[test]
fn signed_i8_underlying() {
    let zero = I8::from_uint(0u8);
    let one = I8::from_uint(1u8);
    let max = I8::from_uint(u8::max());
    let indent = I8::zero();

    assert(zero.underlying() == 0u8);
    assert(one.underlying() == 1u8);
    assert(max.underlying() == u8::max());
    assert(indent.underlying() == 128u8);
}

#[test]
fn signed_i8_add() {
    let pos1 = I8::try_from(1).unwrap();
    let pos2 = I8::try_from(2).unwrap();
    let neg1 = I8::neg_try_from(1).unwrap();
    let neg2 = I8::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 + pos2;
    assert(res1 == I8::try_from(3).unwrap());

    let res2 = pos2 + pos1;
    assert(res2 == I8::try_from(3).unwrap());

    // First positive
    let res3 = pos1 + neg1;
    assert(res3 == I8::zero());

    let res4 = pos2 + neg1;
    assert(res4 == I8::try_from(1).unwrap());

    let res5 = pos1 + neg2;
    assert(res5 == I8::neg_try_from(1).unwrap());

    // Second positive
    let res6 = neg1 + pos1;
    assert(res6 == I8::zero());

    let res7 = neg2 + pos1;
    assert(res7 == I8::neg_try_from(1).unwrap());

    let res8 = neg1 + pos2;
    assert(res8 == I8::try_from(1).unwrap());

    // Both negative
    let res9 = neg1 + neg2;
    assert(res9 == I8::neg_try_from(3).unwrap());

    let res10 = neg2 + neg1;
    assert(res10 == I8::neg_try_from(3).unwrap());

    // Edge Cases
    let res11 = I8::MIN + I8::MAX;
    assert(res11 == I8::neg_try_from(1).unwrap());

    let res12 = I8::MAX + I8::zero();
    assert(res12 == I8::MAX);

    let res13 = I8::MIN + I8::zero();
    assert(res13 == I8::MIN);

    let res14 = I8::zero() + I8::zero();
    assert(res14 == I8::zero());
}

#[test(should_revert)]
fn revert_signed_i8_add() {
    let one = I8::try_from(1u8).unwrap();
    let max = I8::MAX;

    let _ = max + one;
}

#[test(should_revert)]
fn revert_signed_i8_add_negative() {
    let neg_one = I8::neg_try_from(1u8).unwrap();
    let min = I8::MIN;

    let _ = min + neg_one;
}

#[test(should_revert)]
fn revert_signed_i8_add_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let one = I8::try_from(1u8).unwrap();
    let max = I8::MAX;

    let _ = max + one;
}

#[test]
fn signed_i8_add_overflow() {
    let _ = disable_panic_on_overflow();

    let one = I8::try_from(1u8).unwrap();
    let max = I8::MAX;

    assert(max + one == I8::MIN);
}

#[test]
fn signed_i8_subtract() {
    let pos1 = I8::try_from(1).unwrap();
    let pos2 = I8::try_from(2).unwrap();
    let neg1 = I8::neg_try_from(1).unwrap();
    let neg2 = I8::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 - pos2;
    assert(res1 == I8::neg_try_from(1).unwrap());

    let res2 = pos2 - pos1;
    assert(res2 == I8::try_from(1).unwrap());

    // First positive
    let res3 = pos1 - neg1;
    assert(res3 == I8::try_from(2).unwrap());

    let res4 = pos2 - neg1;
    assert(res4 == I8::try_from(3).unwrap());

    // Second positive
    let res5 = neg1 - pos1;
    assert(res5 == I8::neg_try_from(2).unwrap());

    let res6 = neg2 - pos1;
    assert(res6 == I8::neg_try_from(3).unwrap());

    // Both negative
    let res7 = neg1 - neg2;
    assert(res7 == I8::try_from(1).unwrap());

    let res8 = neg2 - neg1;
    assert(res8 == I8::neg_try_from(1).unwrap());

    // Edge Cases
    let res11 = I8::zero() - (I8::MIN + I8::try_from(1).unwrap());
    assert(res11 == I8::MAX);

    let res12 = I8::MAX - I8::zero();
    assert(res12 == I8::MAX);

    let res13 = I8::MIN - I8::zero();
    assert(res13 == I8::MIN);

    let res14 = I8::zero() - I8::zero();
    assert(res14 == I8::zero());
}

#[test(should_revert)]
fn revert_signed_i8_sub() {
    let min = I8::MIN;
    let one = I8::try_from(1u8).unwrap();

    let _ = min - one;
}

#[test(should_revert)]
fn revert_signed_i8_sub_negative() {
    let max = I8::MAX;
    let neg_one = I8::neg_try_from(1u8).unwrap();

    let _ = max - neg_one;
}

#[test(should_revert)]
fn revert_signed_i8_sub_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let min = I8::MIN;
    let one = I8::try_from(1u8).unwrap();

    let _ = min - one;
}

#[test]
fn signed_i8_sub_underflow() {
    let _ = disable_panic_on_overflow();

    let min = I8::MIN;
    let one = I8::try_from(1u8).unwrap();

    let result = min - one;
    assert(result == I8::MAX);
}

#[test]
fn signed_i8_multiply() {
    let pos1 = I8::try_from(1).unwrap();
    let pos2 = I8::try_from(2).unwrap();
    let neg1 = I8::neg_try_from(1).unwrap();
    let neg2 = I8::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 * pos2;
    assert(res1 == I8::try_from(2).unwrap());

    let res2 = pos2 * pos1;
    assert(res2 == I8::try_from(2).unwrap());

    // First positive
    let res3 = pos1 * neg1;
    assert(res3 == I8::neg_try_from(1).unwrap());

    let res4 = pos2 * neg1;
    assert(res4 == I8::neg_try_from(2).unwrap());

    let res5 = pos1 * neg2;
    assert(res5 == I8::neg_try_from(2).unwrap());

    // Second positive
    let res6 = neg1 * pos1;
    assert(res6 == I8::neg_try_from(1).unwrap());

    let res7 = neg2 * pos1;
    assert(res7 == I8::neg_try_from(2).unwrap());

    let res8 = neg1 * pos2;
    assert(res8 == I8::neg_try_from(2).unwrap());

    // Both negative
    let res9 = neg1 * neg2;
    assert(res9 == I8::try_from(2).unwrap());

    let res10 = neg2 * neg1;
    assert(res10 == I8::try_from(2).unwrap());

    // Edge Cases
    let res12 = I8::MAX * I8::zero();
    assert(res12 == I8::zero());

    let res13 = I8::MIN * I8::zero();
    assert(res13 == I8::zero());

    let res14 = I8::zero() * I8::zero();
    assert(res14 == I8::zero());
}

#[test(should_revert)]
fn revert_signed_i8_mul() {
    let max = I8::MAX;
    let two = I8::try_from(2u8).unwrap();

    let _ = max * two;
}

#[test(should_revert)]
fn revert_signed_i8_mul_negatice() {
    let max = I8::MAX;
    let two = I8::neg_try_from(2u8).unwrap();

    let _ = max * two;
}

#[test(should_revert)]
fn revert_signed_i8_mul_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let max = I8::MAX;
    let two = I8::try_from(2u8).unwrap();

    let _ = max * two;
}

#[test]
fn signed_i8_mul() {
    let _ = disable_panic_on_overflow();

    let max = I8::MAX;
    let two = I8::try_from(2u8).unwrap();

    let result = max * two;
    assert(result == I8::neg_try_from(2).unwrap());
}

#[test]
fn signed_i8_divide() {
    let pos1 = I8::try_from(1).unwrap();
    let pos2 = I8::try_from(2).unwrap();
    let neg1 = I8::neg_try_from(1).unwrap();
    let neg2 = I8::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 / pos2;
    assert(res1 == I8::zero());

    let res2 = pos2 / pos1;
    assert(res2 == I8::try_from(2).unwrap());

    // First positive
    let res3 = pos1 / neg1;
    assert(res3 == I8::neg_try_from(1).unwrap());

    let res4 = pos2 / neg1;
    assert(res4 == I8::neg_try_from(2).unwrap());

    let res5 = pos1 / neg2;
    assert(res5 == I8::zero());

    // Second positive
    let res6 = neg1 / pos1;
    assert(res6 == I8::neg_try_from(1).unwrap());

    let res7 = neg2 / pos1;
    assert(res7 == I8::neg_try_from(2).unwrap());

    let res8 = neg1 / pos2;
    assert(res8 == I8::zero());

    // Both negative
    let res9 = neg1 / neg2;
    assert(res9 == I8::zero());

    let res10 = neg2 / neg1;
    assert(res10 == I8::try_from(2).unwrap());

    // Edge Cases
    let res12 = I8::zero() / I8::MAX;
    assert(res12 == I8::zero());

    let res13 = I8::zero() / I8::MIN;
    assert(res13 == I8::zero());
}

#[test(should_revert)]
fn revert_signed_i8_divide() {
    let zero = I8::zero();
    let one = I8::try_from(1u8).unwrap();

    let _ = one / zero;
}

#[test]
fn signed_i8_divide_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();
    let zero = I8::zero();
    let one = I8::try_from(1u8).unwrap();

    let res = one / zero;
    assert(res == I8::zero());
}

#[test(should_revert)]
fn revert_signed_i8_divide_disable_overflow() {
    let _ = disable_panic_on_overflow();
    let zero = I8::zero();
    let one = I8::try_from(1u8).unwrap();

    let _ = one / zero;
}

#[test]
fn signed_i8_wrapping_neg() {
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
}

#[test]
fn signed_i8_try_from_u8() {
    let indent: u8 = I8::indent();

    let i8_max_try_from = I8::try_from(indent - 1);
    assert(i8_max_try_from.is_some());
    assert(i8_max_try_from.unwrap() == I8::MAX);

    let i8_min_try_from = I8::try_from(u8::min());
    assert(i8_min_try_from.is_some());
    assert(i8_min_try_from.unwrap() == I8::zero());

    let i8_overflow_try_from = I8::try_from(indent);
    assert(i8_overflow_try_from.is_none());
}

#[test]
fn signed_i8_try_into_u8() {
    let zero = I8::zero();
    let negative = I8::neg_try_from(1).unwrap();
    let max = I8::MAX;
    let indent: u8 = I8::indent();

    let u8_max_try_into: Option<u8> = <I8 as TryInto<u8>>::try_into(max);
    assert(u8_max_try_into.is_some());
    assert(u8_max_try_into.unwrap() == indent - 1);

    let u8_min_try_into: Option<u8> = <I8 as TryInto<u8>>::try_into(zero);
    assert(u8_min_try_into.is_some());
    assert(u8_min_try_into.unwrap() == u8::zero());

    let u8_overflow_try_into: Option<u8> = <I8 as TryInto<u8>>::try_into(negative);
    assert(u8_overflow_try_into.is_none());
}

#[test]
fn signed_i8_u8_try_from() {
    let zero = I8::zero();
    let negative = I8::neg_try_from(1).unwrap();
    let max = I8::MAX;
    let indent: u8 = I8::indent();

    let u8_max_try_from: Option<u8> = u8::try_from(max);
    assert(u8_max_try_from.is_some());
    assert(u8_max_try_from.unwrap() == indent - 1);

    let u8_min_try_from: Option<u8> = u8::try_from(zero);
    assert(u8_min_try_from.is_some());
    assert(u8_min_try_from.unwrap() == u8::zero());

    let u8_overflow_try_from: Option<u8> = u8::try_from(negative);
    assert(u8_overflow_try_from.is_none());
}

#[test]
fn signed_i8_u8_try_into() {
    let indent: u8 = I8::indent();

    let i8_max_try_into: Option<I8> = <u8 as TryInto<I8>>::try_into((indent - 1));
    assert(i8_max_try_into.is_some());
    assert(i8_max_try_into.unwrap() == I8::MAX);

    let i8_min_try_into: Option<I8> = <u8 as TryInto<I8>>::try_into(u8::min());
    assert(i8_min_try_into.is_some());
    assert(i8_min_try_into.unwrap() == I8::zero());

    let i8_overflow_try_into: Option<I8> = <u8 as TryInto<I8>>::try_into(indent);
    assert(i8_overflow_try_into.is_none());
}
