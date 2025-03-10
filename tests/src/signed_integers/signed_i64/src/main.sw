library;

use sway_libs::signed_integers::i64::I64;
use std::convert::*;
use std::flags::{disable_panic_on_overflow, disable_panic_on_unsafe_math};

#[test]
fn signed_i64_indent() {
    assert(I64::indent() == 9223372036854775808u64);
}

#[test]
fn signed_i64_eq() {
    let i64_1 = I64::zero();
    let i64_2 = I64::zero();
    let i64_3 = I64::try_from(1u64).unwrap();
    let i64_4 = I64::try_from(1u64).unwrap();
    let i64_5 = I64::MAX;
    let i64_6 = I64::MAX;
    let i64_7 = I64::MIN;
    let i64_8 = I64::MIN;
    let i64_9 = I64::neg_try_from(1u64).unwrap();
    let i64_10 = I64::neg_try_from(1u64).unwrap();

    assert(i64_1 == i64_2);
    assert(i64_3 == i64_4);
    assert(i64_5 == i64_6);
    assert(i64_7 == i64_8);
    assert(i64_9 == i64_10);

    assert(i64_1 != i64_3);
    assert(i64_1 != i64_5);
    assert(i64_1 != i64_7);
    assert(i64_1 != i64_9);

    assert(i64_3 != i64_5);
    assert(i64_3 != i64_7);
    assert(i64_3 != i64_9);

    assert(i64_5 != i64_7);
    assert(i64_5 != i64_9);

    assert(i64_7 != i64_9);
}

#[test]
fn signed_i64_ord() {
    let i64_1 = I64::zero();
    let i64_2 = I64::zero();
    let i64_3 = I64::try_from(1u64).unwrap();
    let i64_4 = I64::try_from(1u64).unwrap();
    let i64_5 = I64::MAX;
    let i64_6 = I64::MAX;
    let i64_7 = I64::MIN;
    let i64_8 = I64::MIN;
    let i64_9 = I64::neg_try_from(1u64).unwrap();
    let i64_10 = I64::neg_try_from(1u64).unwrap();

    assert(!(i64_1 > i64_2));
    assert(!(i64_3 > i64_4));
    assert(!(i64_5 > i64_6));
    assert(!(i64_7 > i64_8));
    assert(!(i64_9 > i64_10));

    assert(i64_1 >= i64_2);
    assert(i64_3 >= i64_4);
    assert(i64_5 >= i64_6);
    assert(i64_7 >= i64_8);
    assert(i64_9 >= i64_10);

    assert(!(i64_1 < i64_2));
    assert(!(i64_3 < i64_4));
    assert(!(i64_5 < i64_6));
    assert(!(i64_7 < i64_8));
    assert(!(i64_9 < i64_10));

    assert(i64_1 <= i64_2);
    assert(i64_3 <= i64_4);
    assert(i64_5 <= i64_6);
    assert(i64_7 <= i64_8);
    assert(i64_9 <= i64_10);

    assert(i64_1 < i64_3);
    assert(i64_1 < i64_5);
    assert(i64_3 < i64_5);
    assert(i64_7 < i64_5);
    assert(i64_9 < i64_5);
    assert(i64_9 < i64_1);
    assert(i64_9 < i64_3);
    assert(i64_7 < i64_9);

    assert(i64_5 > i64_1);
    assert(i64_5 > i64_3);
    assert(i64_5 > i64_7);
    assert(i64_5 > i64_9);
    assert(i64_3 > i64_1);
    assert(i64_3 > i64_7);
    assert(i64_3 > i64_9);
    assert(i64_9 > i64_7);
}

