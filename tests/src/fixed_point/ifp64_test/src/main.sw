script;

use sway_libs::fixed_point::{ifp64::IFP64, ufp32::UFP32};
use std::assert::assert;

fn main() -> bool {
    // arithmetic
    let one = IFP64::from_uint(1u32);
    let two = IFP64::from_uint(2u32);
    let mut res = two + one;
    assert(IFP64::from_uint(3u32) == res);

    let ifp_64_10 = IFP64::from_uint(10u32);
    res = ifp_64_10 + two;
    assert(IFP64::from_uint(12u32) == res);

    let ufp_64_48 = IFP64::from_uint(48u32);
    let six = IFP64::from_uint(6u32);
    res = ufp_64_48 - six;
    assert(IFP64::from_uint(42u32) == res);

    let ufp_64_169 = IFP64::from_uint(169u32);
    let ufp_64_13 = IFP64::from_uint(13u32);
    res = ufp_64_169 - ufp_64_13;
    assert(IFP64::from_uint(156u32) == res);

    // recip
    let mut u_value = UFP32 {
        value: 1u32 << 16 + 3,
    };
    let mut value = IFP64::from(u_value);

    res = IFP64::recip(value);
    assert(IFP64::from(UFP32 {
        value: 8192u32,
    }) == res);

    // trunc
    u_value = UFP32 {
        value: (1u32 << 16) + 3u32,
    };
    value = IFP64::from(u_value);

    res = value.trunc();
    assert(IFP64::from_uint(1u32) == res);

    // floor
    u_value = UFP32 {
        value: (1u32 << 16) + 3u32,
    };
    value = IFP64::from(u_value);

    res = value.floor();
    assert(IFP64::from_uint(1u32) == res);

    // fract
    u_value = UFP32 {
        value: (1u32 << 16) + 3u32,
    };
    value = IFP64::from(u_value);

    res = value.fract();
    assert(IFP64::from(UFP32 { value: 3u32 }) == res);

    value = IFP64::from_uint(1u32);
    res = value.fract();
    assert(IFP64::from_uint(0u32) == res);

    // ceil
    u_value = UFP32 {
        value: (1u32 << 16) + 3u32,
    };
    value = IFP64::from(u_value);

    res = value.ceil();
    assert(IFP64::from_uint(2u32) == res);

    value = IFP64::from_uint(1u32);
    res = value.ceil();
    assert(IFP64::from_uint(1u32) == res);

    // round
    u_value = UFP32 {
        value: (1u32 << 16) + 3u32,
    };
    value = IFP64::from(u_value);

    res = value.round();
    assert(IFP64::from_uint(1u32) == res);

    u_value = UFP32 {
        value: (1u32 << 16) + (1u32 << 15) + 1u32,
    };
    value = IFP64::from(u_value);

    res = value.round();
    assert(IFP64::from_uint(2u32) == res);

    true
}
