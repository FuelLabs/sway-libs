library;

use ::common::TwosComplement;
use ::errors::Error;

/// The 64-bit signed integer type.
/// Represented as an underlying u64 value.
/// Actual value is underlying value minus 2 ^ 63
/// Max value is 2 ^ 63 - 1, min value is - 2 ^ 63
pub struct I64 {
    underlying: u64,
}

impl I64 {
    /// The underlying value that corresponds to zero signed value
    pub fn indent() -> u64 {
        9223372036854775808u64
    }
}

impl From<u64> for I64 {
    fn from(value: u64) -> Self {
        // as the minimal value of I64 is -I64::indent() (1 << 63) we should add I64::indent() (1 << 63) 
        let underlying = value + Self::indent();
        Self { underlying }
    }

    fn into(self) -> u64 {
        self.underlying - Self::indent()
    }
}

impl core::ops::Eq for I64 {
    fn eq(self, other: Self) -> bool {
        self.underlying == other.underlying
    }
}

impl core::ops::Ord for I64 {
    fn gt(self, other: Self) -> bool {
        self.underlying > other.underlying
    }

    fn lt(self, other: Self) -> bool {
        self.underlying < other.underlying
    }
}

impl I64 {
    /// The size of this type in bits.
    pub fn bits() -> u32 {
        64
    }

    /// Helper function to get a signed number from with an underlying
    pub fn from_uint(underlying: u64) -> Self {
        Self { underlying }
    }

    /// The largest value that can be represented by this integer type,
    pub fn max() -> Self {
        Self {
            underlying: u64::max(),
        }
    }

    /// The smallest value that can be represented by this integer type.
    pub fn min() -> Self {
        Self {
            underlying: u64::min(),
        }
    }

    /// Helper function to get a negative value of an unsigned number
    pub fn neg_from(value: u64) -> Self {
        Self {
            underlying: Self::indent() - value,
        }
    }

    /// Initializes a new, zeroed I64.
    pub fn new() -> Self {
        Self {
            underlying: Self::indent(),
        }
    }
}

impl core::ops::Add for I64 {
    /// Add a I64 to a I64. Panics on overflow.
    fn add(self, other: Self) -> Self {
        // subtract 1 << 63 to avoid double move
        let mut res = Self::new();
        if self.underlying >= Self::indent() {
            res = Self::from_uint(self.underlying - Self::indent() + other.underlying) // subtract 1 << 31 to avoid double move
        } else if self.underlying < Self::indent()
            && other.underlying < Self::indent()
        {
            res = Self::from_uint(self.underlying + other.underlying - Self::indent());
        } else if self.underlying < Self::indent()
            && other.underlying >= Self::indent()
        {
            res = Self::from_uint(other.underlying - Self::indent() + self.underlying);
        }
        res
    }
}

impl core::ops::Subtract for I64 {
    /// Subtract a I64 from a I64. Panics of overflow.
    fn subtract(self, other: Self) -> Self {
        let mut res = Self::new();
        if self.underlying >= Self::indent()
            && other.underlying >= Self::indent()
        {
            if self.underlying > other.underlying {
                res = Self::from_uint(self.underlying - other.underlying + Self::indent());
            } else {
                res = Self::from_uint(self.underlying - (other.underlying - Self::indent()));
            }
        } else if self.underlying >= Self::indent()
            && other.underlying < Self::indent()
        {
            res = Self::from_uint(self.underlying - Self::indent() + other.underlying);
        } else if self.underlying < Self::indent()
            && other.underlying >= Self::indent()
        {
            res = Self::from_uint(self.underlying - (other.underlying - Self::indent()));
        } else if self.underlying < Self::indent()
            && other.underlying < Self::indent()
        {
            if self.underlying < other.underlying {
                res = Self::from_uint(other.underlying - self.underlying + Self::indent());
            } else {
                res = Self::from_uint(self.underlying + other.underlying - Self::indent());
            }
        }
        res
    }
}

impl core::ops::Multiply for I64 {
    /// Multiply a I64 with a I64. Panics of overflow.
    fn multiply(self, other: Self) -> Self {
        let mut res = Self::new();
        if self.underlying >= Self::indent()
            && other.underlying >= Self::indent()
        {
            res = Self::from_uint((self.underlying - Self::indent()) * (other.underlying - Self::indent()) + Self::indent());
        } else if self.underlying < Self::indent()
            && other.underlying < Self::indent()
        {
            res = Self::from_uint((Self::indent() - self.underlying) * (Self::indent() - other.underlying) + Self::indent());
        } else if self.underlying >= Self::indent()
            && other.underlying < Self::indent()
        {
            res = Self::from_uint(Self::indent() - (self.underlying - Self::indent()) * (Self::indent() - other.underlying));
        } else if self.underlying < Self::indent()
            && other.underlying >= Self::indent()
        {
            res = Self::from_uint(Self::indent() - (other.underlying - Self::indent()) * (Self::indent() - self.underlying));
        }
        res
    }
}

impl core::ops::Divide for I64 {
    /// Divide a I64 by a I64. Panics if divisor is zero.
    fn divide(self, divisor: Self) -> Self {
        require(divisor != Self::new(), Error::ZeroDivisor);
        let mut res = Self::new();
        if self.underlying >= Self::indent()
            && divisor.underlying > Self::indent()
        {
            res = Self::from_uint((self.underlying - Self::indent()) / (divisor.underlying - Self::indent()) + Self::indent());
        } else if self.underlying < Self::indent()
            && divisor.underlying < Self::indent()
        {
            res = Self::from_uint((Self::indent() - self.underlying) / (Self::indent() - divisor.underlying) + Self::indent());
        } else if self.underlying >= Self::indent()
            && divisor.underlying < Self::indent()
        {
            res = Self::from_uint(Self::indent() - (self.underlying - Self::indent()) / (Self::indent() - divisor.underlying));
        } else if self.underlying < Self::indent()
            && divisor.underlying > Self::indent()
        {
            res = Self::from_uint(Self::indent() - (Self::indent() - self.underlying) / (divisor.underlying - Self::indent()));
        }
        res
    }
}

impl TwosComplement for I64 {
    fn twos_complement(self) -> Self {
        if self.underlying >= Self::indent() {
            return self;
        }
        let res = Self::from_uint(!self.underlying + 1);
        res
    }
}
