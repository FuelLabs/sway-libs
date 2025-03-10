library;

use std::{convert::{TryFrom, TryInto}, flags::panic_on_unsafe_math_enabled};
use ::signed_integers::common::WrappingNeg;
use ::signed_integers::errors::Error;

/// The 256-bit signed integer type.
///
/// # Additional Information
///
/// Represented as an underlying u256 value.
/// Actual value is underlying value minus 2 ^ 255
/// Max value is 2 ^ 255 - 1, min value is - 2 ^ 255
pub struct I256 {
    underlying: u256,
}

impl I256 {
    /// The underlying value that corresponds to zero value.
    ///
    /// # Additional Information
    ///
    /// The zero value for I256 is 0x8000000000000000000000000000000000000000000000000000000000000000u256.
    ///
    /// # Returns
    ///
    /// * [u256] - The unsigned integer value representing a zero value.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i256::I256;
    ///
    /// fn foo() {
    ///     let zero = I256::indent();
    ///     assert(zero == 0x8000000000000000000000000000000000000000000000000000000000000000u256);
    /// }
    /// ```
    pub fn indent() -> u256 {
        0x8000000000000000000000000000000000000000000000000000000000000000u256
    }
}

impl core::ops::Eq for I256 {
    fn eq(self, other: Self) -> bool {
        self.underlying == other.underlying
    }
}

impl core::ops::Ord for I256 {
    fn gt(self, other: Self) -> bool {
        self.underlying > other.underlying
    }

    fn lt(self, other: Self) -> bool {
        self.underlying < other.underlying
    }
}

impl core::ops::OrdEq for I256 {}

impl core::ops::TotalOrd for I256 {
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

impl I256 {
    /// The smallest value that can be represented by this integer type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i256::I256;
    ///
    /// fn foo() {
    ///     let i256 = I256::MIN;
    ///     assert(i256.underlying() == u256::min());
    /// }
    /// ```
    const MIN: Self = Self {
        underlying: u256::min(),
    };

    /// The largest value that can be represented by this integer type.
    ///
    /// # Returns
    ///
    /// * [I256] - The newly created `I256` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i256::I256;
    ///
    /// fn foo() {
    ///     let i256 = I256::MAX;
    ///     assert(i256.underlying() == u256::max());
    /// }
    /// ```
    const MAX: Self = Self {
        underlying: u256::max(),
    };

    /// The size of this type in bits.
    ///
    /// # Returns
    ///
    /// [u64] - The defined size of the `I256` type.
    ///
    /// # Examples
    ///
    /// ``sway
    /// use sway_libs::signed_integers::i256::I256;
    ///
    /// fn foo() {
    ///     let bits = I256::bits();
    ///     assert(bits == 256);
    /// }
    /// ```
    pub fn bits() -> u64 {
        256
    }

    /// Helper function to get a signed number from with an underlying.
    ///
    /// # Arguments
    ///
    /// * `underlying`: [u256] - The unsigned number to become the underlying value for the `I256`.
    ///
    /// # Returns
    ///
    /// * [I256] - The newly created `I256` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i256::I256;
    ///
    /// fn foo() {
    ///     let underlying = 0x0000000000000000000000000000000000000000000000000000000000000001u256;
    ///     let i256 = I256::from_uint(underlying);
    ///     assert(i256.underlying() == underlying);
    /// }
    /// ```
    pub fn from_uint(underlying: u256) -> Self {
        Self { underlying }
    }

    /// Helper function to get a negative value of an unsigned number.
    ///
    /// # Arguments
    ///
    /// * `value`: [u256] - The unsigned number to negate.
    ///
    /// # Returns
    ///
    /// * [Option<I256>] - The newly created `I256` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i256::I256;
    ///
    /// fn foo() {
    ///     let underlying = 0x0000000000000000000000000000000000000000000000000000000000000000u256;
    ///     let i256 = I256::neg_try_from(underlying).unwrap();
    ///     assert(i256.underlying() == 0x8000000000000000000000000000000000000000000000000000000000000000u256);
    /// }
    /// ```
    pub fn neg_try_from(value: u256) -> Option<Self> {
        if value <= Self::indent() {
            Some(Self {
                underlying: Self::indent() - value,
            })
        } else {
            None
        }
    }

    /// Initializes a new, zeroed I256.
    ///
    /// # Additional Information
    ///
    /// The zero value of I256 is 0x8000000000000000000000000000000000000000000000000000000000000000u256.
    ///
    /// # Returns
    ///
    /// * [I256] - The newly created `I256` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i256::I256;
    ///
    /// fn foo() {
    ///     let i256 = I256::new();
    ///     assert(i256.underlying() == 0x8000000000000000000000000000000000000000000000000000000000000000u256);
    /// }
    /// ```
    pub fn new() -> Self {
        Self {
            underlying: Self::indent(),
        }
    }

