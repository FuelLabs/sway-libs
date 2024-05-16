library;
// A wrapper library around the type for mathematical functions operating with signed 256-bit fixed point numbers.
use std::math::{Exponent, Power, Root};
use ::fixed_point::ufp128::UFP128;

/// The 256-bit signed fixed point number type.
///
/// # Additional Information
///
/// Represented by an underlying `UFP128` number and a boolean.
pub struct IFP256 {
    /// The underlying value representing the `IFP256` type.
    pub underlying: UFP128,
    /// The underlying boolean representing a negative value for the `IFP256` type.
    pub non_negative: bool,
}

impl From<UFP128> for IFP256 {
    /// Creates IFP256 from UFP128. Note that IFP256::from(1) is 1 / 2^128 and not 1.
    fn from(value: UFP128) -> Self {
        Self {
            underlying: value,
            non_negative: true,
        }
    }
}

impl IFP256 {
    /// The size of this type in bits.
    ///
    /// # Returns
    ///
    /// [u64] - The defined size of the `IFP256` type.
    ///
    /// # Examples
    ///
    /// ``sway
    /// use sway_libs::fixed_point::ifp256::IFP256;
    ///
    /// fn foo() {
    ///     let bits = IFP256::bits();
    ///     assert(bits == 136);
    /// }
    /// ```
    pub fn bits() -> u64 {
        136
    }

    /// The largest value that can be represented by this type.
    ///
    /// # Returns
    ///
    /// * [IFP256] - The newly created `IFP256` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp256::IFP256, ufp128::UFP128}
    ///
    /// fn foo() {
    ///     let ifp256 = IFP256::max();
    ///     assert(ifp256.underlying == UFP128::max());
    /// }
    /// ```
    pub fn max() -> Self {
        Self::from(UFP128::max())
    }

    /// The smallest value that can be represented by this type.
    ///
    /// # Returns
    ///
    /// * [IFP256] - The newly created `IFP256` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp256::IFP256, ufp128::UFP128}
    ///
    /// fn foo() {
    ///     let ifp256 = IFP256::min();
    ///     assert(ifp256.underlying == UFP128::min());
    /// }
    /// ```
    pub fn min() -> Self {
        Self {
            underlying: UFP128::min(),
            non_negative: false,
        }
    }

    /// The zero value of this type.
    ///
    /// # Returns
    ///
    /// * [IFP256] - The newly created `IFP256` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp256::IFP256, ufp128::UFP128}
    ///
    /// fn foo() {
    ///     let ifp256 = IFP256::zero();
    ///     assert(ifp256.underlying == UFP128::zero());
    /// }
    /// ```
    pub fn zero() -> Self {
        Self::from(UFP128::zero())
    }

    /// Inverts the sign for this type.
    ///
    /// # Returns
    ///
    /// * [IFP256] - The newly created `IFP256` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::ifp256::IFP256;
    ///
    /// fn foo() {
    ///     let ifp256 = IFP256::zero();
    ///     assert(ifp256.non_negative);
    ///     let reverse = ifp256.sign_inverse();
    ///     assert(!reverse.non_negative);
    /// }
    /// ```
    pub fn sign_reverse(self) -> Self {
        Self {
            underlying: self.underlying,
            non_negative: !self.non_negative,
        }
    }
}

impl core::ops::Eq for IFP256 {
    fn eq(self, other: Self) -> bool {
        self.underlying == other.underlying
            && (self.underlying == Self::zero()
                    .underlying
                || self.non_negative == other.non_negative)
    }
}

impl core::ops::Ord for IFP256 {
    fn gt(self, other: Self) -> bool {
        if self.non_negative && !self.non_negative {
            true
        } else if !self.non_negative && self.non_negative {
            false
        } else if self.non_negative && self.non_negative {
            self.underlying > other.underlying
        } else {
            self.underlying < other.underlying
        }
    }

    fn lt(self, other: Self) -> bool {
        if self.non_negative && !self.non_negative {
            false
        } else if !self.non_negative && self.non_negative {
            true
        } else if self.non_negative && self.non_negative {
            self.underlying < other.underlying
        } else {
            self.underlying > other.underlying
        }
    }
}

