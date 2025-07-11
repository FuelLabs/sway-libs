library;

use std::{convert::{TryFrom, TryInto}, flags::panic_on_unsafe_math_enabled};
use ::common::WrappingNeg;
use ::errors::Error;

/// The 64-bit signed integer type.
///
/// # Additional Information
///
/// Represented as an underlying u64 value.
/// Actual value is underlying value minus 2 ^ 63
/// Max value is 2 ^ 63 - 1, min value is - 2 ^ 63
pub struct I64 {
    /// The underlying unsigned number representing the `I64` type.
    underlying: u64,
}

impl I64 {
    /// The underlying value that corresponds to zero value.
    ///
    /// # Returns
    ///
    /// * [u64] - The unsigned integer value representing a zero value.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i64::I64;
    ///
    /// fn foo() {
    ///     let zero = I64::indent();
    ///     assert(zero == 9223372036854775808u64);
    /// }
    /// ```
    pub fn indent() -> u64 {
        9223372036854775808u64
    }
}

impl PartialEq for I64 {
    fn eq(self, other: Self) -> bool {
        self.underlying == other.underlying
    }
}

impl Eq for I64 {}

impl Ord for I64 {
    fn gt(self, other: Self) -> bool {
        self.underlying > other.underlying
    }

    fn lt(self, other: Self) -> bool {
        self.underlying < other.underlying
    }
}

impl OrdEq for I64 {}

impl TotalOrd for I64 {
    fn min(self, other: Self) -> Self {
        if self.underlying < other.underlying {
            self
        } else {
            other
        }
    }

    fn max(self, other: Self) -> Self {
        if self.underlying > other.underlying {
            self
        } else {
            other
        }
    }
}

impl I64 {
    /// The smallest value that can be represented by this integer type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i64::I64;
    ///
    /// fn foo() {
    ///     let i64 = I64::MIN;
    ///     assert(i64.underlying() == u64::min());
    /// }
    /// ```
    const MIN: Self = Self {
        underlying: u64::min(),
    };

    /// The largest value that can be represented by this integer type.
    ///
    /// # Returns
    ///
    /// * [I64] - The newly created `I64` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i64::I64;
    ///
    /// fn foo() {
    ///     let i64 = I64::MAX;
    ///     assert(i64.underlying() == u64::max());
    /// }
    /// ```
    const MAX: Self = Self {
        underlying: u64::max(),
    };

    /// The size of this type in bits.
    ///
    /// # Returns
    ///
    /// [u64] - The defined size of the `I64` type.
    ///
    /// # Examples
    ///
    /// ``sway
    /// use signed_int::i64::I64;
    ///
    /// fn foo() {
    ///     let bits = I64::bits();
    ///     assert(bits == 64);
    /// }
    /// ```
    pub fn bits() -> u64 {
        64
    }

    /// Helper function to get a signed number from with an underlying.
    ///
    /// # Arguments
    ///
    /// * `underlying`: [u64] - The unsigned number to become the underlying value for the `I64`.
    ///
    /// # Returns
    ///
    /// * [I64] - The newly created `I64` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i64::I64;
    ///
    /// fn foo() {
    ///     let underlying = 1u64;
    ///     let i64 = I64::from_uint(underlying);
    ///     assert(i64.underlying() == underlying);
    /// }
    /// ```
    pub fn from_uint(underlying: u64) -> Self {
        Self { underlying }
    }

    /// Helper function to get a negative value of an unsigned number.
    ///
    /// # Arguments
    ///
    /// * `value`: [u64] - The unsigned number to negate.
    ///
    /// # Returns
    ///
    /// * [Option<I64>] - The newly created `I64` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i64::I64;
    ///
    /// fn foo() {
    ///     let underlying = 1u64;
    ///     let i64 = I64::neg_try_from(underlying).unwrap();
    ///     assert(i64.underlying() == 9223372036854775807u64);
    /// }
    /// ```
    pub fn neg_try_from(value: u64) -> Option<Self> {
        if value <= Self::indent() {
            Some(Self {
                underlying: Self::indent() - value,
            })
        } else {
            None
        }
    }

    /// Initializes a new, zeroed I64.
    ///
    /// # Additional Information
    ///
    /// The zero value of I64 is 9223372036854775808.
    ///
    /// # Returns
    ///
    /// * [I64] - The newly created `I64` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i64::I64;
    ///
    /// fn foo() {
    ///     let i64 = I64::new();
    ///     assert(i64.underlying() == 9223372036854775808);
    /// }
    /// ```
    pub fn new() -> Self {
        Self {
            underlying: Self::indent(),
        }
    }

    /// The zero value `I64`.
    ///
    /// # Returns
    ///
    /// * [I64] - The newly created `I64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i64::I64;
    ///
    /// fn foo() {
    ///     let i64 = I64::zero();
    ///     assert(i64.underlying() == 9223372036854775808);
    /// }
    /// ```
    pub fn zero() -> Self {
        Self {
            underlying: Self::indent(),
        }
    }

    /// Returns whether a `I64` is set to zero.
    ///
    /// # Returns
    ///
    /// * [bool] -> True if the `I64` is zero, otherwise false.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i64::I64;
    ///
    /// fn foo() {
    ///     let i64 = I64::zero();
    ///     assert(i64.is_zero());
    /// }
    /// ```
    pub fn is_zero(self) -> bool {
        self.underlying == Self::indent()
    }

