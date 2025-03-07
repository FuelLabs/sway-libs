library;

use sway_libs::signed_integers::i256::I256;
use std::convert::*;
use std::flags::{disable_panic_on_overflow, disable_panic_on_unsafe_math};

#[test]
fn signed_i256_indent() {
    assert(
        I256::indent() == 0x8000000000000000000000000000000000000000000000000000000000000000u256,
    );
}

#[test]
fn signed_i256_eq() {
    let i256_1 = I256::zero();
    let i256_2 = I256::zero();
    let i256_3 = I256::try_from(0x1u256).unwrap();
    let i256_4 = I256::try_from(0x1u256).unwrap();
    let i256_5 = I256::max();
    let i256_6 = I256::max();
    let i256_7 = I256::min();
    let i256_8 = I256::min();
    let i256_9 = I256::neg_try_from(0x1u256).unwrap();
    let i256_10 = I256::neg_try_from(0x1u256).unwrap();

    assert(i256_1 == i256_2);
    assert(i256_3 == i256_4);
    assert(i256_5 == i256_6);
    assert(i256_7 == i256_8);
    assert(i256_9 == i256_10);

    assert(i256_1 != i256_3);
    assert(i256_1 != i256_5);
    assert(i256_1 != i256_7);
    assert(i256_1 != i256_9);

    assert(i256_3 != i256_5);
    assert(i256_3 != i256_7);
    assert(i256_3 != i256_9);

    assert(i256_5 != i256_7);
    assert(i256_5 != i256_9);

    assert(i256_7 != i256_9);
}

#[test]
fn signed_i256_ord() {
    let i256_1 = I256::zero();
    let i256_2 = I256::zero();
    let i256_3 = I256::try_from(0x1u256).unwrap();
    let i256_4 = I256::try_from(0x1u256).unwrap();
    let i256_5 = I256::max();
    let i256_6 = I256::max();
    let i256_7 = I256::min();
    let i256_8 = I256::min();
    let i256_9 = I256::neg_try_from(0x1u256).unwrap();
    let i256_10 = I256::neg_try_from(0x1u256).unwrap();

    assert(!(i256_1 > i256_2));
    assert(!(i256_3 > i256_4));
    assert(!(i256_5 > i256_6));
    assert(!(i256_7 > i256_8));
    assert(!(i256_9 > i256_10));

    assert(i256_1 >= i256_2);
    assert(i256_3 >= i256_4);
    assert(i256_5 >= i256_6);
    assert(i256_7 >= i256_8);
    assert(i256_9 >= i256_10);

    assert(!(i256_1 < i256_2));
    assert(!(i256_3 < i256_4));
    assert(!(i256_5 < i256_6));
    assert(!(i256_7 < i256_8));
    assert(!(i256_9 < i256_10));

    assert(i256_1 <= i256_2);
    assert(i256_3 <= i256_4);
    assert(i256_5 <= i256_6);
    assert(i256_7 <= i256_8);
    assert(i256_9 <= i256_10);

    assert(i256_1 < i256_3);
    assert(i256_1 < i256_5);
    assert(i256_3 < i256_5);
    assert(i256_7 < i256_5);
    assert(i256_9 < i256_5);
    assert(i256_9 < i256_1);
    assert(i256_9 < i256_3);
    assert(i256_7 < i256_9);

    assert(i256_5 > i256_1);
    assert(i256_5 > i256_3);
    assert(i256_5 > i256_7);
    assert(i256_5 > i256_9);
    assert(i256_3 > i256_1);
    assert(i256_3 > i256_7);
    assert(i256_3 > i256_9);
    assert(i256_9 > i256_7);
}

#[test]
fn signed_i256_bits() {
    assert(I256::bits() == 256);
}

#[test]
fn signed_i256_from_uint() {
    let zero = I256::from_uint(u256::zero());
    let one = I256::from_uint(0x1u256);
    let max = I256::from_uint(u256::max());

    assert(zero.underlying() == u256::zero());
    assert(one.underlying() == 0x1u256);
    assert(max.underlying() == u256::max());
}