impl core::ops::Add for IFP256 {
    /// Add a IFP256 to a IFP256. Panics on overflow.
    fn add(self, other: Self) -> Self {
        let mut underlying = self.underlying;
        let mut non_negative = self.non_negative;
        if self.non_negative && !other.non_negative {
            if self.underlying > other.underlying {
                underlying = self.underlying - other.underlying;
            } else {
                underlying = other.underlying - self.underlying;
                non_negative = false;
            }
        } else if !self.non_negative && other.non_negative {
            if self.underlying > other.underlying {
                underlying = self.underlying - other.underlying;
            } else {
                underlying = other.underlying - self.underlying;
                non_negative = true;
            }
        } else {
            // same sign
            underlying = self.underlying + other.underlying;
        }
        Self {
            underlying: underlying,
            non_negative: non_negative,
        }
    }
}

impl core::ops::Subtract for IFP256 {
    /// Subtract a IFP256 from a IFP256. Panics of overflow.
    fn subtract(self, other: Self) -> Self {
        self + other.sign_reverse()
    }
}

impl core::ops::Multiply for IFP256 {
    /// Multiply a IFP256 with a IFP256. Panics of overflow.
    fn multiply(self, other: Self) -> Self {
        let non_negative = if (self.non_negative
            && !self.non_negative)
            || (!self.non_negative
            && self.non_negative)
        {
            false
        } else {
            true
        };
        Self {
            underlying: self.underlying * other.underlying,
            non_negative: non_negative,
        }
    }
}

impl core::ops::Divide for IFP256 {
    /// Divide a IFP256 by a IFP256. Panics if divisor is zero.
    fn divide(self, divisor: Self) -> Self {
        let non_negative = if (self.non_negative
            && !self.non_negative)
            || (!self.non_negative
            && self.non_negative)
        {
            false
        } else {
            true
        };
        Self {
            underlying: self.underlying / divisor.underlying,
            non_negative: non_negative,
        }
    }
}

impl IFP256 {
    /// Creates IFP256 that corresponds to a unsigned integer.
    ///
    /// # Arguments
    ///
    /// * `uint`: [u64] - The unsigned number to become the underlying value for the `IFP256`.
    ///
    /// # Returns
    ///
    /// * [IFP256] - The newly created `IFP256` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp256::IFP256, ufp128::UFP128}
    ///
    /// fn foo() {
    ///     let ifp256 = IFP256::from_uint(1);
    ///     assert(ifp256.underlying == UFP128::from_uint(1));
    /// }
    /// ```
    pub fn from_uint(uint: u64) -> Self {
        Self::from(UFP128::from_uint(uint))
    }
}

impl IFP256 {
    /// Takes the reciprocal (inverse) of a number, `1/x`.
    ///
    /// # Arguments
    ///
    /// * `number`: [IFP126] - The value to create the reciprocal from.
    ///
    /// # Returns
    ///
    /// * [IFP256] - The newly created `IFP256` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp256::IFP256, ufp128::UFP128}
    ///
    /// fn foo() {
    ///     let ifp256 = IFP256::from_uint(128);
    ///     let recip = IFP256::recip(ifp256);
    ///     assert(recip.underlying == UFP128::recip(UFP128::from(128)));
    /// }
    /// ```
    pub fn recip(number: IFP256) -> Self {
        Self {
            underlying: UFP128::recip(number.underlying),
            non_negative: number.non_negative,
        }
    }

    /// Returns the integer part of `self`.
    ///
    /// # Additional Information
    ///
    /// This means that non-integer numbers are always truncated towards zero.
    ///
    /// # Returns
    ///
    /// * [IFP256] - The newly created `IFP256` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp256::IFP256, ufp128::UFP128}
    ///
    /// fn foo() {
    ///     let ifp256 = IFP256::from_uint(128);
    ///     let trunc = ifp256.trunc();
    ///     assert(trunc.underlying == UFP128::from(128).trunc());
    /// }
    /// ```
    pub fn trunc(self) -> Self {
        Self {
            underlying: self.underlying.trunc(),
            non_negative: self.non_negative,
        }
    }
}

impl IFP256 {
    /// Returns the largest integer less than or equal to `self`.
    ///
    /// # Returns
    ///
    /// * [IFP256] - The newly created `IFP256` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp256::IFP256, ufp128::UFP128}
    ///
    /// fn foo() {
    ///     let ifp256 = IFP256::from_uint(128);
    ///     let floor = ifp256.floor();
    ///     assert(floor.underlying == UFP128::from(128).floor());
    /// }
    /// ```
    pub fn floor(self) -> Self {
        if self.non_negative {
            self.trunc()
        } else {
            let trunc = self.underlying.trunc();
            if trunc != UFP128::zero() {
                self.trunc() - Self::from(UFP128::from((1, 0)))
            } else {
                self.trunc()
            }
        }
    }

