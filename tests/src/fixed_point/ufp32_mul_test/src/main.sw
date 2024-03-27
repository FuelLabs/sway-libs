script;

use libraries::fixed_point::ufp32::UFP32;
use std::assert::assert;

fn main() -> bool {
    let one = UFP32::from_uint(1);
    let two = UFP32::from_uint(2);
    let mut res = one * two;
    assert(two == res);

    let ufp_64_10 = UFP32::from_uint(10);
    let ufp_64_20 = UFP32::from_uint(4);
    res = ufp_64_10 * ufp_64_20;
    assert(UFP32::from_uint(40) == res);

    let ufp_64_11 = UFP32::from_uint(11);
    let ufp_64_12 = UFP32::from_uint(12);
    res = ufp_64_11 * ufp_64_12;
    assert(UFP32::from_uint(132) == res);

    let ufp_64_150 = UFP32::from_uint(150);
    let ufp_64_8 = UFP32::from_uint(8);
    res = ufp_64_150 * ufp_64_8;
    assert(UFP32::from_uint(1200) == res);

    let ufp_64_7 = UFP32::from_uint(7);
    let ufp_64_5 = UFP32::from_uint(5);
    res = ufp_64_7 * ufp_64_5;
    assert(UFP32::from_uint(35) == res);

    true
}
