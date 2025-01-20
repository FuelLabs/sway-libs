library;

// ANCHOR: import
use sway_libs::signed_integers::*;
// ANCHOR_END: import

// ANCHOR: import_8
use sway_libs::signed_integers::i8::I8;
// ANCHOR_END: import_8

fn initialize() {
    // ANCHOR: initialize
    let mut i8_value = I8::new();
    // ANCHOR_END: initialize

    // ANCHOR: zero
    let zero = I8::zero();
    // ANCHOR_END: zero

    // ANCHOR: zero_from_underlying
    let zero = I8::from_uint(128u8);
    // ANCHOR_END: zero_from_underlying

    // ANCHOR: neg_128_from_underlying
    let neg_128 = I8::from_uint(0u8);
    // ANCHOR_END: neg_128_from_underlying

    // ANCHOR: 127_from_underlying
    let pos_127 = I8::from_uint(255u8);
    // ANCHOR_END: 128_from_underlying

    // ANCHOR: min
    let min = I8::min();
    // ANCHOR_END: min

    // ANCHOR: max
    let max = I8::max();
    // ANCHOR_END: max
}

fn conversion() {
    // ANCHOR: positive_conversion
    let one = I8::try_from(1u8).unwrap();
    // ANCHOR_END: positive_conversion

    // ANCHOR: negative_conversion
    let negative_one = I8::neg_try_from(1u8).unwrap();
    // ANCHOR_END: negative_conversion
}

// ANCHOR: mathematical_ops
fn add_signed_int(val1: I8, val2: I8) {
    let result: I8 = val1 + val2;
}

fn subtract_signed_int(val1: I8, val2: I8) {
    let result: I8 = val1 - val2;
}

fn multiply_signed_int(val1: I8, val2: I8) {
    let result: I8 = val1 * val2;
}

fn divide_signed_int(val1: I8, val2: I8) {
    let result: I8 = val1 / val2;
}
// ANCHOR_END: mathematical_ops

// ANCHOR: is_zero
fn is_zero() {
    let i8 = I8::zero();
    assert(i8.is_zero());
}
// ANCHOR_END: is_zero
