library;

// ANCHOR: import
use sway_libs::signed_integers::*;
// ANCHOR_END: import

// ANCHOR: import_8
use sway_libs::signed_integers::i8::I8;
// ANCHOR_END: import

fn initialize() {
    // ANCHOR: initialize
    let mut i8_value = I8::new();
    // ANCHOR_END: initialize
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
