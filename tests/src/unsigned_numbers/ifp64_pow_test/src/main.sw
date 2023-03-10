script;

use fixed_point::ifp64::IFP64;
use std::assert::assert;

fn main() -> bool {
    let one = IFP64::from_uint(1u32);
    let ifp64_1000 = IFP64::from_uint(1u32);
    let mut res = one.pow(ifp64_1000);
    assert(one == res);

    let two = IFP64::from_uint(2u32);
    let three = IFP64::from_uint(3u32);
    res = two.pow(three);
    // std::logging::log(res.underlying.value);
    assert(IFP64::from_uint(8u32) == res);

    let ufp_64_11 = IFP64::from_uint(11u32);
    res = ufp_64_11.pow(two);
    assert(IFP64::from_uint(121u32) == res);

    let five = IFP64::from_uint(5u32);
    res = five.pow(three);
    assert(IFP64::from_uint(125u32) == res);

    let seven = IFP64::from_uint(7u32);
    res = seven.pow(two);
    assert(IFP64::from_uint(49u32) == res);

    true
}
