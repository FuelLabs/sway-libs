script;

use libraries::fixed_point::ifp64::IFP64;
use std::assert::assert;

fn main() -> bool {
    let one = IFP64::from_uint(1u32);
    let two = IFP64::from_uint(2u32);
    let mut res = two / one;
    assert(two == res);

    let ufp_64_10 = IFP64::from_uint(10u32);
    res = ufp_64_10 / two;
    assert(IFP64::from_uint(5u32) == res);

    let ufp_64_48 = IFP64::from_uint(48u32);
    let six = IFP64::from_uint(6u32);
    res = ufp_64_48 / six;
    assert(IFP64::from_uint(8u32) == res);

    let ufp_64_169 = IFP64::from_uint(169u32);
    let ufp_64_13 = IFP64::from_uint(13u32);
    res = ufp_64_169 / ufp_64_13;
    assert(IFP64::from_uint(13u32) == res);

    let ufp_64_35 = IFP64::from_uint(35u32);
    let ufp_64_5 = IFP64::from_uint(5u32);
    res = ufp_64_35 / ufp_64_5;
    assert(IFP64::from_uint(7u32) == res);

    true
}