#[test]
fn signed_i256_max() {
    let max = I256::max();
    assert(max.underlying() == u256::max());
}

#[test]
fn signed_i256_min() {
    let max = I256::min();
    assert(max.underlying() == u256::min());
}

#[test]
fn signed_i256_neg_try_from() {
    let indent = I256::indent();

    let neg_try_from_zero = I256::neg_try_from(u256::min());
    assert(neg_try_from_zero.is_some());
    assert(neg_try_from_zero.unwrap() == I256::zero());

    let neg_try_from_one = I256::neg_try_from(0x1u256);
    assert(neg_try_from_one.is_some());
    assert(neg_try_from_one.unwrap().underlying() == I256::indent() - 0x1u256);

    let neg_try_from_max = I256::neg_try_from(indent);
    assert(neg_try_from_max.is_some());
    assert(neg_try_from_max.unwrap().underlying() == u256::min());

    let neg_try_from_overflow = I256::neg_try_from(indent + 0x1u256);
    assert(neg_try_from_overflow.is_none());
}

#[test]
fn signed_i256_new() {
    let new = I256::new();

    assert(
        new
            .underlying() == 0x8000000000000000000000000000000000000000000000000000000000000000u256,
    );
}

#[test]
fn signed_i256_zero() {
    let zero = I256::zero();

    assert(
        zero
            .underlying() == 0x8000000000000000000000000000000000000000000000000000000000000000u256,
    );
}

#[test]
fn signed_i256_is_zero() {
    let zero = I256::zero();
    assert(zero.is_zero());

    let other_1 = I256::from_uint(0x1u256);
    let other_2 = I256::max();
    assert(!other_1.is_zero());
    assert(!other_2.is_zero());
}

#[test]
fn signed_i256_underlying() {
    let zero = I256::from_uint(0x0u256);
    let one = I256::from_uint(0x1u256);
    let max = I256::from_uint(u256::max());
    let indent = I256::zero();

    assert(zero.underlying() == 0x0u256);
    assert(one.underlying() == 0x1u256);
    assert(max.underlying() == u256::max());
    assert(
        indent
            .underlying() == 0x8000000000000000000000000000000000000000000000000000000000000000u256,
    );
}

#[test]
fn signed_i256_add() {
    let pos1 = I256::try_from(0x1u256).unwrap();
    let pos2 = I256::try_from(0x2u256).unwrap();
    let neg1 = I256::neg_try_from(0x1u256).unwrap();
    let neg2 = I256::neg_try_from(0x2u256).unwrap();

    // Both positive:
    let res1 = pos1 + pos2;
    assert(res1 == I256::try_from(0x3u256).unwrap());

    let res2 = pos2 + pos1;
    assert(res2 == I256::try_from(0x3u256).unwrap());

    // First positive
    let res3 = pos1 + neg1;
    assert(res3 == I256::zero());

    let res4 = pos2 + neg1;
    assert(res4 == I256::try_from(0x1u256).unwrap());

    let res5 = pos1 + neg2;
    assert(res5 == I256::neg_try_from(0x1u256).unwrap());

    // Second positive
    let res6 = neg1 + pos1;
    assert(res6 == I256::zero());

    let res7 = neg2 + pos1;
    assert(res7 == I256::neg_try_from(0x1u256).unwrap());

    let res8 = neg1 + pos2;
    assert(res8 == I256::try_from(0x1u256).unwrap());

    // Both negative
    let res9 = neg1 + neg2;
    assert(res9 == I256::neg_try_from(0x3u256).unwrap());

    let res10 = neg2 + neg1;
    assert(res10 == I256::neg_try_from(0x3u256).unwrap());

    // Edge Cases
    let res11 = I256::min() + I256::max();
    assert(res11 == I256::neg_try_from(0x1u256).unwrap());

    let res12 = I256::max() + I256::zero();
    assert(res12 == I256::max());

    let res13 = I256::min() + I256::zero();
    assert(res13 == I256::min());

    let res14 = I256::zero() + I256::zero();
    assert(res14 == I256::zero());
}

