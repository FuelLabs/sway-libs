script;

use sway_libs::fixed_point::ufp32::UFP32;
use std::assert::assert;

fn main() -> bool {
    // arithmetic
    let one = UFP32::from_uint(1);
    let two = UFP32::from_uint(2);
    let mut res = two + one;
    assert(UFP32::from_uint(3) == res);

    let ufp_32_10 = UFP32::from_uint(10);
    res = ufp_32_10 + two;
    assert(UFP32::from_uint(12) == res);

    let ufp_32_48 = UFP32::from_uint(48);
    let six = UFP32::from_uint(6);
    res = ufp_32_48 - six;
    assert(UFP32::from_uint(42) == res);

    let ufp_32_169 = UFP32::from_uint(169);
    let ufp_32_13 = UFP32::from_uint(13);
    res = ufp_32_169 - ufp_32_13;
    assert(UFP32::from_uint(156) == res);

    // recip
    let mut value = UFP32 { value: 3u32 };
    res = UFP32::recip(value);
    assert(UFP32 {
        value: 536870912,
    } == res);

    // trunc
    value = UFP32 { value: 3u32 };
    res = value.trunc();
    assert(UFP32::from_uint(1) == res);

    // floor
    value = UFP32 { value: 3u32 };
    res = value.floor();
    assert(UFP32::from_uint(1) == res);

    // fract
    value = UFP32 { value: 3u32 };
    res = value.fract();
    assert(UFP32 { value: 3 } == res);

    value = UFP32::from_uint(1);
    res = value.fract();
    assert(UFP32::from_uint(0) == res);

    // ceil
    value = UFP32 { value: 3u32 };
    res = value.ceil();
    assert(UFP32::from_uint(2) == res);

    value = UFP32::from_uint(1);
    res = value.ceil();
    assert(UFP32::from_uint(1) == res);

    // round
    value = UFP32 { value: 3u32 };
    res = value.round();
    assert(UFP32::from_uint(1) == res);

    value = UFP32 {
        value: 2147483649u32,
    };
    res = value.round();
    assert(UFP32::from_uint(2) == res);

    true
}
