library;

use std::{convert::{TryFrom, TryInto}, flags::panic_on_unsafe_math_enabled};
use ::errors::Error;
use ::common::WrappingNeg;

/// The 8-bit signed integer type.
///
/// # Additional Information
///
/// Represented as an underlying u8 value.
/// Actual value is underlying value minus 2 ^ 7
/// Max value is 2 ^ 7 - 1, min value is - 2 ^ 7
pub struct I8 {
    /// The underlying unsigned `u8` type that makes up the signed `I8` type.
    underlying: u8,
}

impl I8 {
    /// The underlying value that corresponds to zero value.
    ///
    /// # Returns
    ///
    /// * [u8] - The unsigned integer value representing a zero value.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i8::I8;
    ///
    /// fn foo() {
    ///     let zero = I8::indent();
    ///     assert(zero == 128u8);
    /// }
    /// ```
    pub fn indent() -> u8 {
        128u8
    }
}

impl PartialEq for I8 {
    fn eq(self, other: Self) -> bool {
        self.underlying == other.underlying
    }
}

impl Eq for I8 {}

impl Ord for I8 {
    fn gt(self, other: Self) -> bool {
        self.underlying > other.underlying
    }

    fn lt(self, other: Self) -> bool {
        self.underlying < other.underlying
    }
}

impl OrdEq for I8 {}

impl TotalOrd for I8 {
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

impl I8 {
    /// The smallest value that can be represented by this integer type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i8::I8;
    ///
    /// fn foo() {
    ///     let i8 = I8::MIN;
    ///     assert(i8.underlying() == u8::min());
    /// }
    /// ```
    const MIN: Self = Self {
        underlying: u8::min(),
    };

    /// The largest value that can be represented by this integer type.
    ///
    /// # Returns
    ///
    /// * [I8] - The newly created `I8` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i8::I8;
    ///
    /// fn foo() {
    ///     let i8 = I8::MAX;
    ///     assert(i8.underlying() == u8::max());
    /// }
    /// ```
    const MAX: Self = Self {
        underlying: u8::max(),
    };

    /// The size of this type in bits.
    ///
    /// # Returns
    ///
    /// * [u64] - The number of bits.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i8::I8;
    ///
    /// fn foo() {
    ///     let bits = I8::bits();
    ///     assert(bits == 8);
    /// }
    /// ```
    pub fn bits() -> u64 {
        8
    }

    /// Helper function to get a signed `I8` from an underlying `u8`.
    ///
    /// # Arguments
    ///
    /// * `underlying`: [u8] - The `u8` that will represent the `I8`.
    ///
    /// # Returns
    ///
    /// * [I8] - The newly created `I8` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i8::I8;
    ///
    /// fn foo() {
    ///     let underlying = 1u8;
    ///     let i8 = I8::from_uint(underlying);
    ///     assert(i8.underlying() == underlying);
    /// }
    /// ```
    pub fn from_uint(underlying: u8) -> Self {
        Self { underlying }
    }

    /// Helper function to get a negative value of an unsigned number.
    ///
    /// # Arguments
    ///
    /// * `value`: [u8] - The unsigned number to negate.
    ///
    /// # Returns
    ///
    /// * [Option<I8>] - The newly created `I8` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i8::I8;
    ///
    /// fn foo() {
    ///     let underlying = 1u8;
    ///     let i8 = I8::neg_try_from(underlying);
    ///     assert(i8.underlying() == 127u8);
    /// }
    /// ```
    pub fn neg_try_from(value: u8) -> Option<Self> {
        if value <= Self::indent() {
            Some(Self {
                underlying: Self::indent() - value,
            })
        } else {
            None
        }
    }

    /// Initializes a new, zeroed I8.
    ///
    /// # Additional Information
    ///
    /// The zero value for I8 is 128u8.
    ///
    /// # Returns
    ///
    /// * [I8] - The newly created `I8` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i8::I8;
    ///
    /// fn foo() {
    ///     let i8 = I8::new();
    ///     assert(i8.underlying() == 128u8);
    /// }
    /// ```
    pub fn new() -> Self {
        Self {
            underlying: Self::indent(),
        }
    }

    /// The zero value `I8`.
    ///
    /// # Returns
    ///
    /// * [I8] - The newly created `I8` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i8::I8;
    ///
    /// fn foo() {
    ///     let i8 = I8::zero();
    ///     assert(i8.underlying() == 128u8);
    /// }
    /// ```
    pub fn zero() -> Self {
        Self {
            underlying: Self::indent(),
        }
    }

    /// Returns whether a `I8` is set to zero.
    ///
    /// # Returns
    ///
    /// * [bool] -> True if the `I8` is zero, otherwise false.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i8::I8;
    ///
    /// fn foo() {
    ///     let i8 = I8::zero();
    ///     assert(i8.is_zero());
    /// }
    /// ```
    pub fn is_zero(self) -> bool {
        self.underlying == Self::indent()
    }

    /// Returns the underlying `u8` representing the `I8`.
    ///
    /// # Returns
    ///
    /// * [u8] - The `u8` representing the `I8`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use signed_int::i8::I8;
    ///
    /// fn foo() {
    ///     let i8 = I8::zero();
    ///     assert(i8.underlying() == 128u8);
    /// }
    /// ```
    pub fn underlying(self) -> u8 {
        self.underlying
    }
}

impl Add for I8 {
    /// Add a I8 to a I8. Panics on overflow.
    fn add(self, other: Self) -> Self {
        let mut res = Self::new();
        if self.underlying >= Self::indent() {
            res = Self::from_uint(self.underlying - Self::indent() + other.underlying) // subtract 1 << 7 to avoid double move
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

impl Divide for I8 {
    /// Divide a I8 by a I8. Panics if divisor is zero.
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

impl Multiply for I8 {
    /// Multiply a I8 with a I8. Panics of overflow.
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

impl Subtract for I8 {
    /// Subtract a I8 from a I8. Panics of overflow.
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

impl WrappingNeg for I8 {
    fn wrapping_neg(self) -> Self {
        // TODO: Replace the hardcoded min with Self::MIN once https://github.com/FuelLabs/sway/issues/6772 is closed
        let min = Self {
            underlying: u8::min(),
        };
        if self == min {
            return min
        }
        self * Self::neg_try_from(1u8).unwrap()
    }
}

impl TryFrom<u8> for I8 {
    fn try_from(value: u8) -> Option<Self> {
        // as the minimal value of I8 is -I8::indent() (1 << 7) we should add I8::indent() (1 << 7)
        if value < Self::indent() {
            Some(Self {
                underlying: value + Self::indent(),
            })
        } else {
            None
        }
    }
}

impl TryInto<u8> for I8 {
    fn try_into(self) -> Option<u8> {
        if self.underlying >= Self::indent() {
            Some(self.underlying - Self::indent())
        } else {
            None
        }
    }
}

impl TryFrom<I8> for u8 {
    fn try_from(value: I8) -> Option<Self> {
        if value >= I8::zero() {
            Some(value.underlying - I8::indent())
        } else {
            None
        }
    }
}

impl TryInto<I8> for u8 {
    fn try_into(self) -> Option<I8> {
        if self < I8::indent() {
            Some(I8 {
                underlying: self + I8::indent(),
            })
        } else {
            None
        }
    }
}
