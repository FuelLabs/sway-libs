library i16;

use core::num::*;
use ::signed_integers::common::Error;
use ::signed_integers::common::TwosComplement;

/// The 16-bit signed integer type.
/// Represented as an underlying u16 value.
/// Actual value is underlying value minus 2 ^ 15
/// Max value is 2 ^ 15 - 1, min value is - 2 ^ 15
pub struct I16 {
    underlying: u16,
}

pub trait From {
    /// Function for creating I16 from u16
    fn from(underlying: u16) -> Self;
}

impl From for I16 {
    /// Helper function to get a signed number from with an underlying
    fn from(underlying: u16) -> Self {
        Self { underlying }
    }
}

impl core::ops::Eq for I16 {
    fn eq(self, other: Self) -> bool {
        self.underlying == other.underlying
    }
}

impl core::ops::Ord for I16 {
    fn gt(self, other: Self) -> bool {
        self.underlying > other.underlying
    }

    fn lt(self, other: Self) -> bool {
        self.underlying < other.underlying
    }
}

impl I16 {
    /// The underlying value that corresponds to zero signed value
    pub fn indent() -> u16 {
        32768u16
    }
}

impl I16 {
    /// The size of this type in bits.
    pub fn bits() -> u32 {
        16
    }

    /// Helper function to get a positive value from unsigned number
    fn from_uint(value: u16) -> Self {
        // as the minimal value of I16 is -~I16::indent() (1 << 15) we should add ~I16::indent() (1 << 15)
        let underlying: u16 = value + ~Self::indent();
        Self { underlying }
    }

    /// The largest value that can be represented by this type,
    pub fn max() -> Self {
        Self {
            underlying: ~u16::max(),
        }
    }

    /// The smallest value that can be represented by this integer type.
    pub fn min() -> Self {
        Self {
            underlying: ~u16::min(),
        }
    }

    /// Helper function to get a negative value of unsigned number
    pub fn neg_from(value: u16) -> Self {
        Self {
            underlying: ~Self::indent() - value,
        }
    }

    /// Initializes a new, zeroed I16.
    pub fn new() -> Self {
        Self {
            underlying: ~Self::indent(),
        }
    }
}

impl core::ops::Add for I16 {
    /// Add a I16 to a I16. Panics on overflow.
    fn add(self, other: Self) -> Self {
        // subtract 1 << 15 to avoid double move
        ~Self::from(self.underlying - ~Self::indent() + other.underlying)
    }
}

impl core::ops::Divide for I16 {
    /// Divide a I16 by a I16. Panics if divisor is zero.
    fn divide(self, divisor: Self) -> Self {
        require(divisor != ~Self::new(), Error::ZeroDivisor);
        let mut res = ~Self::new();
        if self.underlying >= ~Self::indent()
            && divisor.underlying > ~Self::indent()
        {
            res = ~Self::from((self.underlying - ~Self::indent()) / (divisor.underlying - ~Self::indent()) + ~Self::indent());
        } else if self.underlying < ~Self::indent()
            && divisor.underlying < ~Self::indent()
        {
            res = ~Self::from((~Self::indent() - self.underlying) / (~Self::indent() - divisor.underlying) + ~Self::indent());
        } else if self.underlying >= ~Self::indent()
            && divisor.underlying < ~Self::indent()
        {
            res = ~Self::from(~Self::indent() - (self.underlying - ~Self::indent()) / (~Self::indent() - divisor.underlying));
        } else if self.underlying < ~Self::indent()
            && divisor.underlying > ~Self::indent()
        {
            res = ~Self::from(~Self::indent() - (~Self::indent() - self.underlying) / (divisor.underlying - ~Self::indent()));
        }
        res
    }
}

impl core::ops::Multiply for I16 {
    /// Multiply a I16 with a I16. Panics of overflow.
    fn multiply(self, other: Self) -> Self {
        let mut res = ~Self::new();
        if self.underlying >= ~Self::indent()
            && other.underlying >= ~Self::indent()
        {
            res = ~Self::from((self.underlying - ~Self::indent()) * (other.underlying - ~Self::indent()) + ~Self::indent());
        } else if self.underlying < ~Self::indent()
            && other.underlying < ~Self::indent()
        {
            res = ~Self::from((~Self::indent() - self.underlying) * (~Self::indent() - other.underlying) + ~Self::indent());
        } else if self.underlying >= ~Self::indent()
            && other.underlying < ~Self::indent()
        {
            res = ~Self::from(~Self::indent() - (self.underlying - ~Self::indent()) * (~Self::indent() - other.underlying));
        } else if self.underlying < ~Self::indent()
            && other.underlying >= ~Self::indent()
        {
            res = ~Self::from(~Self::indent() - (other.underlying - ~Self::indent()) * (~Self::indent() - self.underlying));
        }
        res
    }
}

impl core::ops::Subtract for I16 {
    /// Subtract a I16 from a I16. Panics of overflow.
    fn subtract(self, other: Self) -> Self {
        let mut res = ~Self::new();
        if self > other {
            // add 1 << 15 to avoid loosing the move
            res = ~Self::from(self.underlying - other.underlying + ~Self::indent());
        } else {
            // subtract from 1 << 15 as we are getting a negative value
            res = ~Self::from(~Self::indent() - (other.underlying - self.underlying));
        }
        res
    }
}

impl TwosComplement for I16 {
    fn twos_complement(self) -> Self {
        let one = ~I16::from_uint(1u16);
        let res = !self - one;
        res
    } 
}