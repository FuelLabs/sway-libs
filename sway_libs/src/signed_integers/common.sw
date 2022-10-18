library common;

pub trait TwosComplement {
    fn twos_complement(self) -> Self;
}


pub enum Error {
    ZeroDivisor: (),
}
