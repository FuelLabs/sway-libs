library;
// A wrapper library around the type for mathematical functions operating with signed 128-bit fixed point numbers.
use std::math::{Exponent, Power, Root};
use ::fixed_point::ufp64::UFP64;

/// The 128-bit signed fixed point number type.
///
/// # Additional Information
///
/// Represented by an underlying `UFP64` number and a boolean.
pub struct IFP128 {
    /// The underlying value representing the `IFP128` type.
    underlying: UFP64,
    /// The underlying boolean representing a negative value for the `IFP128` type.
    non_negative: bool,
}

impl From<UFP64> for IFP128 {
    /// Creates IFP128 from UFP64. Note that IFP128::from(1) is 1 / 2^32 and not 1.
    fn from(value: UFP64) -> Self {
        Self {
            underlying: value,
            non_negative: true,
        }
    }
}

impl IFP128 {
    /// The size of this type in bits.
    ///
    /// # Returns
    ///
    /// [u64] - The defined size of the `IFP128` type.
    ///
    /// # Examples
    ///
    /// ``sway
    /// use sway_libs::fixed_point::ifp128::IFP128;
    ///
    /// fn foo() {
    ///     let bits = IFP128::bits();
    ///     assert(bits == 72);
    /// }
    /// ```
    pub fn bits() -> u64 {
        72
    }

    /// The largest value that can be represented by this type.
    ///
    /// # Returns
    ///
    /// * [IFP128] - The newly created `IFP128` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp128::IFP128, ufp64::UFP64};
    ///
    /// fn foo() {
    ///     let ifp128 = IFP128::max();
    ///     assert(ifp128.underlying() == UFP64::max());
    /// }
    /// ```
    pub fn max() -> Self {
        Self::from(UFP64::max())
    }

    /// The smallest value that can be represented by this type.
    ///
    /// # Returns
    ///
    /// * [IFP128] - The newly created `IFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp128::IFP128, ufp64::UFP64};
    ///
    /// fn foo() {
    ///     let ifp128 = IFP128::min();
    ///     assert(ifp128.underlying() == UFP64::min());
    /// }
    /// ```
    pub fn min() -> Self {
        Self {
            underlying: UFP64::min(),
            non_negative: false,
        }
    }

    /// The zero value of this type.
    ///
    /// # Returns
    ///
    /// * [IFP128] - The newly created `IFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp128::IFP128, ufp64::UFP64};
    ///
    /// fn foo() {
    ///     let ifp128 = IFP128::zero();
    ///     assert(ifp128.underlying() == UFP64::zero());
    /// }
    /// ```
    pub fn zero() -> Self {
        Self::from(UFP64::zero())
    }

    /// Inverts the sign for this type.
    ///
    /// # Returns
    ///
    /// * [IFP128] - The newly created `IFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::ifp128::IFP128;
    ///
    /// fn foo() {
    ///     let ifp128 = IFP128::zero();
    ///     assert(ifp128.non_negative());
    ///     let reverse = ifp128.sign_inverse();
    ///     assert(!reverse.non_negative());
    /// }
    /// ```
    pub fn sign_reverse(self) -> Self {
        Self {
            underlying: self.underlying,
            non_negative: !self.non_negative,
        }
    }

    /// Returns whether a `IFP128` is set to zero.
    ///
    /// # Returns
    ///
    /// * [bool] -> True if the `IFP128` is zero, otherwise false.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::ifp128::IFP128;
    ///
    /// fn foo() {
    ///     let ifp128 = IFP128::zero();
    ///     assert(ifp128.is_zero());
    /// }
    /// ```
    pub fn is_zero(self) -> bool {
        self.underlying == UFP64::zero()
    }

    /// Returns the underlying `UFP64` representing the `IFP128`.
    ///
    /// # Returns
    ///
    /// * [UFP64] - The `UFP64` representing the `IFP128`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp128::IFP128, ufp64::UFP64};
    ///
    /// fn foo() {
    ///     let ifp128 = IFP128::zero();
    ///     assert(ifp128.underlying() == UFP64::zero());
    /// }
    /// ```
    pub fn underlying(self) -> UFP64 {
        self.underlying
    }

