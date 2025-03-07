library;

use std::{convert::{TryFrom, TryInto}, flags::panic_on_unsafe_math_enabled};
use ::signed_integers::common::WrappingNeg;
use ::signed_integers::errors::Error;

/// The 32-bit signed integer type.
///
/// # Additional Information
///
/// Represented as an underlying u32 value.
/// Actual value is underlying value minus 2 ^ 31
/// Max value is 2 ^ 31 - 1, min value is - 2 ^ 31
pub struct I32 {
    /// The underlying u32 type that represent a I32.
    underlying: u32,
}

impl I32 {
    /// The underlying value that corresponds to zero value.
    ///
    /// # Returns
    ///
    /// * [u32] - The unsigned integer value representing a zero value.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i32::I32;
    ///
    /// fn foo() {
    ///     let zero = I32::indent();
    ///     assert(zero == 2147483648u32);
    /// }
    /// ```
    pub fn indent() -> u32 {
        2147483648u32
    }
}

impl core::ops::Eq for I32 {
    fn eq(self, other: Self) -> bool {
        self.underlying == other.underlying
    }
}

impl core::ops::Ord for I32 {
    fn gt(self, other: Self) -> bool {
        self.underlying > other.underlying
    }

    fn lt(self, other: Self) -> bool {
        self.underlying < other.underlying
    }
}

impl core::ops::OrdEq for I32 {}

impl I32 {
    /// The size of this type in bits.
    ///
    /// # Returns
    ///
    /// [u64] - The defined size of the `I32` type.
    ///
    /// # Examples
    ///
    /// ``sway
    /// use sway_libs::signed_integers::i32::I32;
    ///
    /// fn foo() {
    ///     let bits = I32::bits();
    ///     assert(bits == 32);
    /// }
    /// ```
    pub fn bits() -> u64 {
        32
    }

    /// Helper function to get a signed number from with an underlying.
    ///
    /// # Arguments
    ///
    /// * `underlying`: [u32] - The unsigned number to become the underlying value for the `I32`.
    ///
    /// # Returns
    ///
    /// * [I32] - The newly created `I32` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i32::I32;
    ///
    /// fn foo() {
    ///     let underlying = 1u32;
    ///     let i32 = I32::from_uint(underlying);
    ///     assert(i32.underlying() == underlying);
    /// }
    /// ```
    pub fn from_uint(underlying: u32) -> Self {
        Self { underlying }
    }

    /// The largest value that can be represented by this integer type.
    ///
    /// # Returns
    ///
    /// * [I32] - The newly created `I32` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i32::I32;
    ///
    /// fn foo() {
    ///     let i32 = I32::max();
    ///     assert(i32.underlying() == u32::max());
    /// }
    /// ```
    pub fn max() -> Self {
        Self {
            underlying: u32::max(),
        }
    }

    /// The smallest value that can be represented by this integer type.
    ///
    /// # Returns
    ///
    /// * [I32] - The newly created `I32` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i32::I32;
    ///
    /// fn foo() {
    ///     let i32 = I32::min();
    ///     assert(i32.underlying() == u32::min());
    /// }
    /// ```
    pub fn min() -> Self {
        Self {
            underlying: u32::min(),
        }
    }

    /// Helper function to get a negative value of an unsigned numbers.
    ///
    /// # Arguments
    ///
    /// * `value`: [u32] - The unsigned number to negate.
    ///
    /// # Returns
    ///
    /// * [Option<I32>] - The newly created `I32` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i32::I32;
    ///
    /// fn foo() {
    ///     let underlying = 1u32;
    ///     let i32 = I32::neg_try_from(underlying).unwrap();
    ///     assert(i32.underlying() == 2147483647u32)
    /// }
    /// ```
    pub fn neg_try_from(value: u32) -> Option<Self> {
        if value <= Self::indent() {
            Some(Self {
                underlying: Self::indent() - value,
            })
        } else {
            None
        }
    }

    /// Initializes a new, zeroed I32.
    ///
    /// # Additional Information
    ///
    /// The zero value of I32 is 2147483648u32.
    ///
    /// # Returns
    ///
    /// * [I32] - The newly created `I32` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i32::I32;
    ///
    /// fn foo() {
    ///     let i32 = I32::new();
    ///     assert(i32.underlying() == 2147483648u32);
    /// }
    /// ```
    pub fn new() -> Self {
        Self {
            underlying: Self::indent(),
        }
    }

    /// The zero value `I32`.
    ///
    /// # Returns
    ///
    /// * [I32] - The newly created `I32` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i32::I32;
    ///
    /// fn foo() {
    ///     let i32 = I32::zero();
    ///     assert(i32.underlying() == 2147483648u32);
    /// }
    /// ```
    pub fn zero() -> Self {
        Self {
            underlying: Self::indent(),
        }
    }

    /// Returns whether a `I32` is set to zero.
    ///
    /// # Returns
    ///
    /// * [bool] -> True if the `I32` is zero, otherwise false.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i32::I32;
    ///
    /// fn foo() {
    ///     let i32 = I32::zero();
    ///     assert(i32.is_zero());
    /// }
    /// ```
    pub fn is_zero(self) -> bool {
        self.underlying == Self::indent()
    }

    /// Returns the underlying `u32` representing the `I32`.
    ///
    /// # Returns
    ///
    /// * [u32] - The `u32` representing the `I32`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i32::I32;
    ///
    /// fn foo() {
    ///     let i32 = I32::zero();
    ///     assert(i32.underlying() == 2147483648u32);
    /// }
    /// ```
    pub fn underlying(self) -> u32 {
        self.underlying
    }
}

impl core::ops::Add for I32 {
    /// Add a I32 to a I32. Panics on overflow.
    fn add(self, other: Self) -> Self {
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

impl core::ops::Subtract for I32 {
    /// Subtract a I32 from a I32. Panics of overflow.
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

impl core::ops::Multiply for I32 {
    /// Multiply a I32 with a I32. Panics of overflow.
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

impl core::ops::Divide for I32 {
    /// Divide a I32 by a I32. Panics if divisor is zero.
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

impl WrappingNeg for I32 {
    fn wrapping_neg(self) -> Self {
        if self == Self::min() {
            return Self::min()
        }
        self * Self::neg_try_from(1u32).unwrap()
    }
}

impl TryFrom<u32> for I32 {
    fn try_from(value: u32) -> Option<Self> {
        // as the minimal value of I32 is 2147483648 (1 << 31) we should add I32::indent() (1 << 31) 
        if value < Self::indent() {
            Some(Self {
                underlying: value + Self::indent(),
            })
        } else {
            None
        }
    }
}

impl TryInto<u32> for I32 {
    fn try_into(self) -> Option<u32> {
        if self.underlying >= Self::indent() {
            Some(self.underlying - Self::indent())
        } else {
            None
        }
    }
}

impl TryFrom<I32> for u32 {
    fn try_from(value: I32) -> Option<Self> {
        if value >= I32::zero() {
            Some(value.underlying - I32::indent())
        } else {
            None
        }
    }
}

impl TryInto<I32> for u32 {
    fn try_into(self) -> Option<I32> {
        if self < I32::indent() {
            Some(I32 {
                underlying: self + I32::indent(),
            })
        } else {
            None
        }
    }
}
