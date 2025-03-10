library;

use sway_libs::signed_integers::i32::I32;
use std::convert::*;
use std::flags::{disable_panic_on_overflow, disable_panic_on_unsafe_math};

#[test]
fn signed_i32_indent() {
    assert(I32::indent() == 2147483648u32);
}

#[test]
fn signed_i32_eq() {
    let i32_1 = I32::zero();
    let i32_2 = I32::zero();
    let i32_3 = I32::try_from(1u32).unwrap();
    let i32_4 = I32::try_from(1u32).unwrap();
    let i32_5 = I32::MAX;
    let i32_6 = I32::MAX;
    let i32_7 = I32::MIN;
    let i32_8 = I32::MIN;
    let i32_9 = I32::neg_try_from(1u32).unwrap();
    let i32_10 = I32::neg_try_from(1u32).unwrap();

    assert(i32_1 == i32_2);
    assert(i32_3 == i32_4);
    assert(i32_5 == i32_6);
    assert(i32_7 == i32_8);
    assert(i32_9 == i32_10);

    assert(i32_1 != i32_3);
    assert(i32_1 != i32_5);
    assert(i32_1 != i32_7);
    assert(i32_1 != i32_9);

    assert(i32_3 != i32_5);
    assert(i32_3 != i32_7);
    assert(i32_3 != i32_9);

    assert(i32_5 != i32_7);
    assert(i32_5 != i32_9);

    assert(i32_7 != i32_9);
}

#[test]
fn signed_i32_ord() {
    let i32_1 = I32::zero();
    let i32_2 = I32::zero();
    let i32_3 = I32::try_from(1u32).unwrap();
    let i32_4 = I32::try_from(1u32).unwrap();
    let i32_5 = I32::MAX;
    let i32_6 = I32::MAX;
    let i32_7 = I32::MIN;
    let i32_8 = I32::MIN;
    let i32_9 = I32::neg_try_from(1u32).unwrap();
    let i32_10 = I32::neg_try_from(1u32).unwrap();

    assert(!(i32_1 > i32_2));
    assert(!(i32_3 > i32_4));
    assert(!(i32_5 > i32_6));
    assert(!(i32_7 > i32_8));
    assert(!(i32_9 > i32_10));

    assert(i32_1 >= i32_2);
    assert(i32_3 >= i32_4);
    assert(i32_5 >= i32_6);
    assert(i32_7 >= i32_8);
    assert(i32_9 >= i32_10);

    assert(!(i32_1 < i32_2));
    assert(!(i32_3 < i32_4));
    assert(!(i32_5 < i32_6));
    assert(!(i32_7 < i32_8));
    assert(!(i32_9 < i32_10));

    assert(i32_1 <= i32_2);
    assert(i32_3 <= i32_4);
    assert(i32_5 <= i32_6);
    assert(i32_7 <= i32_8);
    assert(i32_9 <= i32_10);

    assert(i32_1 < i32_3);
    assert(i32_1 < i32_5);
    assert(i32_3 < i32_5);
    assert(i32_7 < i32_5);
    assert(i32_9 < i32_5);
    assert(i32_9 < i32_1);
    assert(i32_9 < i32_3);
    assert(i32_7 < i32_9);

    assert(i32_5 > i32_1);
    assert(i32_5 > i32_3);
    assert(i32_5 > i32_7);
    assert(i32_5 > i32_9);
    assert(i32_3 > i32_1);
    assert(i32_3 > i32_7);
    assert(i32_3 > i32_9);
    assert(i32_9 > i32_7);
}