    /// Returns the underlying bool representing the postive or negative state of the IFP128.
    ///
    /// # Returns
    ///
    /// * [bool] - The `bool` representing whether the `IFP128` is non-negative or not.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::ifp128::IFP128;
    ///
    /// fn foo() {
    ///     let ifp128 = IFP128::zero();
    ///     assert(ifp128.non_negative() == false);
    /// }
    /// ```
    pub fn non_negative(self) -> bool {
        self.non_negative
    }
}

impl core::ops::Eq for IFP128 {
    fn eq(self, other: Self) -> bool {
        self.underlying == other.underlying
            && (self.underlying == Self::zero()
                    .underlying
                || self.non_negative == other.non_negative)
    }
}

impl core::ops::Ord for IFP128 {
    fn gt(self, other: Self) -> bool {
        if self.non_negative && !other.non_negative {
            true
        } else if !self.non_negative && other.non_negative {
            false
        } else if self.non_negative && other.non_negative {
            self.underlying > other.underlying
        } else {
            self.underlying < other.underlying
        }
    }

    fn lt(self, other: Self) -> bool {
        if self.non_negative && !other.non_negative {
            false
        } else if !self.non_negative && other.non_negative {
            true
        } else if self.non_negative && other.non_negative {
            self.underlying < other.underlying
        } else {
            self.underlying > other.underlying
        }
    }
}

