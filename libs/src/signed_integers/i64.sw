library;

use ::signed_integers::common::TwosComplement;
use ::signed_integers::errors::Error;

/// The 64-bit signed integer type.
///
/// # Additional Information
///
/// Represented as an underlying u64 value.
/// Actual value is underlying value minus 2 ^ 63
/// Max value is 2 ^ 63 - 1, min value is - 2 ^ 63
pub struct I64 {
    /// The underlying unsigned number representing the `I64` type.
    pub underlying: u64,
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
    /// use libraries::signed_integers::i64::I64;
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

impl From<u64> for I64 {
    fn from(value: u64) -> Self {
        // as the minimal value of I64 is -I64::indent() (1 << 63) we should add I64::indent() (1 << 63) 
        let underlying = value + Self::indent();
        Self { underlying }
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
    ///
    /// # Returns
    ///
    /// [u64] - The defined size of the `I64` type.
    ///
    /// # Examples
    ///
    /// ``sway
    /// use libraries::signed_integers::i64::I64;
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
    /// use libraries::signed_integers::i64::I64;
    ///
    /// fn foo() {
    ///     let underlying = 1u64;
    ///     let i64 = I64::from_uint(underlying);
    ///     assert(i64.underlying == underlying);
    /// }
    /// ```
    pub fn from_uint(underlying: u64) -> Self {
        Self { underlying }
    }

    /// The largest value that can be represented by this integer type.
    ///
    /// # Returns
    ///
    /// * [I64] - The newly created `I64` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::signed_integers::i64::I64;
    ///
    /// fn foo() {
    ///     let i64 = I64::max();
    ///     assert(i64.underlying == u64::max());
    /// }
    /// ```
    pub fn max() -> Self {
        Self {
            underlying: u64::max(),
        }
    }

    /// The smallest value that can be represented by this integer type.
    ///
    /// # Returns
    ///
    /// * [I64] - The newly created `I64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::signed_integers::i64::I64;
    ///
    /// fn foo() {
    ///     let i64 = I64::min();
    ///     assert(i64.underlying == u64::min());
    /// }
    /// ```
    pub fn min() -> Self {
        Self {
            underlying: u64::min(),
        }
    }

    /// Helper function to get a negative value of an unsigned number.
    ///
    /// # Arguments
    ///
    /// * `value`: [u64] - The unsigned number to negate.
    ///
    /// # Returns
    ///
    /// * [I64] - The newly created `I64` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::signed_integers::i64::I64;
    ///
    /// fn foo() {
    ///     let underlying = 1u64;
    ///     let i64 = I64::neg_from(underlying);
    ///     assert(i64.underlying == 9223372036854775807u64);
    /// }
    /// ```
    pub fn neg_from(value: u64) -> Self {
        Self {
            underlying: Self::indent() - value,
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
    /// use libraries::signed_integers::i64::I64;
    ///
    /// fn foo() {
    ///     let i64 = I64::new();
    ///     assert(i64.underlying == 9223372036854775808);
    /// }
    /// ```
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

impl core::ops::Divide for I64 {
    /// Divide a I64 by a I64. Panics if divisor is zero.
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

impl TwosComplement for I64 {
    fn twos_complement(self) -> Self {
        if self.underlying >= Self::indent() {
            return self;
        }
        let res = Self::from_uint(!self.underlying + 1);
        res
    }
}
