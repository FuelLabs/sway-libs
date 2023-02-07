library i128;

use std::u128::U128;
use ::errors::Error;

/// The 128-bit signed integer type.
/// Represented as an underlying U128 value.
/// Actual value is underlying value minus 2 ^ 127
/// Max value is 2 ^ 127 - 1, min value is - 2 ^ 127
pub struct I128 {
    underlying: U128,
}

impl I128 {
    /// The underlying value that corresponds to zero signed value
    pub fn indent() -> U128 {
        U128 {
            upper: 1,
            lower: 0,
        }
    }
}

impl From<U128> for I128 {
    /// Helper function to get a signed number from with an underlying
    fn from(value: U128) -> Self {
        // as the minimal value of I128 is -I128::indent() (1 << 63) we should add I128::indent() (1 << 63) 
        let underlying: U128 = value + Self::indent();
        Self { underlying }
    }

    fn into(self) -> U128 {
        self.underlying - Self::indent()
    }
}

impl core::ops::Eq for I128 {
    fn eq(self, other: Self) -> bool {
        self.underlying == other.underlying
    }
}

impl core::ops::Ord for I128 {
    fn gt(self, other: Self) -> bool {
        self.underlying > other.underlying
    }

    fn lt(self, other: Self) -> bool {
        self.underlying < other.underlying
    }
}

impl I128 {
    /// The size of this type in bits.
    pub fn bits() -> u32 {
        128
    }

    /// Helper function to get a positive value from an unsigned number
    pub fn from_uint(underlying: U128) -> Self {
        Self { underlying }
    }

    /// The largest value that can be represented by this integer type,
    pub fn max() -> Self {
        Self {
            underlying: U128::max(),
        }
    }

    /// The smallest value that can be represented by this integer type.
    pub fn min() -> Self {
        Self {
            underlying: U128::min(),
        }
    }

    /// Helper function to get a negative value of an unsigned number
    pub fn neg_from(value: U128) -> Self {
        Self {
            underlying: Self::indent() - value,
        }
    }

    /// Initializes a new, zeroed I128.
    pub fn new() -> Self {
        Self {
            underlying: Self::indent(),
        }
    }
}

impl core::ops::Add for I128 {
    /// Add a I128 to a I128. Panics on overflow.
    fn add(self, other: Self) -> Self {
        // subtract 1 << 63 to avoid double move
        let mut res = Self::new();
        if (self.underlying > Self::indent()
            || self.underlying == Self::indent())
        {
            res = Self::from_uint(self.underlying - Self::indent() + other.underlying) // subtract 1 << 31 to avoid double move
        } else if self.underlying < Self::indent()
            && other.underlying < Self::indent()
        {
            res = Self::from_uint(self.underlying + other.underlying - Self::indent());
        } else if self.underlying < Self::indent()
            && (other.underlying > Self::indent()
            || other.underlying == Self::indent())
        {
            res = Self::from_uint(other.underlying - Self::indent() + self.underlying);
        }
        res
    }
}

impl core::ops::Divide for I128 {
    /// Divide a I128 by a I128. Panics if divisor is zero.
    fn divide(self, divisor: Self) -> Self {
        require(divisor != Self::new(), Error::ZeroDivisor);
        let mut res = Self::new();
        if (self.underlying > Self::indent()
            || self.underlying == Self::indent())
            && divisor.underlying > Self::indent()
        {
            res = Self::from_uint((self.underlying - Self::indent()) / (divisor.underlying - Self::indent()) + Self::indent());
        } else if self.underlying < Self::indent()
            && divisor.underlying < Self::indent()
        {
            res = Self::from_uint((Self::indent() - self.underlying) / (Self::indent() - divisor.underlying) + Self::indent());
        } else if (self.underlying > Self::indent()
            || self.underlying == Self::indent())
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

impl core::ops::Multiply for I128 {
    /// Multiply a I128 with a I128. Panics of overflow.
    fn multiply(self, other: Self) -> Self {
        let mut res = Self::new();
        if (self.underlying > Self::indent()
            || self.underlying == Self::indent())
            && (other.underlying > Self::indent()
            || other.underlying == Self::indent())
        {
            res = Self::from_uint((self.underlying - Self::indent()) * (other.underlying - Self::indent()) + Self::indent());
        } else if self.underlying < Self::indent()
            && other.underlying < Self::indent()
        {
            res = Self::from_uint((Self::indent() - self.underlying) * (Self::indent() - other.underlying) + Self::indent());
        } else if (self.underlying > Self::indent()
            || self.underlying == Self::indent())
            && other.underlying < Self::indent()
        {
            res = Self::from_uint(Self::indent() - (self.underlying - Self::indent()) * (Self::indent() - other.underlying));
        } else if self.underlying < Self::indent()
            && (other.underlying > Self::indent()
            || other.underlying == Self::indent())
        {
            res = Self::from_uint(Self::indent() - (other.underlying - Self::indent()) * (Self::indent() - self.underlying));
        }
        res
    }
}

impl core::ops::Subtract for I128 {
    /// Subtract a I128 from a I128. Panics of overflow.
    fn subtract(self, other: Self) -> Self {
        let mut res = Self::new();
        if (self.underlying > Self::indent()
            || self.underlying == Self::indent())
            && (other.underlying > Self::indent()
            || other.underlying == Self::indent())
        {
            if self.underlying > other.underlying {
                res = Self::from_uint(self.underlying - other.underlying + Self::indent());
            } else {
                res = Self::from_uint(self.underlying - (other.underlying - Self::indent()));
            }
        } else if (self.underlying > Self::indent()
            || self.underlying == Self::indent())
            && other.underlying < Self::indent()
        {
            res = Self::from_uint(self.underlying - Self::indent() + other.underlying);
        } else if self.underlying < Self::indent()
            && (other.underlying > Self::indent()
            || other.underlying == Self::indent())
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
