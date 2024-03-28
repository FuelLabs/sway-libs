script;

use sway_libs::fixed_point::ufp32::UFP32;
use std::assert::assert;

fn main() -> bool {
    let one = UFP32::from_uint(1);
    let two = UFP32::from_uint(2);
    let mut res = two / one;
    assert(two == res);

    let ufp_64_10 = UFP32::from_uint(10);
    res = ufp_64_10 / two;
    assert(UFP32::from_uint(5) == res);

    let ufp_64_48 = UFP32::from_uint(48);
    let six = UFP32::from_uint(6);
    res = ufp_64_48 / six;
    assert(UFP32::from_uint(8) == res);

    let ufp_64_169 = UFP32::from_uint(169);
    let ufp_64_13 = UFP32::from_uint(13);
    res = ufp_64_169 / ufp_64_13;
    assert(UFP32::from_uint(13) == res);

    let ufp_64_35 = UFP32::from_uint(35);
    let ufp_64_5 = UFP32::from_uint(5);
    res = ufp_64_35 / ufp_64_5;
    assert(UFP32::from_uint(7) == res);

    true
}