#[test]
fn signed_i64_total_ord() {
    let zero = I64::zero();
    let one = I64::try_from(1u64).unwrap();
    let max_1 = I64::MAX;
    let min_1 = I64::MIN;
    let neg_one_1 = I64::neg_try_from(1u64).unwrap();

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
fn signed_i64_bits() {
    assert(I64::bits() == 64);
}

#[test]
fn signed_i64_from_uint() {
    let zero = I64::from_uint(0u64);
    let one = I64::from_uint(1u64);
    let max = I64::from_uint(u64::max());

    assert(zero.underlying() == 0u64);
    assert(one.underlying() == 1u64);
    assert(max.underlying() == u64::max());
}

#[test]
fn signed_i64_max_constant() {
    let max = I64::MAX;
    assert(max.underlying() == u64::max());
}

#[test]
fn signed_i64_min_constant() {
    let max = I64::MIN;
    assert(max.underlying() == u64::min());
}

#[test]
fn signed_i64_neg_try_from() {
    let indent = I64::indent();

    let neg_try_from_zero = I64::neg_try_from(u64::min());
    assert(neg_try_from_zero.is_some());
    assert(neg_try_from_zero.unwrap() == I64::zero());

    let neg_try_from_one = I64::neg_try_from(1u64);
    assert(neg_try_from_one.is_some());
    assert(neg_try_from_one.unwrap().underlying() == I64::indent() - 1u64);

    let neg_try_from_max = I64::neg_try_from(indent);
    assert(neg_try_from_max.is_some());
    assert(neg_try_from_max.unwrap().underlying() == u64::min());

    let neg_try_from_overflow = I64::neg_try_from(indent + 1u64);
    assert(neg_try_from_overflow.is_none());
}

#[test]
fn signed_i64_new() {
    let new = I64::new();

    assert(new.underlying() == 9223372036854775808u64);
}

#[test]
fn signed_i64_zero() {
    let zero = I64::zero();

    assert(zero.underlying() == 9223372036854775808u64);
}

#[test]
fn signed_i64_is_zero() {
    let zero = I64::zero();
    assert(zero.is_zero());

    let other_1 = I64::from_uint(1);
    let other_2 = I64::MAX;
    assert(!other_1.is_zero());
    assert(!other_2.is_zero());
}

#[test]
fn signed_i64_underlying() {
    let zero = I64::from_uint(0u64);
    let one = I64::from_uint(1u64);
    let max = I64::from_uint(u64::max());
    let indent = I64::zero();

    assert(zero.underlying() == 0u64);
    assert(one.underlying() == 1u64);
    assert(max.underlying() == u64::max());
    assert(indent.underlying() == 9223372036854775808u64);
}

#[test]
fn signed_i64_add() {
    let pos1 = I64::try_from(1).unwrap();
    let pos2 = I64::try_from(2).unwrap();
    let neg1 = I64::neg_try_from(1).unwrap();
    let neg2 = I64::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 + pos2;
    assert(res1 == I64::try_from(3).unwrap());

    let res2 = pos2 + pos1;
    assert(res2 == I64::try_from(3).unwrap());

    // First positive
    let res3 = pos1 + neg1;
    assert(res3 == I64::zero());

    let res4 = pos2 + neg1;
    assert(res4 == I64::try_from(1).unwrap());

    let res5 = pos1 + neg2;
    assert(res5 == I64::neg_try_from(1).unwrap());

    // Second positive
    let res6 = neg1 + pos1;
    assert(res6 == I64::zero());

    let res7 = neg2 + pos1;
    assert(res7 == I64::neg_try_from(1).unwrap());

    let res8 = neg1 + pos2;
    assert(res8 == I64::try_from(1).unwrap());

    // Both negative
    let res9 = neg1 + neg2;
    assert(res9 == I64::neg_try_from(3).unwrap());

    let res10 = neg2 + neg1;
    assert(res10 == I64::neg_try_from(3).unwrap());

    // Edge Cases
    let res11 = I64::MIN + I64::MAX;
    assert(res11 == I64::neg_try_from(1).unwrap());

    let res12 = I64::MAX + I64::zero();
    assert(res12 == I64::MAX);

    let res13 = I64::MIN + I64::zero();
    assert(res13 == I64::MIN);

    let res14 = I64::zero() + I64::zero();
    assert(res14 == I64::zero());
}

#[test(should_revert)]
fn revert_signed_i64_add() {
    let one = I64::try_from(1u64).unwrap();
    let max = I64::MAX;

    let _ = max + one;
}

#[test(should_revert)]
fn revert_signed_i64_add_negative() {
    let neg_one = I64::neg_try_from(1u64).unwrap();
    let min = I64::MIN;

    let _ = min + neg_one;
}

#[test(should_revert)]
fn revert_signed_i64_add_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let one = I64::try_from(1u64).unwrap();
    let max = I64::MAX;

    let _ = max + one;
}

#[test]
fn signed_i64_add_overflow() {
    let _ = disable_panic_on_overflow();

    let one = I64::try_from(1u64).unwrap();
    let max = I64::MAX;

    assert(max + one == I64::MIN);
}

#[test]
fn signed_i64_subtract() {
    let pos1 = I64::try_from(1).unwrap();
    let pos2 = I64::try_from(2).unwrap();
    let neg1 = I64::neg_try_from(1).unwrap();
    let neg2 = I64::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 - pos2;
    assert(res1 == I64::neg_try_from(1).unwrap());

    let res2 = pos2 - pos1;
    assert(res2 == I64::try_from(1).unwrap());

    // First positive
    let res3 = pos1 - neg1;
    assert(res3 == I64::try_from(2).unwrap());

    let res4 = pos2 - neg1;
    assert(res4 == I64::try_from(3).unwrap());

    // Second positive
    let res5 = neg1 - pos1;
    assert(res5 == I64::neg_try_from(2).unwrap());

    let res6 = neg2 - pos1;
    assert(res6 == I64::neg_try_from(3).unwrap());

    // Both negative
    let res7 = neg1 - neg2;
    assert(res7 == I64::try_from(1).unwrap());

    let res8 = neg2 - neg1;
    assert(res8 == I64::neg_try_from(1).unwrap());

    // Edge Cases
    let res11 = I64::zero() - (I64::MIN + I64::try_from(1).unwrap());
    assert(res11 == I64::MAX);

    let res12 = I64::MAX - I64::zero();
    assert(res12 == I64::MAX);

    let res13 = I64::MIN - I64::zero();
    assert(res13 == I64::MIN);

    let res14 = I64::zero() - I64::zero();
    assert(res14 == I64::zero());
}

