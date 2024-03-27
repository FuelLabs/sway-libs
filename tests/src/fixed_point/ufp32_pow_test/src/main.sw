script;

use libraries::fixed_point::ufp32::UFP32;
use std::assert::assert;

fn main() -> bool {
    let one = UFP32::from_uint(1);
    let mut res = one.pow(1u32);
    assert(one == res);

    let two = UFP32::from_uint(2);
    res = two.pow(3u32);
    assert(UFP32::from_uint(8) == res);

    let ufp_64_11 = UFP32::from_uint(11);
    res = ufp_64_11.pow(2u32);
    assert(UFP32::from_uint(121) == res);

    let five = UFP32::from_uint(5);
    res = five.pow(3u32);
    assert(UFP32::from_uint(125) == res);

    let seven = UFP32::from_uint(7);
    res = seven.pow(2u32);
    assert(UFP32::from_uint(49) == res);

    true
}
