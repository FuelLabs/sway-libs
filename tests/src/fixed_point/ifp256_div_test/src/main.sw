script;

use libraries::fixed_point::{ifp256::IFP256, ufp128::UFP128};

fn main() -> bool {
    let zero = IFP256::from(UFP128::from((0, 0)));
    let mut up = IFP256::from(UFP128::from((1, 0)));
    let mut down = IFP256::from(UFP128::from((2, 0)));
    let mut res = up / down;
    assert(res == IFP256::from(UFP128::from((0, 9223372036854775808))));

    up = IFP256::from(UFP128::from((4, 0)));
    down = IFP256::from(UFP128::from((2, 0)));
    res = up / down;

    assert(res == IFP256::from(UFP128::from((2, 0))));

    up = IFP256::from(UFP128::from((9, 0)));
    down = IFP256::from(UFP128::from((4, 0)));
    res = up / down;

    assert(res == IFP256::from(UFP128::from((2, 4611686018427387904))));

    true
}