impl core::ops::Add for IFP128 {
    /// Add a IFP128 to a IFP128. Panics on overflow.
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

impl core::ops::Subtract for IFP128 {
    /// Subtract a IFP128 from a IFP128. Panics of overflow.
    fn subtract(self, other: Self) -> Self {
        self + other.sign_reverse()
    }
}

impl core::ops::Multiply for IFP128 {
    /// Multiply a IFP128 with a IFP128. Panics of overflow.
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

impl core::ops::Divide for IFP128 {
    /// Divide a IFP128 by a IFP128. Panics if divisor is zero.
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

impl IFP128 {
    /// Creates IFP128 that corresponds to a unsigned integer.
    ///
    /// # Arguments
    ///
    /// * `uint`: [u64] - The unsigned number to become the underlying value for the `IFP128`.
    ///
    /// # Returns
    ///
    /// * [IFP128] - The newly created `IFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp128::IFP128, ufp64::UFP64};
    ///
    /// fn foo() {
    ///     let ifp128 = IFP128::from_uint(1);
    ///     assert(ifp128.underlying() == UFP64::from_uint(1));
    /// }
    /// ```
    pub fn from_uint(uint: u64) -> Self {
        Self::from(UFP64::from_uint(uint))
    }
}

impl IFP128 {
    /// Takes the reciprocal (inverse) of a number, `1/x`.
    ///
    /// # Arguments
    ///
    /// * `number`: [IFP128] - The value to create the reciprocal from.
    ///
    /// # Returns
    ///
    /// * [IFP128] - The newly created `IFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp128::IFP128, ufp64::UFP64};
    ///
    /// fn foo() {
    ///     let ifp128 = IFP128::from_uint(128);
    ///     let recip = IFP128::recip(ifp128);
    ///     assert(recip.underlying() == UFP64::recip(UFP64::from(128)));
    /// }
    /// ```
    pub fn recip(number: IFP128) -> Self {
        Self {
            underlying: UFP64::recip(number.underlying),
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
    /// * [IFP128] - The newly created `IFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp128::IFP128, ufp64::UFP64};
    ///
    /// fn foo() {
    ///     let ifp128 = IFP128::from_uint(128);
    ///     let trunc = ifp128.trunc();
    ///     assert(trunc.underlying() == UFP64::from(128).trunc());
    /// }
    /// ```
    pub fn trunc(self) -> Self {
        Self {
            underlying: self.underlying.trunc(),
            non_negative: self.non_negative,
        }
    }
}

impl IFP128 {
    /// Returns the largest integer less than or equal to `self`.
    ///
    /// # Returns
    ///
    /// * [IFP128] - The newly created `IFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp128::IFP128, ufp64::UFP64};
    ///
    /// fn foo() {
    ///     let ifp128 = IFP128::from_uint(128);
    ///     let floor = ifp128.floor();
    ///     assert(floor.underlying == UFP64::from(128).floor());
    /// }
    /// ```
    pub fn floor(self) -> Self {
        if self.non_negative {
            self.trunc()
        } else {
            let trunc = self.underlying.trunc();
            if trunc != UFP64::zero() {
                self.trunc() - Self::from(UFP64::from(1))
            } else {
                self.trunc()
            }
        }
    }

    /// Returns the fractional part of `self`.
    ///
    /// # Returns
    ///
    /// * [IFP128] - the newly created `IFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp128::IFP128, ufp64::UFP64};
    ///
    /// fn foo() {
    ///     let ifp128 = IFP128::from_uint(128);
    ///     let fract = ifp128.fract();
    ///     assert(fract.underlying() == UFP64::from(128).fract());
    /// }
    /// ```
    pub fn fract(self) -> Self {
        Self {
            underlying: self.underlying.fract(),
            non_negative: self.non_negative,
        }
    }
}

impl IFP128 {
    /// Returns the smallest integer greater than or equal to `self`.
    ///
    /// # Returns
    ///
    /// * [IFP128] - The newly created `IF128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp128::IFP128, ufp64::UFP64};
    ///
    /// fn foo() {
    ///     let ifp128 = IFP128::from_uint(128);
    ///     let ceil = ifp128.ceil();
    ///     assert(ceil.underlying = UFP64::from(128).ceil());
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
                underlying = ceil + UFP64::from(1);
                if ceil == UFP64::from(1) {
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

impl IFP128 {
    /// Returns the nearest integer to `self`. Round half-way cases away from zero.
    ///
    /// # Returns
    ///
    /// * [IFP128] - The newly created `IFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp128::IFP128, ufp64::UFP64};
    ///
    /// fn foo() {
    ///     let ifp128 = IFP128::from_uint(128);
    ///     let round = ifp128.round();
    ///     assert(round.underlying() == UFP64::from(128).round());
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

impl Exponent for IFP128 {
    /// Exponent function. e ^ x
    fn exp(exponent: Self) -> Self {
        let one = IFP128::from_uint(1);

        // Coefficients in the Taylor series up to the seventh power
        let p2 = IFP128::from(UFP64::from(2147483648)); // p2 == 1 / 2!
        let p3 = IFP128::from(UFP64::from(715827882)); // p3 == 1 / 3!
        let p4 = IFP128::from(UFP64::from(178956970)); // p4 == 1 / 4!
        let p5 = IFP128::from(UFP64::from(35791394)); // p5 == 1 / 5!
        let p6 = IFP128::from(UFP64::from(5965232)); // p6 == 1 / 6!
        let p7 = IFP128::from(UFP64::from(852176)); // p7 == 1 / 7!
        // Common technique to counter losing significant numbers in usual approximation
        // Taylor series approximation of exponentiation function minus 1. The subtraction is done to deal with accuracy issues
        let res_minus_1 = exponent + exponent * exponent * (p2 + exponent * (p3 + exponent * (p4 + exponent * (p5 + exponent * (p6 + exponent * p7)))));
        let res = res_minus_1 + one;
        res
    }
}

impl Power for IFP128 {
    /// Power function. x ^ exponent
    fn pow(self, exponent: u32) -> Self {
        let ufp64_exponent = UFP64::from(exponent.as_u64());
        let non_negative = if !self.non_negative {
            // roots of negative numbers are complex numbers which we lack for now
            assert(ufp64_exponent.floor() == ufp64_exponent);

            let div_2 = ufp64_exponent / UFP64::from(2);
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

#[test]
fn test_ord() {
    let num = IFP128::from_uint(42_u64);
    let num2 = IFP128::min();

    assert(num > num2);
    assert(num2 < num);
}
