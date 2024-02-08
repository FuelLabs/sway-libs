predicate;

configurable {
    VALUE: u64 = 1,
}

fn main(val: u64) -> bool {
    VALUE == val
}