#[test(should_revert)]
fn revert_signed_i256_add() {
    let one = I256::try_from(0x1u256).unwrap();
    let max = I256::max();

    let _ = max + one;
}

#[test(should_revert)]
fn revert_signed_i256_add_negative() {
    let neg_one = I256::neg_try_from(0x1u256).unwrap();
    let min = I256::min();

    let _ = min + neg_one;
}

#[test(should_revert)]
fn revert_signed_i256_add_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let one = I256::try_from(0x1u256).unwrap();
    let max = I256::max();

    let _ = max + one;
}

#[test]
fn signed_i256_add_overflow() {
    let _ = disable_panic_on_overflow();

    let one = I256::try_from(0x1u256).unwrap();
    let max = I256::max();

    assert(max + one == I256::min());
}

#[test]
fn signed_i256_subtract() {
    let pos1 = I256::try_from(0x1u256).unwrap();
    let pos2 = I256::try_from(0x2u256).unwrap();
    let neg1 = I256::neg_try_from(0x1u256).unwrap();
    let neg2 = I256::neg_try_from(0x2u256).unwrap();

    // Both positive:
    let res1 = pos1 - pos2;
    assert(res1 == I256::neg_try_from(0x1u256).unwrap());

    let res2 = pos2 - pos1;
    assert(res2 == I256::try_from(0x1u256).unwrap());

    // First positive
    let res3 = pos1 - neg1;
    assert(res3 == I256::try_from(0x2u256).unwrap());

    let res4 = pos2 - neg1;
    assert(res4 == I256::try_from(0x3u256).unwrap());

    // Second positive
    let res5 = neg1 - pos1;
    assert(res5 == I256::neg_try_from(0x2u256).unwrap());

    let res6 = neg2 - pos1;
    assert(res6 == I256::neg_try_from(0x3u256).unwrap());

    // Both negative
    let res7 = neg1 - neg2;
    assert(res7 == I256::try_from(0x1u256).unwrap());

    let res8 = neg2 - neg1;
    assert(res8 == I256::neg_try_from(0x1u256).unwrap());

    // Edge Cases
    let res11 = I256::zero() - (I256::min() + I256::try_from(0x1u256).unwrap());
    assert(res11 == I256::max());

    let res12 = I256::max() - I256::zero();
    assert(res12 == I256::max());

    let res13 = I256::min() - I256::zero();
    assert(res13 == I256::min());

    let res14 = I256::zero() - I256::zero();
    assert(res14 == I256::zero());
}

#[test(should_revert)]
fn revert_signed_i256_sub() {
    let min = I256::min();
    let one = I256::try_from(0x1u256).unwrap();

    let _ = min - one;
}

#[test(should_revert)]
fn revert_signed_i256_sub_negative() {
    let max = I256::max();
    let neg_one = I256::neg_try_from(0x1u256).unwrap();

    let _ = max - neg_one;
}

#[test(should_revert)]
fn revert_signed_i256_sub_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let min = I256::min();
    let one = I256::try_from(0x1u256).unwrap();

    let _ = min - one;
}

#[test]
fn signed_i256_sub_underflow() {
    let _ = disable_panic_on_overflow();

    let min = I256::min();
    let one = I256::try_from(0x1u256).unwrap();

    let result = min - one;
    assert(result == I256::max());
}

