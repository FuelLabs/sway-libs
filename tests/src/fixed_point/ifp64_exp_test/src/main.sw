script;

use sway_libs::fixed_point::ifp64::IFP64;
use std::assert::assert;

fn main() -> bool {
    let one = IFP64::from_uint(1u32);
    let mut res = IFP64::exp(one);
    assert(res.underlying().underlying() == 178142u32);

    let two = IFP64::from_uint(2u32);
    res = IFP64::exp(two);
    assert(res.underlying().underlying() == 483696u32);

    let four = IFP64::from_uint(4u32);
    res = IFP64::exp(four);
    assert(res.underlying().underlying() == 3394688u32);

    let seven = IFP64::from_uint(7u32);
    res = IFP64::exp(seven);
    assert(res.underlying().underlying() == 43019636u32);

    let ten = IFP64::from_uint(10u32);
    res = IFP64::exp(ten);
    assert(res.underlying().underlying() == 317819696u32);

    true
}
