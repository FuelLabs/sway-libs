script;

use fixed_point::ufp32::UFP32;
use std::assert::assert;

fn main() -> bool {
    let one = UFP32::from_uint(1);
    let mut res = UFP32::sqrt(one);
    assert(one == res);

    let ufp32_100 = UFP32::from_uint(100);
    res = UFP32::sqrt(ufp32_100);
    assert(UFP32::from_uint(10) == res);

    let ufp32_121 = UFP32::from_uint(121);
    res = UFP32::sqrt(ufp32_121);
    assert(UFP32::from_uint(11) == res);

    let ufp32_169 = UFP32::from_uint(169);
    res = UFP32::sqrt(ufp32_169);
    assert(UFP32::from_uint(13) == res);

    let ufp32_49 = UFP32::from_uint(49);
    res = UFP32::sqrt(ufp32_49);
    assert(UFP32::from_uint(7) == res);

    true
}