#[test]
fn signed_i256_multiply() {
    let pos1 = I256::try_from(0x1u256).unwrap();
    let pos2 = I256::try_from(0x2u256).unwrap();
    let neg1 = I256::neg_try_from(0x1u256).unwrap();
    let neg2 = I256::neg_try_from(0x2u256).unwrap();

    // Both positive:
    let res1 = pos1 * pos2;
    assert(res1 == I256::try_from(0x2u256).unwrap());

    let res2 = pos2 * pos1;
    assert(res2 == I256::try_from(0x2u256).unwrap());

    // First positive
    let res3 = pos1 * neg1;
    assert(res3 == I256::neg_try_from(0x1u256).unwrap());

    let res4 = pos2 * neg1;
    assert(res4 == I256::neg_try_from(0x2u256).unwrap());

    let res5 = pos1 * neg2;
    assert(res5 == I256::neg_try_from(0x2u256).unwrap());

    // Second positive
    let res6 = neg1 * pos1;
    assert(res6 == I256::neg_try_from(0x1u256).unwrap());

    let res7 = neg2 * pos1;
    assert(res7 == I256::neg_try_from(0x2u256).unwrap());

    let res8 = neg1 * pos2;
    assert(res8 == I256::neg_try_from(0x2u256).unwrap());

    // Both negative
    let res9 = neg1 * neg2;
    assert(res9 == I256::try_from(0x2u256).unwrap());

    let res10 = neg2 * neg1;
    assert(res10 == I256::try_from(0x2u256).unwrap());

    // Edge Cases
    let res12 = I256::max() * I256::zero();
    assert(res12 == I256::zero());

    let res13 = I256::min() * I256::zero();
    assert(res13 == I256::zero());

    let res14 = I256::zero() * I256::zero();
    assert(res14 == I256::zero());
}

#[test(should_revert)]
fn revert_signed_i256_mul() {
    let max = I256::max();
    let two = I256::try_from(0x2u256).unwrap();

    let _ = max * two;
}

#[test(should_revert)]
fn revert_signed_i256_mul_negatice() {
    let max = I256::max();
    let two = I256::neg_try_from(0x2u256).unwrap();

    let _ = max * two;
}

#[test(should_revert)]
fn revert_signed_i256_mul_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();

    let max = I256::max();
    let two = I256::try_from(0x2u256).unwrap();

    let _ = max * two;
}

#[test]
fn signed_i256_mul() {
    let _ = disable_panic_on_overflow();

    let max = I256::max();
    let two = I256::try_from(0x2u256).unwrap();

    let result = max * two;
    assert(result == I256::neg_try_from(0x2u256).unwrap());
}

#[test]
fn signed_i256_divide() {
    let pos1 = I256::try_from(0x1u256).unwrap();
    let pos2 = I256::try_from(0x2u256).unwrap();
    let neg1 = I256::neg_try_from(0x1u256).unwrap();
    let neg2 = I256::neg_try_from(0x2u256).unwrap();

    // Both positive:
    let res1 = pos1 / pos2;
    assert(res1 == I256::zero());

    let res2 = pos2 / pos1;
    assert(res2 == I256::try_from(0x2u256).unwrap());

    // First positive
    let res3 = pos1 / neg1;
    assert(res3 == I256::neg_try_from(0x1u256).unwrap());

    let res4 = pos2 / neg1;
    assert(res4 == I256::neg_try_from(0x2u256).unwrap());

    let res5 = pos1 / neg2;
    assert(res5 == I256::zero());

    // Second positive
    let res6 = neg1 / pos1;
    assert(res6 == I256::neg_try_from(0x1u256).unwrap());

    let res7 = neg2 / pos1;
    assert(res7 == I256::neg_try_from(0x2u256).unwrap());

    let res8 = neg1 / pos2;
    assert(res8 == I256::zero());

    // Both negative
    let res9 = neg1 / neg2;
    assert(res9 == I256::zero());

    let res10 = neg2 / neg1;
    assert(res10 == I256::try_from(0x2u256).unwrap());

    // Edge Cases
    let res12 = I256::zero() / I256::max();
    assert(res12 == I256::zero());

    let res13 = I256::zero() / I256::min();
    assert(res13 == I256::zero());
}

#[test(should_revert)]
fn revert_signed_i256_divide() {
    let zero = I256::zero();
    let one = I256::try_from(0x1u256).unwrap();

    let _ = one / zero;
}