#[test]
fn signed_i32_total_ord() {
    let zero = I32::zero();
    let one = I32::try_from(1u32).unwrap();
    let max_1 = I32::MAX;
    let min_1 = I32::MIN;
    let neg_one_1 = I32::neg_try_from(1u32).unwrap();

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
fn signed_i32_bits() {
    assert(I32::bits() == 32);
}

#[test]
fn signed_i32_from_uint() {
    let zero = I32::from_uint(0u32);
    let one = I32::from_uint(1u32);
    let max = I32::from_uint(u32::max());

    assert(zero.underlying() == 0u32);
    assert(one.underlying() == 1u32);
    assert(max.underlying() == u32::max());
}

#[test]
fn signed_i32_max_constant() {
    let max = I32::MAX;
    assert(max.underlying() == u32::max());
}

#[test]
fn signed_i32_min_constant() {
    let max = I32::MIN;
    assert(max.underlying() == u32::min());
}

#[test]
fn signed_i32_neg_try_from() {
    let indent = I32::indent();

    let neg_try_from_zero = I32::neg_try_from(u32::min());
    assert(neg_try_from_zero.is_some());
    assert(neg_try_from_zero.unwrap() == I32::zero());

    let neg_try_from_one = I32::neg_try_from(1u32);
    assert(neg_try_from_one.is_some());
    assert(neg_try_from_one.unwrap().underlying() == I32::indent() - 1u32);

    let neg_try_from_max = I32::neg_try_from(indent);
    assert(neg_try_from_max.is_some());
    assert(neg_try_from_max.unwrap().underlying() == u32::min());

    let neg_try_from_overflow = I32::neg_try_from(indent + 1u32);
    assert(neg_try_from_overflow.is_none());
}

#[test]
fn signed_i32_new() {
    let new = I32::new();

    assert(new.underlying() == 2147483648u32);
}

#[test]
fn signed_i32_zero() {
    let zero = I32::zero();

    assert(zero.underlying() == 2147483648u32);
}

#[test]
fn signed_i32_is_zero() {
    let zero = I32::zero();
    assert(zero.is_zero());

    let other_1 = I32::from_uint(1);
    let other_2 = I32::MAX;
    assert(!other_1.is_zero());
    assert(!other_2.is_zero());
}

#[test]
fn signed_i32_underlying() {
    let zero = I32::from_uint(0u32);
    let one = I32::from_uint(1u32);
    let max = I32::from_uint(u32::max());
    let indent = I32::zero();

    assert(zero.underlying() == 0u32);
    assert(one.underlying() == 1u32);
    assert(max.underlying() == u32::max());
    assert(indent.underlying() == 2147483648u32);
}

#[test]
fn signed_i32_add() {
    let pos1 = I32::try_from(1).unwrap();
    let pos2 = I32::try_from(2).unwrap();
    let neg1 = I32::neg_try_from(1).unwrap();
    let neg2 = I32::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 + pos2;
    assert(res1 == I32::try_from(3).unwrap());

    let res2 = pos2 + pos1;
    assert(res2 == I32::try_from(3).unwrap());

    // First positive
    let res3 = pos1 + neg1;
    assert(res3 == I32::zero());

    let res4 = pos2 + neg1;
    assert(res4 == I32::try_from(1).unwrap());

    let res5 = pos1 + neg2;
    assert(res5 == I32::neg_try_from(1).unwrap());

    // Second positive
    let res6 = neg1 + pos1;
    assert(res6 == I32::zero());

    let res7 = neg2 + pos1;
    assert(res7 == I32::neg_try_from(1).unwrap());

    let res8 = neg1 + pos2;
    assert(res8 == I32::try_from(1).unwrap());

    // Both negative
    let res9 = neg1 + neg2;
    assert(res9 == I32::neg_try_from(3).unwrap());

    let res10 = neg2 + neg1;
    assert(res10 == I32::neg_try_from(3).unwrap());

    // Edge Cases
    let res11 = I32::MIN + I32::MAX;
    assert(res11 == I32::neg_try_from(1).unwrap());

    let res12 = I32::MAX + I32::zero();
    assert(res12 == I32::MAX);

    let res13 = I32::MIN + I32::zero();
    assert(res13 == I32::MIN);

    let res14 = I32::zero() + I32::zero();
    assert(res14 == I32::zero());
}

#[test(should_revert)]
fn revert_signed_i32_add() {
    let one = I32::try_from(1u32).unwrap();
    let max = I32::MAX;

    let _ = max + one;
}

#[test(should_revert)]
fn revert_signed_i32_add_negative() {
    let neg_one = I32::neg_try_from(1u32).unwrap();
    let min = I32::MIN;

    let _ = min + neg_one;
}

#[test(should_revert)]
fn revert_signed_i32_add_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let one = I32::try_from(1u32).unwrap();
    let max = I32::MAX;

    let _ = max + one;
}

#[test]
fn signed_i32_add_overflow() {
    let _ = disable_panic_on_overflow();

    let one = I32::try_from(1u32).unwrap();
    let max = I32::MAX;

    assert(max + one == I32::MIN);
}

#[test]
fn signed_i32_subtract() {
    let pos1 = I32::try_from(1).unwrap();
    let pos2 = I32::try_from(2).unwrap();
    let neg1 = I32::neg_try_from(1).unwrap();
    let neg2 = I32::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 - pos2;
    assert(res1 == I32::neg_try_from(1).unwrap());

    let res2 = pos2 - pos1;
    assert(res2 == I32::try_from(1).unwrap());

    // First positive
    let res3 = pos1 - neg1;
    assert(res3 == I32::try_from(2).unwrap());

    let res4 = pos2 - neg1;
    assert(res4 == I32::try_from(3).unwrap());

    // Second positive
    let res5 = neg1 - pos1;
    assert(res5 == I32::neg_try_from(2).unwrap());

    let res6 = neg2 - pos1;
    assert(res6 == I32::neg_try_from(3).unwrap());

    // Both negative
    let res7 = neg1 - neg2;
    assert(res7 == I32::try_from(1).unwrap());

    let res8 = neg2 - neg1;
    assert(res8 == I32::neg_try_from(1).unwrap());

    // Edge Cases
    let res11 = I32::zero() - (I32::MIN + I32::try_from(1).unwrap());
    assert(res11 == I32::MAX);

    let res12 = I32::MAX - I32::zero();
    assert(res12 == I32::MAX);

    let res13 = I32::MIN - I32::zero();
    assert(res13 == I32::MIN);

    let res14 = I32::zero() - I32::zero();
    assert(res14 == I32::zero());
}

