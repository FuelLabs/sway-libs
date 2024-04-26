library;

// ANCHOR: import
use sway_libs::fixed_point::*;
// ANCHOR_END: import

// ANCHOR: import_ifp
use sway_libs::fixed_point::{ifp128::IFP128, ifp256::IFP256, ifp64::IFP64,};
// ANCHOR_END: import_ifp

// ANCHOR: import_ufp
use sway_libs::fixed_point::{ufp128::UFP128, ufp32::UFP32, ufp64::UFP64,};
// ANCHOR_END: import_ufp

fn instantiating_ufp() {
    // ANCHOR: instantiating_ufp
    let mut ufp32_value = UFP32::from(0u32);
    let mut ufp64_value = UFP64::from(0u64);
    let mut ufp128_value = UFP128::from((0u64, 0u64));
    // ANCHOR_END: instantiating_ufp
}

// ANCHOR: mathematical_ops
fn add_ufp(val1: UFP64, val2: UFP64) {
    let result: UFP64 = val1 + val2;
}

fn subtract_ufp(val1: UFP64, val2: UFP64) {
    let result: UFP64 = val1 - val2;
}

fn multiply_ufp(val1: UFP64, val2: UFP64) {
    let result: UFP64 = val1 * val2;
}

fn divide_ufp(val1: UFP64, val2: UFP64) {
    let result: UFP64 = val1 / val2;
}
// ANCHOR_END: mathematical_ops

fn exponential() {
    // ANCHOR: exponential
    let ten = UFP64::from_uint(10);
    let res = UFP64::exp(ten);
    // ANCHOR_END: exponential
}

fn square_root() {
    // ANCHOR: square_root
    let ufp64_169 = UFP64::from_uint(169);
    let res = UFP64::sqrt(ufp64_169);
    // ANCHOR_END: square_root
}

fn power() {
    // ANCHOR: power
    let five = UFP64::from_uint(5);
    let res = five.pow(3u32);
    // ANCHOR_END: power
}
