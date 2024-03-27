script;

use libraries::fixed_point::ifp64::IFP64;
use std::assert::assert;

fn main() -> bool {
    let one = IFP64::from_uint(1u32);
    let mut res = one.pow(1u32);
    assert(one == res);

    let two = IFP64::from_uint(2u32);
    res = two.pow(3u32);
    assert(IFP64::from_uint(8u32) == res);

    let ufp_64_11 = IFP64::from_uint(11u32);
    res = ufp_64_11.pow(2u32);
    assert(IFP64::from_uint(121u32) == res);

    let five = IFP64::from_uint(5u32);
    res = five.pow(3u32);
    assert(IFP64::from_uint(125u32) == res);

    let seven = IFP64::from_uint(7u32);
    res = seven.pow(2u32);
    assert(IFP64::from_uint(49u32) == res);

    true
}
