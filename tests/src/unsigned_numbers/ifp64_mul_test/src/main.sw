script;

use fixed_point::ifp64::IFP64;
use std::assert::assert;

fn main() -> bool {
    let one = IFP64::from_uint(1u32);
    let two = IFP64::from_uint(2u32);
    let mut res = one * two;
    assert(two == res);

    let ufp_64_10 = IFP64::from_uint(10u32);
    let ufp_64_20 = IFP64::from_uint(4u32);
    res = ufp_64_10 * ufp_64_20;
    assert(IFP64::from_uint(40u32) == res);

    let ufp_64_11 = IFP64::from_uint(11u32);
    let ufp_64_12 = IFP64::from_uint(12u32);
    res = ufp_64_11 * ufp_64_12;
    assert(IFP64::from_uint(132u32) == res);

    let ufp_64_150 = IFP64::from_uint(150u32);
    let ufp_64_8 = IFP64::from_uint(8u32);
    res = ufp_64_150 * ufp_64_8;
    assert(IFP64::from_uint(1200u32) == res);

    let ufp_64_7 = IFP64::from_uint(7u32);
    let ufp_64_5 = IFP64::from_uint(5u32);
    res = ufp_64_7 * ufp_64_5;
    assert(IFP64::from_uint(35u32) == res);

    true
}
