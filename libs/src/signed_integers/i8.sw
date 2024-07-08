library;

use ::signed_integers::errors::Error;
use ::signed_integers::common::WrappingNeg;

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
    /// use sway_libs::signed_integers::i8::I8;
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

impl From<u8> for I8 {
    fn from(value: u8) -> Self {
        // as the minimal value of I8 is -I8::indent() (1 << 7) we should add I8::indent() (1 << 7) 
        let underlying: u8 = value + Self::indent();
        Self { underlying }
    }
}

impl core::ops::Eq for I8 {
    fn eq(self, other: Self) -> bool {
        self.underlying == other.underlying
    }
}

impl core::ops::Ord for I8 {
    fn gt(self, other: Self) -> bool {
        self.underlying > other.underlying
    }

    fn lt(self, other: Self) -> bool {
        self.underlying < other.underlying
    }
}

impl I8 {
    /// The size of this type in bits.
    ///
    /// # Returns
    ///
    /// * [u64] - The number of bits.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i8::I8;
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
    /// use sway_libs::signed_integers::i8::I8;
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

    /// The largest value that can be represented by this integer type.
    ///
    /// # Returns
    ///
    /// * [I8] - The newly created `I8` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i8::I8;
    ///
    /// fn foo() {
    ///     let i8 = I8::max();
    ///     assert(i8.underlying() == u8::max());
    /// }
    /// ```
    pub fn max() -> Self {
        Self {
            underlying: u8::max(),
        }
    }

    /// The smallest value that can be represented by this integer type.
    ///
    /// # Returns
    ///
    /// * [I8] - The newly created `I8` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i8::I8;
    ///
    /// fn foo() {
    ///     let i8 = I8::new();
    ///     assert(i8.underlying() == u8::min());
    /// }
    /// ```
    pub fn min() -> Self {
        Self {
            underlying: u8::min(),
        }
    }

    /// Helper function to get a negative value of an unsigned number.
    ///
    /// # Arguments
    ///
    /// * `value`: [u8] - The unsigned number to negate.
    ///
    /// # Returns
    ///
    /// * [I8] - The newly created `I8` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::signed_integers::i8::I8;
    ///
    /// fn foo() {
    ///     let underlying = 1u8;
    ///     let i8 = I8::neg_from(underlying);
    ///     assert(i8.underlying() == 127u8);
    /// }
    /// ```
    pub fn neg_from(value: u8) -> Self {
        Self {
            underlying: Self::indent() - value,
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
    /// use sway_libs::signed_integers::i8::I8;
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
    /// use sway_libs::signed_integers::i8::I8;
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
    /// use sway_libs::signed_integers::i8::I8;
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
    /// use sway_libs::signed_integers::i8::I8;
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

impl core::ops::Add for I8 {
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

impl core::ops::Divide for I8 {
    /// Divide a I8 by a I8. Panics if divisor is zero.
    fn divide(self, divisor: Self) -> Self {
        require(divisor != Self::new(), Error::ZeroDivisor);
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

impl core::ops::Multiply for I8 {
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

impl core::ops::Subtract for I8 {
    /// Subtract a I8 from a I8. Panics of overflow.
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

impl WrappingNeg for I8 {
    fn wrapping_neg(self) -> Self {
        if self == self::min() {
            return self::min()
        }
        self * Self::neg_from(1u8)
    }
}
