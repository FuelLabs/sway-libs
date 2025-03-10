library;

use std::{convert::{TryFrom, TryInto}, flags::panic_on_unsafe_math_enabled};
use ::signed_integers::errors::Error;
use ::signed_integers::common::WrappingNeg;

/// The 16-bit signed integer type.
///
/// # Additional Information
///
/// Represented as an underlying u16 value.
/// Actual value is underlying value minus 2 ^ 15
/// Max value is 2 ^ 15 - 1, min value is - 2 ^ 15
pub struct I16 {
    /// The underlying value representing the signed integer.
    underlying: u16,
}

impl I16 {
    /// The underlying value that corresponds to zero value.
    ///
    /// # Returns
    ///
    /// [u16] - The unsigned integer value representing a zero value.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i16::I16;
    ///
    /// fn foo() {
    ///     let zero = I16::indent();
    ///     assert(zero == 32768u16);
    /// }
    /// ```
    pub fn indent() -> u16 {
        32768u16
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

impl core::ops::OrdEq for I16 {}

impl core::ops::TotalOrd for I16 {
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

impl I16 {
    /// The smallest value that can be represented by this integer type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i16::I16;
    ///
    /// fn foo() {
    ///     let i16 = I16::MIN;
    ///     assert(i16.underlying() == u16::min());
    /// }
    /// ```
    const MIN: Self = Self {
        underlying: u16::min(),
    };

    /// The largest value that can be represented by this integer type.
    ///
    /// # Returns
    ///
    /// * [I16] - The newly created `I16` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i16::I16;
    ///
    /// fn foo() {
    ///     let i16 = I16::MAX;
    ///     assert(i16.underlying() == u16::max());
    /// }
    /// ```
    const MAX: Self = Self {
        underlying: u16::max(),
    };

    /// The size of this type in bits.
    ///
    /// # Returns
    ///
    /// [u64] - The defined size of the `I16` type.
    ///
    /// # Examples
    ///
    /// ``sway
    /// use sway_libs::signed_integers::i16::I16;
    ///
    /// fn foo() {
    ///     let bits = I16::bits();
    ///     assert(bits == 16);
    /// }
    /// ```
    pub fn bits() -> u64 {
        16
    }

    /// Helper function to get a positive value from an unsigned number
    ///
    /// # Arguments
    ///
    /// * `underlying`: [u16] - The unsigned number to become the underlying value for the `I16`.
    ///
    /// # Returns
    ///
    /// * [I16] - The newly created `I16` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i16::I16;
    ///
    /// fn foo() {
    ///     let underlying = 1u16;
    ///     let i16 = I16::from_uint(underlying);
    ///     assert(i16.underlying() == underlying);
    /// }
    /// ```
    pub fn from_uint(underlying: u16) -> Self {
        Self { underlying }
    }

    /// Helper function to get a negative value of an unsigned number.
    ///
    /// # Arguments
    ///
    /// * `value`: [u16] - The unsigned number to negate.
    ///
    /// # Returns
    ///
    /// * [Option<I16>] - The newly created `I16` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i16::I16;
    ///
    /// fn foo() {
    ///     let underlying = 1u16;
    ///     let i16 = I16::neg_try_from(underlying).unwrap();
    ///     assert(i16.underlying() == 32767u16)
    /// }
    /// ```
    pub fn neg_try_from(value: u16) -> Option<Self> {
        if value <= Self::indent() {
            Some(Self {
                underlying: Self::indent() - value,
            })
        } else {
            None
        }
    }

    /// Initializes a new, zeroed I16.
    ///
    /// # Additional Information
    ///
    /// The zero value of I16 is 32768u16.
    ///
    /// # Returns
    ///
    /// * [I16] - The newly created `I16` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i16::I16;
    ///
    /// fn foo() {
    ///     let i16 = I16::new();
    ///     assert(i16.underlying() == 32768u16);
    /// }
    /// ```
    pub fn new() -> Self {
        Self {
            underlying: Self::indent(),
        }
    }

    /// The zero value `I16`.
    ///
    /// # Returns
    ///
    /// * [I16] - The newly created `I16` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i16::I16;
    ///
    /// fn foo() {
    ///     let i16 = I16::zero();
    ///     assert(i16.underlying() == 32768u16);
    /// }
    /// ```
    pub fn zero() -> Self {
        Self {
            underlying: Self::indent(),
        }
    }

    /// Returns whether a `I16` is set to zero.
    ///
    /// # Returns
    ///
    /// * [bool] -> True if the `I16` is zero, otherwise false.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i16::I16;
    ///
    /// fn foo() {
    ///     let i16 = I16::zero();
    ///     assert(i16.is_zero());
    /// }
    /// ```
    pub fn is_zero(self) -> bool {
        self.underlying == Self::indent()
    }

    /// Returns the underlying `u16` representing the `I16`.
    ///
    /// # Returns
    ///
    /// * [u16] - The `u16` representing the `I16`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i16::I16;
    ///
    /// fn foo() {
    ///     let i16 = I16::zero();
    ///     assert(i16.underlying() == 32768u16);
    /// }
    /// ```
    pub fn underlying(self) -> u16 {
        self.underlying
    }
}

impl core::ops::Add for I16 {
    /// Add a I16 to a I16. Panics on overflow.
    fn add(self, other: Self) -> Self {
        let mut res = Self::new();
        if self.underlying >= Self::indent() {
            res = Self::from_uint(self.underlying - Self::indent() + other.underlying) // subtract 1 << 15 to avoid double move
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

impl core::ops::Divide for I16 {
    /// Divide a I16 by a I16. Panics if divisor is zero.
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

impl core::ops::Multiply for I16 {
    /// Multiply a I16 with a I16. Panics of overflow.
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

impl core::ops::Subtract for I16 {
    /// Subtract a I16 from a I16. Panics of overflow.
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

impl WrappingNeg for I16 {
    fn wrapping_neg(self) -> Self {
        // TODO: Replace the hardcoded min with Self::MIN once https://github.com/FuelLabs/sway/issues/6772 is closed
        let min = Self {
            underlying: u16::min(),
        };
        if self == min {
            return min
        }
        self * Self::neg_try_from(1u16).unwrap()
    }
}

impl TryFrom<u16> for I16 {
    fn try_from(value: u16) -> Option<Self> {
        // as the minimal value of I16 is -I16::indent() (1 << 15) we should add I16::indent() (1 << 15)
        if value < Self::indent() {
            Some(Self {
                underlying: value + Self::indent(),
            })
        } else {
            None
        }
    }
}

impl TryInto<u16> for I16 {
    fn try_into(self) -> Option<u16> {
        if self.underlying >= Self::indent() {
            Some(self.underlying - Self::indent())
        } else {
            None
        }
    }
}

impl TryFrom<I16> for u16 {
    fn try_from(value: I16) -> Option<Self> {
        if value >= I16::zero() {
            Some(value.underlying - I16::indent())
        } else {
            None
        }
    }
}

impl TryInto<I16> for u16 {
    fn try_into(self) -> Option<I16> {
        if self < I16::indent() {
            Some(I16 {
                underlying: self + I16::indent(),
            })
        } else {
            None
        }
    }
}
