script;

use sway_libs::fixed_point::ufp64::UFP64;
use std::assert::assert;

fn main() -> bool {
    let one = UFP64::from_uint(1);
    let mut res = UFP64::exp(one);
    assert(res.underlying() == 11674811894);

    let two = UFP64::from_uint(2);
    res = UFP64::exp(two);
    assert(res.underlying() == 31700949040);

    let four = UFP64::from_uint(4);
    res = UFP64::exp(four);
    assert(res.underlying() == 222506572928);

    let seven = UFP64::from_uint(7);
    res = UFP64::exp(seven);
    assert(res.underlying() == 2819944203710);

    let ten = UFP64::from_uint(10);
    res = UFP64::exp(ten);
    assert(res.underlying() == 20833521987056);

    true
}
