script;

use sway_libs::fixed_point::{ifp256::IFP256, ufp128::UFP128};

fn main() -> bool {
    // arithmetic
    let one = IFP256::from(UFP128::from((1, 0)));
    let two = IFP256::from(UFP128::from((2, 0)));
    let mut res = two + one;
    assert(IFP256::from(UFP128::from((3, 0))) == res);

    let ifp_256_10 = IFP256::from(UFP128::from((10, 0)));
    res = ifp_256_10 + two;
    assert(IFP256::from(UFP128::from((12, 0))) == res);

    let ifp_256_48 = IFP256::from(UFP128::from((48, 0)));
    let six = IFP256::from(UFP128::from((6, 0)));
    res = ifp_256_48 - six;
    assert(IFP256::from(UFP128::from((42, 0))) == res);

    let ifp_256_169 = IFP256::from(UFP128::from((169, 0)));
    let ifp_256_13 = IFP256::from(UFP128::from((13, 0)));
    res = ifp_256_169 - ifp_256_13;
    assert(IFP256::from(UFP128::from((156, 0))) == res);

    // recip
    let mut value = IFP256::from(UFP128::from((1, 3)));
    res = IFP256::recip(value);
    assert(IFP256::from(UFP128::from((0, 18446744073709551613))) == res);

    // trunc
    let mut value = IFP256::from(UFP128::from((1, 3)));
    res = value.trunc();
    assert(IFP256::from_uint(1) == res);

    // floor
    value = IFP256::from(UFP128::from((1, 3)));
    res = value.floor();
    assert(IFP256::from_uint(1) == res);

    // fract
    value = IFP256::from(UFP128::from((1, 3)));
    res = value.fract();
    assert(IFP256::from(UFP128::from((0, 3))) == res);

    value = IFP256::from_uint(1);
    res = value.fract();
    assert(IFP256::from_uint(0) == res);

    // ceil
    value = IFP256::from(UFP128::from((1, 3)));
    res = value.ceil();
    assert(IFP256::from_uint(2) == res);

    value = IFP256::from_uint(1);
    res = value.ceil();
    assert(IFP256::from_uint(1) == res);

    // round
    value = IFP256::from(UFP128::from((1, 3)));
    res = value.round();
    assert(IFP256::from_uint(1) == res);

    value = IFP256::from(UFP128::from((1, (1 << 63) + 1)));
    res = value.round();
    assert(IFP256::from_uint(2) == res);

    // Ord tests
    let num = IFP256::min();
    let num2 = IFP256::min();

    assert(!(num > num2));
    assert(!(num < num2));
    assert(!(num2 < num));
    assert(!(num2 > num));

    let num = IFP256::min();
    let num2 = IFP256::from_uint(42_u64);

    assert(num < num2);
    assert(num2 > num);

    let num = IFP256::min();
    let num2 = IFP256::max();

    assert(num < num2);
    assert(num2 > num);

    let num = IFP256::from_uint(42_u64);
    let num2 = IFP256::min();

    assert(num > num2);
    assert(num2 < num);

    let num = IFP256::from_uint(42_u64);
    let num2 = IFP256::from_uint(42_u64);

    assert(!(num > num2));
    assert(!(num < num2));
    assert(!(num2 < num));
    assert(!(num2 > num));

    let num = IFP256::from_uint(42_u64);
    let num2 = IFP256::max();

    assert(num < num2);
    assert(num2 > num);

    let num = IFP256::max();
    let num2 = IFP256::min();

    assert(num > num2);
    assert(num2 < num);

    let num = IFP256::max();
    let num2 = IFP256::from_uint(42_u64);

    assert(num > num2);
    assert(num2 < num);

    let num = IFP256::max();
    let num2 = IFP256::max();

    assert(!(num > num2));
    assert(!(num < num2));
    assert(!(num2 < num));
    assert(!(num2 > num));

    true
}
