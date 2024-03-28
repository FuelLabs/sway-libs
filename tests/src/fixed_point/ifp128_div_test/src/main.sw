script;

use sway_libs::fixed_point::{ifp128::IFP128, ufp64::UFP64};

fn main() -> bool {
    let zero = IFP128::from(UFP64::from_uint(0));
    let mut up = IFP128::from(UFP64::from_uint(1));
    let mut down = IFP128::from(UFP64::from_uint(2));
    let mut res = up / down;
    assert(res == IFP128::from(UFP64::from(2147483648)));

    up = IFP128::from(UFP64::from_uint(4));
    down = IFP128::from(UFP64::from_uint(2));
    res = up / down;
    assert(res == IFP128::from(UFP64::from_uint(2)));

    up = IFP128::from(UFP64::from_uint(9));
    down = IFP128::from(UFP64::from_uint(4));
    res = up / down;

    assert(res == IFP128::from(UFP64::from(9663676416)));

    true
}