    /// The zero value `I256`.
    ///
    /// # Returns
    ///
    /// * [I256] - The newly created `I256` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i256::I256;
    ///
    /// fn foo() {
    ///     let i256 = I256::zero();
    ///     assert(i256.underlying() == 0x8000000000000000000000000000000000000000000000000000000000000000u256);
    /// }
    /// ```
    pub fn zero() -> Self {
        Self {
            underlying: Self::indent(),
        }
    }

    /// Returns whether a `I256` is set to zero.
    ///
    /// # Returns
    ///
    /// * [bool] -> True if the `I256` is zero, otherwise false.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i256::I256;
    ///
    /// fn foo() {
    ///     let i256 = I256::zero();
    ///     assert(i256.is_zero());
    /// }
    /// ```
    pub fn is_zero(self) -> bool {
        self.underlying == Self::indent()
    }

    /// Returns the underlying `u256` representing the `I256`.
    ///
    /// # Returns
    ///
    /// * [u256] - The `u256` representing the `I256`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i256::I256;
    ///
    /// fn foo() {
    ///     let i256 = I256::zero();
    ///     assert(i256.underlying() == 0x8000000000000000000000000000000000000000000000000000000000000000u256);
    /// }
    /// ```
    pub fn underlying(self) -> u256 {
        self.underlying
    }
}

impl core::ops::Add for I256 {
    /// Add a I256 to a I256. Panics on overflow.
    fn add(self, other: Self) -> Self {
        // subtract 1 << 63 to avoid double move
        let indent = Self::indent();
        let mut res = Self::new();
        if (self.underlying > indent || self.underlying == indent) {
            res = Self::from_uint(self.underlying - indent + other.underlying) // subtract 1 << 31 to avoid double move
        } else if self.underlying < indent && other.underlying < indent {
            res = Self::from_uint(self.underlying + other.underlying - indent);
        } else if self.underlying < indent
            && (other.underlying > indent
            || other.underlying == indent)
        {
            res = Self::from_uint(other.underlying - indent + self.underlying);
        }
        res
    }
}

impl core::ops::Divide for I256 {
    /// Divide a I256 by a I256. Panics if divisor is zero.
    fn divide(self, divisor: Self) -> Self {
        if panic_on_unsafe_math_enabled() {
            require(divisor != Self::new(), Error::ZeroDivisor);
        }

        let mut res = Self::new();
        let indent = Self::indent();

        let self_ge_indent = self.underlying > indent || self.underlying == indent;
        let divisor_gt_indent = divisor.underlying > indent;
        if self_ge_indent && divisor_gt_indent {
            res = Self::from_uint((self.underlying - indent) / (divisor.underlying - indent) + indent);
        } else if self.underlying < indent && divisor.underlying < indent {
            res = Self::from_uint((indent - self.underlying) / (indent - divisor.underlying) + indent);
        } else if (self.underlying > indent
            || self.underlying == indent)
            && divisor.underlying < indent
        {
            res = Self::from_uint(indent - (self.underlying - indent) / (indent - divisor.underlying));
        } else if self.underlying < indent && divisor.underlying > indent {
            res = Self::from_uint(indent - (indent - self.underlying) / (divisor.underlying - indent));
        }
        res
    }
}

impl core::ops::Multiply for I256 {
    /// Multiply a I256 with a I256. Panics of overflow.
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

impl core::ops::Subtract for I256 {
    /// Subtract a I256 from a I256. Panics of overflow.
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

impl WrappingNeg for I256 {
    fn wrapping_neg(self) -> Self {
        // TODO: Replace the hardcoded min with Self::MIN once https://github.com/FuelLabs/sway/issues/6772 is closed
        let min = Self {
            underlying: u256::min(),
        };
        if self == min {
            return min
        }
        self * Self::neg_try_from(0x0000000000000000000000000000000000000000000000000000000000000001u256).unwrap()
    }
}

impl TryFrom<u256> for I256 {
    fn try_from(value: u256) -> Option<Self> {
        // as the minimal value of I256 is -I256::indent() (1 << 63) we should add I256::indent() (1 << 63) 
        if value < Self::indent() {
            Some(Self {
                underlying: value + Self::indent(),
            })
        } else {
            None
        }
    }
}

impl TryInto<u256> for I256 {
    fn try_into(self) -> Option<u256> {
        if self.underlying >= Self::indent() {
            Some(self.underlying - Self::indent())
        } else {
            None
        }
    }
}

impl TryFrom<I256> for u256 {
    fn try_from(value: I256) -> Option<Self> {
        if value >= I256::zero() {
            Some(value.underlying - I256::indent())
        } else {
            None
        }
    }
}

impl TryInto<I256> for u256 {
    fn try_into(self) -> Option<I256> {
        if self < I256::indent() {
            Some(I256 {
                underlying: self + I256::indent(),
            })
        } else {
            None
        }
    }
}