#[test(should_revert)]
fn revert_signed_i32_sub() {
    let min = I32::MIN;
    let one = I32::try_from(1u32).unwrap();

    let _ = min - one;
}

#[test(should_revert)]
fn revert_signed_i32_sub_negative() {
    let max = I32::MAX;
    let neg_one = I32::neg_try_from(1u32).unwrap();

    let _ = max - neg_one;
}

#[test(should_revert)]
fn revert_signed_i32_sub_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let min = I32::MIN;
    let one = I32::try_from(1u32).unwrap();

    let _ = min - one;
}

#[test]
fn signed_i32_sub_underflow() {
    let _ = disable_panic_on_overflow();

    let min = I32::MIN;
    let one = I32::try_from(1u32).unwrap();

    let result = min - one;
    assert(result == I32::MAX);
}

#[test]
fn signed_i32_multiply() {
    let pos1 = I32::try_from(1).unwrap();
    let pos2 = I32::try_from(2).unwrap();
    let neg1 = I32::neg_try_from(1).unwrap();
    let neg2 = I32::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 * pos2;
    assert(res1 == I32::try_from(2).unwrap());

    let res2 = pos2 * pos1;
    assert(res2 == I32::try_from(2).unwrap());

    // First positive
    let res3 = pos1 * neg1;
    assert(res3 == I32::neg_try_from(1).unwrap());

    let res4 = pos2 * neg1;
    assert(res4 == I32::neg_try_from(2).unwrap());

    let res5 = pos1 * neg2;
    assert(res5 == I32::neg_try_from(2).unwrap());

    // Second positive
    let res6 = neg1 * pos1;
    assert(res6 == I32::neg_try_from(1).unwrap());

    let res7 = neg2 * pos1;
    assert(res7 == I32::neg_try_from(2).unwrap());

    let res8 = neg1 * pos2;
    assert(res8 == I32::neg_try_from(2).unwrap());

    // Both negative
    let res9 = neg1 * neg2;
    assert(res9 == I32::try_from(2).unwrap());

    let res10 = neg2 * neg1;
    assert(res10 == I32::try_from(2).unwrap());

    // Edge Cases
    let res12 = I32::MAX * I32::zero();
    assert(res12 == I32::zero());

    let res13 = I32::MIN * I32::zero();
    assert(res13 == I32::zero());

    let res14 = I32::zero() * I32::zero();
    assert(res14 == I32::zero());
}

#[test(should_revert)]
fn revert_signed_i32_mul() {
    let max = I32::MAX;
    let two = I32::try_from(2u32).unwrap();

    let _ = max * two;
}

#[test(should_revert)]
fn revert_signed_i32_mul_negatice() {
    let max = I32::MAX;
    let two = I32::neg_try_from(2u32).unwrap();

    let _ = max * two;
}

#[test(should_revert)]
fn revert_signed_i32_mul_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let max = I32::MAX;
    let two = I32::try_from(2u32).unwrap();

    let _ = max * two;
}

#[test]
fn signed_i32_mul() {
    let _ = disable_panic_on_overflow();

    let max = I32::MAX;
    let two = I32::try_from(2u32).unwrap();

    let result = max * two;
    assert(result == I32::neg_try_from(2).unwrap());
}

#[test]
fn signed_i32_divide() {
    let pos1 = I32::try_from(1).unwrap();
    let pos2 = I32::try_from(2).unwrap();
    let neg1 = I32::neg_try_from(1).unwrap();
    let neg2 = I32::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 / pos2;
    assert(res1 == I32::zero());

    let res2 = pos2 / pos1;
    assert(res2 == I32::try_from(2).unwrap());

    // First positive
    let res3 = pos1 / neg1;
    assert(res3 == I32::neg_try_from(1).unwrap());

    let res4 = pos2 / neg1;
    assert(res4 == I32::neg_try_from(2).unwrap());

    let res5 = pos1 / neg2;
    assert(res5 == I32::zero());

    // Second positive
    let res6 = neg1 / pos1;
    assert(res6 == I32::neg_try_from(1).unwrap());

    let res7 = neg2 / pos1;
    assert(res7 == I32::neg_try_from(2).unwrap());

    let res8 = neg1 / pos2;
    assert(res8 == I32::zero());

    // Both negative
    let res9 = neg1 / neg2;
    assert(res9 == I32::zero());

    let res10 = neg2 / neg1;
    assert(res10 == I32::try_from(2).unwrap());

    // Edge Cases
    let res12 = I32::zero() / I32::MAX;
    assert(res12 == I32::zero());

    let res13 = I32::zero() / I32::MIN;
    assert(res13 == I32::zero());
}