#[test]
fn signed_i256_divide_unsafe_math() {
    let _ = disable_panic_on_unsafe_math();
    let zero = I256::zero();
    let one = I256::try_from(0x1u256).unwrap();

    let res = one / zero;
    assert(res == I256::zero());
}

#[test(should_revert)]
fn revert_signed_i256_divide_disable_overflow() {
    let _ = disable_panic_on_overflow();
    let zero = I256::zero();
    let one = I256::try_from(0x1u256).unwrap();

    let _ = one / zero;
}

#[test]
fn signed_i256_wrapping_neg() {
    let one = I256::try_from(0x1u256).unwrap();
    let neg_one = I256::neg_try_from(0x1u256).unwrap();
    let two = I256::try_from(0x2u256).unwrap();
    let neg_two = I256::neg_try_from(0x2u256).unwrap();
    let ten = I256::try_from(0x10u256).unwrap();
    let neg_ten = I256::neg_try_from(0x10u256).unwrap();
    let twenty_seven = I256::try_from(0x27u256).unwrap();
    let neg_twenty_seven = I256::neg_try_from(0x27u256).unwrap();
    let ninty_three = I256::try_from(0x93u256).unwrap();
    let neg_ninty_three = I256::neg_try_from(0x93u256).unwrap();
    let zero = I256::try_from(u256::zero()).unwrap();
    let max = I256::max();
    let min = I256::min();
    let neg_min_plus_one = I256::min() + I256::try_from(0x1u256).unwrap();

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
fn signed_i256_try_from_u256() {
    let indent: u256 = I256::indent();

    let i256_max_try_from = I256::try_from(indent - 0x1u256);
    assert(i256_max_try_from.is_some());
    assert(i256_max_try_from.unwrap() == I256::max());

    let i256_min_try_from = I256::try_from(u256::min());
    assert(i256_min_try_from.is_some());
    assert(i256_min_try_from.unwrap() == I256::zero());

    let i256_overflow_try_from = I256::try_from(indent);
    assert(i256_overflow_try_from.is_none());
}

#[test]
fn signed_i256_try_into_u256() {
    let zero = I256::zero();
    let negative = I256::neg_try_from(0x1u256).unwrap();
    let max = I256::max();
    let indent: u256 = I256::indent();

    let u256_max_try_into: Option<u256> = max.try_into();
    assert(u256_max_try_into.is_some());
    assert(u256_max_try_into.unwrap() == indent - 0x1u256);

    let u256_min_try_into: Option<u256> = zero.try_into();
    assert(u256_min_try_into.is_some());
    assert(u256_min_try_into.unwrap() == u256::zero());

    let u256_overflow_try_into: Option<u256> = negative.try_into();
    assert(u256_overflow_try_into.is_none());
}

#[test]
fn signed_i256_u256_try_from() {
    let zero = I256::zero();
    let negative = I256::neg_try_from(0x1u256).unwrap();
    let max = I256::max();
    let indent: u256 = I256::indent();

    let u256_max_try_from: Option<u256> = u256::try_from(max);
    assert(u256_max_try_from.is_some());
    assert(u256_max_try_from.unwrap() == indent - 0x1u256);

    let u256_min_try_from: Option<u256> = u256::try_from(zero);
    assert(u256_min_try_from.is_some());
    assert(u256_min_try_from.unwrap() == u256::zero());

    let u256_overflow_try_from: Option<u256> = u256::try_from(negative);
    assert(u256_overflow_try_from.is_none());
}

#[test]
fn signed_i256_u256_try_into() {
    let indent: u256 = I256::indent();

    let i256_max_try_into: Option<I256> = (indent - 0x1u256).try_into();
    assert(i256_max_try_into.is_some());
    assert(i256_max_try_into.unwrap() == I256::max());

    let i256_min_try_into: Option<I256> = u256::min().try_into();
    assert(i256_min_try_into.is_some());
    assert(i256_min_try_into.unwrap() == I256::zero());

    let i256_overflow_try_into: Option<I256> = indent.try_into();
    assert(i256_overflow_try_into.is_none());
}
