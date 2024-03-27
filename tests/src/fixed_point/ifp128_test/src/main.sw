script;

use libraries::fixed_point::{ifp128::IFP128, ufp64::UFP64};

fn main() -> bool {
    // arithmetic
    let one = IFP128::from(UFP64::from_uint(1));
    let two = IFP128::from(UFP64::from_uint(2));
    let mut res = two + one;
    assert(IFP128::from(UFP64::from_uint(3)) == res);

    let ifp_128_10 = IFP128::from(UFP64::from_uint(10));
    res = ifp_128_10 + two;
    assert(IFP128::from(UFP64::from_uint(12)) == res);

    let ifp_128_48 = IFP128::from(UFP64::from_uint(48));
    let six = IFP128::from(UFP64::from_uint(6));
    res = ifp_128_48 - six;
    assert(IFP128::from(UFP64::from_uint(42)) == res);

    let ifp_128_169 = IFP128::from(UFP64::from_uint(169));
    let ifp_128_13 = IFP128::from(UFP64::from_uint(13));
    res = ifp_128_169 - ifp_128_13;
    assert(IFP128::from(UFP64::from_uint(156)) == res);

    // recip
    let mut value = IFP128::from(UFP64::from_uint(7));
    res = IFP128::recip(value);
    assert(IFP128::from(UFP64::from(613566756)) == res);

    // trunc
    value = IFP128::from(UFP64::from_uint(7));
    res = value.trunc();
    assert(IFP128::from(UFP64::from(30064771072)) == res);

    // floor
    value = IFP128::from(UFP64::from_uint(1) + UFP64::from(3));
    res = value.floor();
    assert(IFP128::from_uint(1) == res);

    // fract
    value = IFP128::from(UFP64::from_uint(1) + UFP64::from(3));
    res = value.fract();
    assert(IFP128::from(UFP64::from(3)) == res);

    value = IFP128::from_uint(1);
    res = value.fract();
    assert(IFP128::from_uint(0) == res);

    // ceil
    value = IFP128::from(UFP64::from_uint(1) + UFP64::from(3));
    res = value.ceil();
    assert(IFP128::from_uint(2) == res);

    value = IFP128::from_uint(1);
    res = value.ceil();
    assert(IFP128::from_uint(1) == res);

    // round
    value = IFP128::from(UFP64::from_uint(1) + UFP64::from(3));
    res = value.round();
    assert(IFP128::from_uint(1) == res);

    value = IFP128::from(UFP64::from_uint(1) + UFP64::from((1 << 32) + 1));
    res = value.round();
    assert(IFP128::from_uint(2) == res);

    true
}