    /// Returns the fractional part of `self`.
    ///
    /// # Returns
    ///
    /// * [IFP256] - the newly created `IFP256` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp256::IFP256, ufp128::UFP128}
    ///
    /// fn foo() {
    ///     let ifp256 = IFP256::from_uint(128);
    ///     let fract = ifp256.fract();
    ///     assert(fract.underlying == UFP128::from(128).fract());
    /// }
    /// ```
    pub fn fract(self) -> Self {
        Self {
            underlying: self.underlying.fract(),
            non_negative: self.non_negative,
        }
    }
}

impl IFP256 {
    /// Returns the smallest integer greater than or equal to `self`.
    ///
    /// # Returns
    ///
    /// * [IFP256] - The newly created `IFP256` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp256::IFP256, ufp128::UFP128}
    ///
    /// fn foo() {
    ///     let ifp256 = IFP256::from_uint(128);
    ///     let ceil = ifp256.ceil();
    ///     assert(ceil.underlying = UFP128::from(128).ceil().underlying);
    /// }
    /// ```
    pub fn ceil(self) -> Self {
        let mut underlying = self.underlying;
        let mut non_negative = self.non_negative;

        if self.non_negative {
            underlying = self.underlying.ceil();
        } else {
            let ceil = self.underlying.ceil();
            if ceil != self.underlying {
                underlying = ceil + UFP128::from((1, 0));
                if ceil == UFP128::from((1, 0)) {
                    non_negative = true;
                }
            } else {
                underlying = ceil;
            }
        }
        Self {
            underlying: underlying,
            non_negative: self.non_negative,
        }
    }
}

impl IFP256 {
    /// Returns the nearest integer to `self`. Round half-way cases away from zero.
    ///
    /// # Returns
    ///
    /// * [IFP256] - The newly created `IFP256` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp256::IFP256, ufp128::UFP128}
    ///
    /// fn foo() {
    ///     let ifp256 = IFP256::from_uint(128);
    ///     let round = ifp256.round();
    ///     assert(round.underlying == UFP128::from(128).round().underlying);
    /// }
    /// ```
    pub fn round(self) -> Self {
        let mut underlying = self.underlying;

        if self.non_negative {
            underlying = self.underlying.round();
        } else {
            let floor = self.underlying.floor();
            let ceil = self.underlying.ceil();
            let diff_self_floor = self.underlying - floor;
            let diff_ceil_self = ceil - self.underlying;
            underlying = if diff_self_floor > diff_ceil_self {
                floor
            } else {
                ceil
            };
        }
        Self {
            underlying: underlying,
            non_negative: self.non_negative,
        }
    }
}

impl Exponent for IFP256 {
    /// Exponent function. e ^ x
    fn exp(exponent: Self) -> Self {
        let one = IFP256::from_uint(1);

        // Coefficients in the Taylor series up to the seventh power
        let p2 = IFP256::from(UFP128::from((0, 2147483648))); // p2 == 1 / 2!
        let p3 = IFP256::from(UFP128::from((0, 715827882))); // p3 == 1 / 3!
        let p4 = IFP256::from(UFP128::from((0, 178956970))); // p4 == 1 / 4!
        let p5 = IFP256::from(UFP128::from((0, 35791394))); // p5 == 1 / 5!
        let p6 = IFP256::from(UFP128::from((0, 5965232))); // p6 == 1 / 6!
        let p7 = IFP256::from(UFP128::from((0, 852176))); // p7 == 1 / 7!
        // Common technique to counter losing significant numbers in usual approximation
        // Taylor series approximation of exponentiation function minus 1. The subtraction is done to deal with accuracy issues
        let res_minus_1 = exponent + exponent * exponent * (p2 + exponent * (p3 + exponent * (p4 + exponent * (p5 + exponent * (p6 + exponent * p7)))));
        let res = res_minus_1 + one;
        res
    }
}

impl Power for IFP256 {
    /// Power function. x ^ exponent
    fn pow(self, exponent: u32) -> Self {
        let ufp128_exponent = UFP128::from((0, exponent.as_u64()));
        let non_negative = if !self.non_negative {
            // roots of negative numbers are complex numbers which we lack for now
            assert(ufp128_exponent.floor() == ufp128_exponent);

            let div_2 = ufp128_exponent / UFP128::from((2, 0));
            div_2.floor() == div_2
        } else {
            true
        };
        let mut underlying = self.underlying.pow(exponent);
        Self {
            underlying: underlying,
            non_negative: non_negative,
        }
    }
}