#[test(should_revert)]
fn revert_signed_i64_sub() {
    let min = I64::MIN;
    let one = I64::try_from(1u64).unwrap();

    let _ = min - one;
}

#[test(should_revert)]
fn revert_signed_i64_sub_negative() {
    let max = I64::MAX;
    let neg_one = I64::neg_try_from(1u64).unwrap();

    let _ = max - neg_one;
}

#[test(should_revert)]
fn revert_signed_i64_sub_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let min = I64::MIN;
    let one = I64::try_from(1u64).unwrap();

    let _ = min - one;
}

#[test]
fn signed_i64_sub_underflow() {
    let _ = disable_panic_on_overflow();

    let min = I64::MIN;
    let one = I64::try_from(1u64).unwrap();

    let result = min - one;
    assert(result == I64::MAX);
}

#[test]
fn signed_i64_multiply() {
    let pos1 = I64::try_from(1).unwrap();
    let pos2 = I64::try_from(2).unwrap();
    let neg1 = I64::neg_try_from(1).unwrap();
    let neg2 = I64::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 * pos2;
    assert(res1 == I64::try_from(2).unwrap());

    let res2 = pos2 * pos1;
    assert(res2 == I64::try_from(2).unwrap());

    // First positive
    let res3 = pos1 * neg1;
    assert(res3 == I64::neg_try_from(1).unwrap());

    let res4 = pos2 * neg1;
    assert(res4 == I64::neg_try_from(2).unwrap());

    let res5 = pos1 * neg2;
    assert(res5 == I64::neg_try_from(2).unwrap());

    // Second positive
    let res6 = neg1 * pos1;
    assert(res6 == I64::neg_try_from(1).unwrap());

    let res7 = neg2 * pos1;
    assert(res7 == I64::neg_try_from(2).unwrap());

    let res8 = neg1 * pos2;
    assert(res8 == I64::neg_try_from(2).unwrap());

    // Both negative
    let res9 = neg1 * neg2;
    assert(res9 == I64::try_from(2).unwrap());

    let res10 = neg2 * neg1;
    assert(res10 == I64::try_from(2).unwrap());

    // Edge Cases
    let res12 = I64::MAX * I64::zero();
    assert(res12 == I64::zero());

    let res13 = I64::MIN * I64::zero();
    assert(res13 == I64::zero());

    let res14 = I64::zero() * I64::zero();
    assert(res14 == I64::zero());
}

#[test(should_revert)]
fn revert_signed_i64_mul() {
    let max = I64::MAX;
    let two = I64::try_from(2u64).unwrap();

    let _ = max * two;
}

#[test(should_revert)]
fn revert_signed_i64_mul_negatice() {
    let max = I64::MAX;
    let two = I64::neg_try_from(2u64).unwrap();

    let _ = max * two;
}

#[test(should_revert)]
fn revert_signed_i64_mul_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let max = I64::MAX;
    let two = I64::try_from(2u64).unwrap();

    let _ = max * two;
}

#[test]
fn signed_i64_mul() {
    let _ = disable_panic_on_overflow();

    let max = I64::MAX;
    let two = I64::try_from(2u64).unwrap();

    let result = max * two;
    assert(result == I64::neg_try_from(2).unwrap());
}

#[test]
fn signed_i64_divide() {
    let pos1 = I64::try_from(1).unwrap();
    let pos2 = I64::try_from(2).unwrap();
    let neg1 = I64::neg_try_from(1).unwrap();
    let neg2 = I64::neg_try_from(2).unwrap();

    // Both positive:
    let res1 = pos1 / pos2;
    assert(res1 == I64::zero());

    let res2 = pos2 / pos1;
    assert(res2 == I64::try_from(2).unwrap());

    // First positive
    let res3 = pos1 / neg1;
    assert(res3 == I64::neg_try_from(1).unwrap());

    let res4 = pos2 / neg1;
    assert(res4 == I64::neg_try_from(2).unwrap());

    let res5 = pos1 / neg2;
    assert(res5 == I64::zero());

    // Second positive
    let res6 = neg1 / pos1;
    assert(res6 == I64::neg_try_from(1).unwrap());

    let res7 = neg2 / pos1;
    assert(res7 == I64::neg_try_from(2).unwrap());

    let res8 = neg1 / pos2;
    assert(res8 == I64::zero());

    // Both negative
    let res9 = neg1 / neg2;
    assert(res9 == I64::zero());

    let res10 = neg2 / neg1;
    assert(res10 == I64::try_from(2).unwrap());

    // Edge Cases
    let res12 = I64::zero() / I64::MAX;
    assert(res12 == I64::zero());

    let res13 = I64::zero() / I64::MIN;
    assert(res13 == I64::zero());
}