    /// Returns the underlying `u64` representing the `I64`.
    ///
    /// # Returns
    ///
    /// * [u64] - The `u64` representing the `I64`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i64::I64;
    ///
    /// fn foo() {
    ///     let i64 = I64::zero();
    ///     assert(i64.underlying() == 9223372036854775808);
    /// }
    /// ```
    pub fn underlying(self) -> u64 {
        self.underlying
    }
}

impl Add for I64 {
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

impl Subtract for I64 {
    /// Subtract a I64 from a I64. Panics of overflow.
    fn subtract(self, other: Self) -> Self {
        let mut res = Self::new();
        if self.underlying >= Self::indent() && other.underlying >= Self::indent() { // Both Positive
            if self.underlying > other.underlying {
                res = Self::from_uint(self.underlying - other.underlying + Self::indent());
            } else {
                res = Self::from_uint(self.underlying - (other.underlying - Self::indent()));
            }
        } else if self.underlying >= Self::indent() && other.underlying < Self::indent() { // Self Positive, Other Negative
            res = Self::from_uint(self.underlying - other.underlying + Self::indent());
        } else if self.underlying < Self::indent() && other.underlying >= Self::indent() { // Self Negative, Other Positive
            res = Self::from_uint(self.underlying - (other.underlying - Self::indent()));
        } else if self.underlying < Self::indent() && other.underlying < Self::indent() { // Both Negative
            if self.underlying > other.underlying {
                res = Self::from_uint(self.underlying - other.underlying + Self::indent());
            } else {
                res = Self::from_uint((self.underlying + Self::indent()) - other.underlying);
            }
        }
        res
    }
}

impl Multiply for I64 {
    /// Multiply a I64 with a I64. Panics of overflow.
    fn multiply(self, other: Self) -> Self {
        let mut res = Self::new();
        if self.underlying >= Self::indent()
            && other.underlying >= Self::indent()
        {
            res = Self::from_uint(
                (self.underlying - Self::indent()) * (other.underlying - Self::indent()) + Self::indent(),
            );
        } else if self.underlying < Self::indent()
            && other.underlying < Self::indent()
        {
            res = Self::from_uint(
                (Self::indent() - self.underlying) * (Self::indent() - other.underlying) + Self::indent(),
            );
        } else if self.underlying >= Self::indent()
            && other.underlying < Self::indent()
        {
            res = Self::from_uint(
                Self::indent() - (self.underlying - Self::indent()) * (Self::indent() - other.underlying),
            );
        } else if self.underlying < Self::indent()
            && other.underlying >= Self::indent()
        {
            res = Self::from_uint(
                Self::indent() - (other.underlying - Self::indent()) * (Self::indent() - self.underlying),
            );
        }
        res
    }
}

impl Divide for I64 {
    /// Divide a I64 by a I64. Panics if divisor is zero.
    fn divide(self, divisor: Self) -> Self {
        if panic_on_unsafe_math_enabled() {
            require(divisor != Self::new(), Error::ZeroDivisor);
        }

        let mut res = Self::new();
        if self.underlying >= Self::indent()
            && divisor.underlying > Self::indent()
        {
            res = Self::from_uint(
                (self.underlying - Self::indent()) / (divisor
                        .underlying - Self::indent()) + Self::indent(),
            );
        } else if self.underlying < Self::indent()
            && divisor.underlying < Self::indent()
        {
            res = Self::from_uint(
                (Self::indent() - self.underlying) / (Self::indent() - divisor
                        .underlying) + Self::indent(),
            );
        } else if self.underlying >= Self::indent()
            && divisor.underlying < Self::indent()
        {
            res = Self::from_uint(
                Self::indent() - (self.underlying - Self::indent()) / (Self::indent() - divisor
                        .underlying),
            );
        } else if self.underlying < Self::indent()
            && divisor.underlying > Self::indent()
        {
            res = Self::from_uint(
                Self::indent() - (Self::indent() - self.underlying) / (divisor
                        .underlying - Self::indent()),
            );
        }
        res
    }
}

impl WrappingNeg for I64 {
    fn wrapping_neg(self) -> Self {
        // TODO: Replace the hardcoded min with Self::MIN once https://github.com/FuelLabs/sway/issues/6772 is closed
        let min = Self {
            underlying: u64::min(),
        };
        if self == min {
            return min
        }
        self * Self::neg_try_from(1).unwrap()
    }
}

impl TryFrom<u64> for I64 {
    fn try_from(value: u64) -> Option<Self> {
        // as the minimal value of I64 is -I64::indent() (1 << 63) we should add I64::indent() (1 << 63) 
        if value < Self::indent() {
            Some(Self {
                underlying: value + Self::indent(),
            })
        } else {
            None
        }
    }
}

impl TryInto<u64> for I64 {
    fn try_into(self) -> Option<u64> {
        if self.underlying >= Self::indent() {
            Some(self.underlying - Self::indent())
        } else {
            None
        }
    }
}

impl TryFrom<I64> for u64 {
    fn try_from(value: I64) -> Option<Self> {
        if value >= I64::zero() {
            Some(value.underlying - I64::indent())
        } else {
            None
        }
    }
}

impl TryInto<I64> for u64 {
    fn try_into(self) -> Option<I64> {
        if self < I64::indent() {
            Some(I64 {
                underlying: self + I64::indent(),
            })
        } else {
            None
        }
    }
}
