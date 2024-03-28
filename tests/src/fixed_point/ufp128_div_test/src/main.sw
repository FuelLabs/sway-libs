script;

use sway_libs::fixed_point::ufp128::UFP128;

fn main() -> bool {
    let zero = UFP128::from((0, 0));
    let mut up = UFP128::from((1, 0));
    let mut down = UFP128::from((2, 0));
    let mut res = up / down;
    assert(res == UFP128::from((0, 9223372036854775808)));

    up = UFP128::from((4, 0));
    down = UFP128::from((2, 0));
    res = up / down;

    assert(res == UFP128::from((2, 0)));

    up = UFP128::from((9, 0));
    down = UFP128::from((4, 0));
    res = up / down;

    assert(res == UFP128::from((2, 4611686018427387904)));

    true
}