#[test(should_revert)]
fn revert_signed_i64_divide() {
    let zero = I64::zero();
    let one = I64::try_from(1u64).unwrap();

    let _ = one / zero;
}

#[test]
fn signed_i64_divide_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();
    let zero = I64::zero();
    let one = I64::try_from(1u64).unwrap();

    let res = one / zero;
    assert(res == I64::zero());
}

#[test(should_revert)]
fn revert_signed_i64_divide_disable_overflow() {
    let _ = disable_panic_on_overflow();
    let zero = I64::zero();
    let one = I64::try_from(1u64).unwrap();

    let _ = one / zero;
}

#[test]
fn signed_i64_wrapping_neg() {
    let one = I64::try_from(1u64).unwrap();
    let neg_one = I64::neg_try_from(1u64).unwrap();
    let two = I64::try_from(2u64).unwrap();
    let neg_two = I64::neg_try_from(2u64).unwrap();
    let ten = I64::try_from(10u64).unwrap();
    let neg_ten = I64::neg_try_from(10u64).unwrap();
    let twenty_seven = I64::try_from(27u64).unwrap();
    let neg_twenty_seven = I64::neg_try_from(27u64).unwrap();
    let ninty_three = I64::try_from(93u64).unwrap();
    let neg_ninty_three = I64::neg_try_from(93u64).unwrap();
    let zero = I64::try_from(0u64).unwrap();
    let max = I64::MAX;
    let min = I64::MIN;
    let neg_min_plus_one = I64::MIN + I64::try_from(1u64).unwrap();

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
fn signed_i64_try_from_u64() {
    let indent: u64 = I64::indent();

    let i64_max_try_from = I64::try_from(indent - 1);
    assert(i64_max_try_from.is_some());
    assert(i64_max_try_from.unwrap() == I64::MAX);

    let i64_min_try_from = I64::try_from(u64::min());
    assert(i64_min_try_from.is_some());
    assert(i64_min_try_from.unwrap() == I64::zero());

    let i64_overflow_try_from = I64::try_from(indent);
    assert(i64_overflow_try_from.is_none());
}

#[test]
fn signed_i64_try_into_u64() {
    let zero = I64::zero();
    let negative = I64::neg_try_from(1).unwrap();
    let max = I64::MAX;
    let indent: u64 = I64::indent();

    let u64_max_try_into: Option<u64> = max.try_into();
    assert(u64_max_try_into.is_some());
    assert(u64_max_try_into.unwrap() == indent - 1);

    let u64_min_try_into: Option<u64> = zero.try_into();
    assert(u64_min_try_into.is_some());
    assert(u64_min_try_into.unwrap() == u64::zero());

    let u64_overflow_try_into: Option<u64> = negative.try_into();
    assert(u64_overflow_try_into.is_none());
}

#[test]
fn signed_i64_u64_try_from() {
    let zero = I64::zero();
    let negative = I64::neg_try_from(1).unwrap();
    let max = I64::MAX;
    let indent: u64 = I64::indent();

    let u64_max_try_from: Option<u64> = u64::try_from(max);
    assert(u64_max_try_from.is_some());
    assert(u64_max_try_from.unwrap() == indent - 1);

    let u64_min_try_from: Option<u64> = u64::try_from(zero);
    assert(u64_min_try_from.is_some());
    assert(u64_min_try_from.unwrap() == u64::zero());

    let u64_overflow_try_from: Option<u64> = u64::try_from(negative);
    assert(u64_overflow_try_from.is_none());
}

#[test]
fn signed_i64_u64_try_into() {
    let indent: u64 = I64::indent();

    let i64_max_try_into: Option<I64> = (indent - 1).try_into();
    assert(i64_max_try_into.is_some());
    assert(i64_max_try_into.unwrap() == I64::MAX);

    let i64_min_try_into: Option<I64> = u64::min().try_into();
    assert(i64_min_try_into.is_some());
    assert(i64_min_try_into.unwrap() == I64::zero());

    let i64_overflow_try_into: Option<I64> = indent.try_into();
    assert(i64_overflow_try_into.is_none());
}
