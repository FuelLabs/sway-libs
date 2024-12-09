library;

use std::{convert::TryFrom, u128::U128};
use ::signed_integers::common::WrappingNeg;
use ::signed_integers::errors::Error;

/// The 128-bit signed integer type.
///
/// # Additional Information
///
/// Represented as an underlying U128 value.
/// Actual value is underlying value minus 2 ^ 127
/// Max value is 2 ^ 127 - 1, min value is - 2 ^ 127
pub struct I128 {
    /// The underlying unsigned number representing the `I128` type.
    underlying: U128,
}

impl I128 {
    /// The underlying value that corresponds to zero value.
    ///
    /// # Returns
    ///
    /// * [U128] - The unsigned integer value representing a zero value.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i128::I128;
    /// use std::U128::*;
    ///
    /// fn foo() {
    ///     let zero = I128::indent();
    ///     assert(zero == (U128::max() / (U128::from(0, 2)) - U128::from(0,1));
    /// }
    /// ```
    pub fn indent() -> U128 {
        U128::from((9223372036854775808, 0))
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

impl core::ops::OrdEq for I128 {}

impl core::ops::TotalOrd for I128 {
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

impl I128 {
    /// The smallest value that can be represented by this integer type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i128::I128;
    ///
    /// fn foo() {
    ///     let i128 = I128::MIN;
    ///     assert(i128.underlying() == U128::min());
    /// }
    /// ```
    const MIN: Self = Self {
        underlying: U128::min(),
    };

    /// The largest value that can be represented by this integer type.
    ///
    /// # Returns
    ///
    /// * [I128] - The newly created `I128` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i128::I128;
    ///
    /// fn foo() {
    ///     let i128 = I128::MAX;
    ///     assert(i128.underlying() == U128::max());
    /// }
    /// ```
    const MAX: Self = Self {
        underlying: U128::max(),
    };

    /// The size of this type in bits.
    ///
    /// # Returns
    ///
    /// [u64] - The defined size of the `I128` type.
    ///
    /// # Examples
    ///
    /// ``sway
    /// use sway_libs::signed_integers::i128::I128;
    ///
    /// fn foo() {
    ///     let bits = I128::bits();
    ///     assert(bits == 128);
    /// }
    /// ```
    pub fn bits() -> u64 {
        128
    }

    /// Helper function to get a positive value from an unsigned number.
    ///
    /// # Arguments
    ///
    /// * `underlying`: [U128] - The unsigned number to become the underlying value for the `I128`.
    ///
    /// # Returns
    ///
    /// * [I128] - The newly created `I128` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i128::I128;
    /// use std::U128::*;
    ///
    /// fn foo() {
    ///     let underlying = U128::from((0, 1));
    ///     let i128 = I128::from_uint(underlying);
    ///     assert(i128.underlying() == underlying);
    /// }
    /// ```
    pub fn from_uint(underlying: U128) -> Self {
        Self { underlying }
    }

    /// Helper function to get a negative value of an unsigned number.
    ///
    /// # Arguments
    ///
    /// * `value`: [U128] - The unsigned number to negate.
    ///
    /// # Returns
    ///
    /// * [Option<I128>] - The newly created `I128` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i128::I128;
    /// use std::U128::*;
    ///
    /// fn foo() {
    ///     let underlying = U128::from((1, 0));
    ///     let i128 = I128::neg_try_from(underlying).unwrap();
    ///     assert(i128.underlying() == U128::from((0, 0)));
    /// }
    /// ```
    pub fn neg_try_from(value: U128) -> Option<Self> {
        if value <= Self::indent() {
            Some(Self {
                underlying: Self::indent() - value,
            })
        } else {
            None
        }
    }

    /// Initializes a new, zeroed I128.
    ///
    /// # Additional Information
    ///
    /// The zero value of I128 is U128::from((9223372036854775808, 0)).
    ///
    /// # Returns
    ///
    /// * [I128] - The newly created `I128` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i128::I128;
    /// use std::U128::*;
    ///
    /// fn foo() {
    ///     let i128 = I128::new();
    ///     assert(i128.underlying() == U128::from(1, 0));
    /// }
    /// ```
    pub fn new() -> Self {
        Self {
            underlying: Self::indent(),
        }
    }

    /// The zero value `I128`.
    ///
    /// # Returns
    ///
    /// * [I128] - The newly created `I128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i128::I128;
    /// use std::u128::U128;
    ///
    /// fn foo() {
    ///     let i128 = I128::zero();
    ///     assert(i128.underlying() == U128::from((1, 0)));
    /// }
    /// ```
    pub fn zero() -> Self {
        Self {
            underlying: Self::indent(),
        }
    }

    /// Returns whether a `I128` is set to zero.
    ///
    /// # Returns
    ///
    /// * [bool] -> True if the `I128` is zero, otherwise false.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i128::I128;
    ///
    /// fn foo() {
    ///     let i128 = I128::zero();
    ///     assert(i128.is_zero());
    /// }
    /// ```
    pub fn is_zero(self) -> bool {
        self.underlying == Self::indent()
    }

    /// Returns the underlying `u128` representing the `I128`.
    ///
    /// # Returns
    ///
    /// * [u128] - The `u128` representing the `I128`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i128::I128;
    /// use std::u128::U128;
    ///
    /// fn foo() {
    ///     let i128 = I128::zero();
    ///     assert(i128.underlying() == U128::from((9223372036854775808, 0)));
    /// }
    /// ```
    pub fn underlying(self) -> U128 {
        self.underlying
    }
}

impl core::ops::Add for I128 {
    /// Add a I128 to a I128. Panics on overflow.
    fn add(self, other: Self) -> Self {
        // subtract 1 << 63 to avoid double move
        let mut res = Self::new();
        if (self.underlying > Self::indent() || self.underlying == Self::indent()) {
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
        } else if (self.underlying > Self::indent()
            || self.underlying == Self::indent())
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

impl core::ops::Multiply for I128 {
    /// Multiply a I128 with a I128. Panics of overflow.
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

impl core::ops::Subtract for I128 {
    /// Subtract a I128 from a I128. Panics of overflow.
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

impl WrappingNeg for I128 {
    fn wrapping_neg(self) -> Self {
        // TODO: Replace the hardcoded min with Self::MIN once https://github.com/FuelLabs/sway/issues/6772 is closed
        let min = Self {
            underlying: U128::min()
        };
        if self == min {
            return min
        }
        self * Self::neg_try_from(U128::from((0, 1))).unwrap()
    }
}

impl TryFrom<U128> for I128 {
    fn try_from(value: U128) -> Option<Self> {
        // as the minimal value of I128 is -I128::indent() (1 << 63) we should add I128::indent() (1 << 63) 
        if value < U128::max() - Self::indent() {
            Some(Self {
                underlying: value + Self::indent(),
            })
        } else {
            None
        }
    }
}

impl TryFrom<I128> for U128 {
    fn try_from(value: I128) -> Option<Self> {
        if value >= I128::zero() {
            Some(value.underlying - I128::indent())
        } else {
            None
        }
    }
}
