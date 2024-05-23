script;

use sway_libs::fixed_point::ufp32::UFP32;
use std::assert::assert;

fn main() -> bool {
    let one = UFP32::from_uint(1);
    let mut res = UFP32::exp(one);
    assert(res.underlying() == 11674811894);

    let two = UFP32::from_uint(2);
    res = UFP32::exp(two);
    assert(res.underlying() == 31700949040);

    let four = UFP32::from_uint(4);
    res = UFP32::exp(four);
    assert(res.underlying() == 222506572928);

    let seven = UFP32::from_uint(7);
    res = UFP32::exp(seven);
    assert(res.underlying() == 2819944203710);

    let ten = UFP32::from_uint(10);
    res = UFP32::exp(ten);
    assert(res.underlying() == 20833521987056);

    true
}