#[test(should_revert)]
fn revert_signed_i32_divide() {
    let zero = I32::zero();
    let one = I32::try_from(1u32).unwrap();

    let _ = one / zero;
}

#[test]
fn signed_i32_divide_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();
    let zero = I32::zero();
    let one = I32::try_from(1u32).unwrap();

    let res = one / zero;
    assert(res == I32::zero());
}

#[test(should_revert)]
fn revert_signed_i32_divide_disable_overflow() {
    let _ = disable_panic_on_overflow();
    let zero = I32::zero();
    let one = I32::try_from(1u32).unwrap();

    let _ = one / zero;
}

#[test]
fn signed_i32_wrapping_neg() {
    let one = I32::try_from(1u32).unwrap();
    let neg_one = I32::neg_try_from(1u32).unwrap();
    let two = I32::try_from(2u32).unwrap();
    let neg_two = I32::neg_try_from(2u32).unwrap();
    let ten = I32::try_from(10u32).unwrap();
    let neg_ten = I32::neg_try_from(10u32).unwrap();
    let twenty_seven = I32::try_from(27u32).unwrap();
    let neg_twenty_seven = I32::neg_try_from(27u32).unwrap();
    let ninty_three = I32::try_from(93u32).unwrap();
    let neg_ninty_three = I32::neg_try_from(93u32).unwrap();
    let zero = I32::try_from(0u32).unwrap();
    let max = I32::MAX;
    let min = I32::MIN;
    let neg_min_plus_one = I32::MIN + I32::try_from(1u32).unwrap();

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
fn signed_i32_try_from_u32() {
    let indent: u32 = I32::indent();

    let i32_max_try_from = I32::try_from(indent - 1);
    assert(i32_max_try_from.is_some());
    assert(i32_max_try_from.unwrap() == I32::MAX);

    let i32_min_try_from = I32::try_from(u32::min());
    assert(i32_min_try_from.is_some());
    assert(i32_min_try_from.unwrap() == I32::zero());

    let i32_overflow_try_from = I32::try_from(indent);
    assert(i32_overflow_try_from.is_none());
}

#[test]
fn signed_i32_try_into_u32() {
    let zero = I32::zero();
    let negative = I32::neg_try_from(1).unwrap();
    let max = I32::MAX;
    let indent: u32 = I32::indent();

    let u32_max_try_into: Option<u32> = <I32 as TryInto<u32>>::try_into(max);
    assert(u32_max_try_into.is_some());
    assert(u32_max_try_into.unwrap() == indent - 1);

    let u32_min_try_into: Option<u32> = <I32 as TryInto<u32>>::try_into(zero);
    assert(u32_min_try_into.is_some());
    assert(u32_min_try_into.unwrap() == u32::zero());

    let u32_overflow_try_into: Option<u32> = <I32 as TryInto<u32>>::try_into(negative);
    assert(u32_overflow_try_into.is_none());
}

#[test]
fn signed_i32_u32_try_from() {
    let zero = I32::zero();
    let negative = I32::neg_try_from(1).unwrap();
    let max = I32::MAX;
    let indent: u32 = I32::indent();

    let u32_max_try_from: Option<u32> = u32::try_from(max);
    assert(u32_max_try_from.is_some());
    assert(u32_max_try_from.unwrap() == indent - 1);

    let u32_min_try_from: Option<u32> = u32::try_from(zero);
    assert(u32_min_try_from.is_some());
    assert(u32_min_try_from.unwrap() == u32::zero());

    let u32_overflow_try_from: Option<u32> = u32::try_from(negative);
    assert(u32_overflow_try_from.is_none());
}

#[test]
fn signed_i32_u32_try_into() {
    let indent: u32 = I32::indent();

    let i32_max_try_into: Option<I32> = <u32 as TryInto<I32>>::try_into((indent - 1));
    assert(i32_max_try_into.is_some());
    assert(i32_max_try_into.unwrap() == I32::MAX);

    let i32_min_try_into: Option<I32> = <u32 as TryInto<I32>>::try_into(u32::min());
    assert(i32_min_try_into.is_some());
    assert(i32_min_try_into.unwrap() == I32::zero());

    let i32_overflow_try_into: Option<I32> = <u32 as TryInto<I32>>::try_into(indent);
    assert(i32_overflow_try_into.is_none());
}
