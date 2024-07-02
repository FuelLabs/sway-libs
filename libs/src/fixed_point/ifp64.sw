library;
// A wrapper library around the u32 type for mathematical functions operating with signed 64-bit fixed point numbers.
use std::math::*;
use ::fixed_point::ufp32::UFP32;

/// The 64-bit signed fixed point number type.
///
/// # Additional Information
///
/// Represented by an underlying `UFP32` number and a boolean.
pub struct IFP64 {
    /// The underlying value representing the `IFP64` type.
    underlying: UFP32,
    /// The underlying boolean representing a negative value for the `IFP64` type.
    non_negative: bool,
}

impl From<UFP32> for IFP64 {
    /// Creates IFP64 from UFP32. Note that IFP64::from(1) is 1 / 2^32 and not 1.
    fn from(value: UFP32) -> Self {
        Self {
            underlying: value,
            non_negative: true,
        }
    }
}

impl IFP64 {
    /// The size of this type in bits.
    ///
    /// # Returns
    ///
    /// [u64] - The defined size of the `IFP64` type.
    ///
    /// # Examples
    ///
    /// ``sway
    /// use sway_libs::fixed_point::ifp64::IFP64;
    ///
    /// fn foo() {
    ///     let bits = IFP64::bits();
    ///     assert(bits == 64);
    /// }
    /// ```
    pub fn bits() -> u64 {
        64
    }

    /// The largest value that can be represented by this type.
    ///
    /// # Returns
    ///
    /// * [IFP64] - The newly created `IFP64` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp64::IFP64, ufp32::UFP32};
    ///
    /// fn foo() {
    ///     let ifp64 = IFP64::max();
    ///     assert(ifp64.underlying() == UFP32::max());
    /// }
    /// ```
    pub fn max() -> Self {
        Self::from(UFP32::max())
    }

    /// The smallest value that can be represented by this type.
    ///
    /// # Returns
    ///
    /// * [IFP64] - The newly created `IFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp64::IFP64, ufp32::UFP32};
    ///
    /// fn foo() {
    ///     let ifp64 = IFP64::min();
    ///     assert(ifp64.underlying() == UFP32::min());
    /// }
    /// ```
    pub fn min() -> Self {
        Self {
            underlying: UFP32::min(),
            non_negative: false,
        }
    }

    /// The zero value of this type.
    ///
    /// # Returns
    ///
    /// * [IFP64] - The newly created `IFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp64::IFP64, ufp32::UFP32};
    ///
    /// fn foo() {
    ///     let ifp64 = IFP64::zero();
    ///     assert(ifp64.underlying() == UFP32::zero());
    /// }
    /// ```
    pub fn zero() -> Self {
        Self::from(UFP32::zero())
    }

    /// Returns whether a `IFP64` is set to zero.
    ///
    /// # Returns
    ///
    /// * [bool] -> True if the `IFP64` is zero, otherwise false.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::ifp64::IFP64;
    ///
    /// fn foo() {
    ///     let ifp64 = IFP64::zero();
    ///     assert(ifp64.is_zero());
    /// }
    /// ```
    pub fn is_zero(self) -> bool {
        self.underlying == UFP32::zero()
    }

    /// Inverts the sign for this type.
    ///
    /// # Returns
    ///
    /// * [IFP64] - The newly created `IFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::ifp64::IFP64;
    ///
    /// fn foo() {
    ///     let ifp64 = IFP64::zero();
    ///     assert(ifp64.non_negative());
    ///     let reverse = ifp64.sign_inverse();
    ///     assert(!reverse.non_negative());
    /// }
    /// ```
    fn sign_reverse(self) -> Self {
        Self {
            underlying: self.underlying,
            non_negative: !self.non_negative,
        }
    }

    /// Returns the underlying `UFP32` representing the `IFP64`.
    ///
    /// # Returns
    ///
    /// * [UFP32] - The `UFP32` representing the `IFP64`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp64::IFP64, ufp32::UFP32};
    ///
    /// fn foo() {
    ///     let ifp64 = IFP64::zero();
    ///     assert(ifp64.underlying() == UFP32::zero());
    /// }
    /// ```
    pub fn underlying(self) -> UFP32 {
        self.underlying
    }

    /// Returns the underlying bool representing the postive or negative state of the IFP64.
    ///
    /// # Returns
    ///
    /// * [bool] - The `bool` representing whether the `IFP64` is non-negative or not.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::ifp64::IFP64;
    ///
    /// fn foo() {
    ///     let ifp64 = IFP64::zero();
    ///     assert(ifp64.non_negative() == false);
    /// }
    /// ```
    pub fn non_negative(self) -> bool {
        self.non_negative
    }
}

impl core::ops::Eq for IFP64 {
    fn eq(self, other: Self) -> bool {
        self.underlying == other.underlying
            && (self.underlying == Self::zero()
                    .underlying
                || self.non_negative == other.non_negative)
    }
}

impl core::ops::Ord for IFP64 {
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

impl core::ops::Add for IFP64 {
    /// Add a IFP64 to a IFP64. Panics on overflow.
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

impl core::ops::Subtract for IFP64 {
    /// Subtract a IFP64 from a IFP64. Panics of overflow.
    fn subtract(self, other: Self) -> Self {
        self + other.sign_reverse()
    }
}

impl core::ops::Multiply for IFP64 {
    /// Multiply a IFP64 with a IFP64. Panics of overflow.
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

impl core::ops::Divide for IFP64 {
    /// Divide a IFP64 by a IFP64. Panics if divisor is zero.
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

impl IFP64 {
    /// Creates IFP64 that corresponds to a unsigned integer.
    ///
    /// # Arguments
    ///
    /// * `uint`: [u32] - The unsigned number to become the underlying value for the `IFP64`.
    ///
    /// # Returns
    ///
    /// * [IFP64] - The newly created `IFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp64::IFP64, ufp32::UFP32};
    ///
    /// fn foo() {
    ///     let ifp64 = IFP64::from_uint(1u32);
    ///     assert(ifp64.underlying() == UFP32::from_uint(1u32));
    /// }
    /// ```
    pub fn from_uint(uint: u32) -> Self {
        Self::from(UFP32::from_uint(uint))
    }
}

impl IFP64 {
    /// Takes the reciprocal (inverse) of a number, `1/x`.
    ///
    /// # Arguments
    ///
    /// * `number`: [IFP64] - The value to create the reciprocal from.
    ///
    /// # Returns
    ///
    /// * [IFP64] - The newly created `IFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp64::IFP64, ufp32::UFP32};
    ///
    /// fn foo() {
    ///     let ifp64 = IFP64::from_uint(128u32);
    ///     let recip = IFP64::recip(ifp64);
    ///     assert(recip.underlying() == UFP32::recip(UFP32::from(128u32)));
    /// }
    /// ```
    pub fn recip(number: IFP64) -> Self {
        Self {
            underlying: UFP32::recip(number.underlying),
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
    /// * [IFP64] - The newly created `IFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp64:IFP64, ufp32::UFP32};
    ///
    /// fn foo() {
    ///     let ifp64 = IFP64::from_uint(128u32);
    ///     let trunc = ifp64.trunc();
    ///     assert(trunc.underlying() == UFP32::from(128u32).trunc());
    /// }
    /// ```
    pub fn trunc(self) -> Self {
        Self {
            underlying: self.underlying.trunc(),
            non_negative: self.non_negative,
        }
    }
}

impl IFP64 {
    /// Returns the largest integer less than or equal to `self`.
    ///
    /// # Returns
    ///
    /// * [IFP64] - The newly created `IFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp64::IFP64, ufp32::UFP32};
    ///
    /// fn foo() {
    ///     let ifp64 = IFP64::from_uint(128u32);
    ///     let floor = ifp64.floor();
    ///     assert(floor.underlying() == UFP32::from(128u32).trunc().underlying());
    /// }
    /// ```
    pub fn floor(self) -> Self {
        if self.non_negative {
            self.trunc()
        } else {
            let trunc = self.underlying.trunc();
            if trunc != UFP32::zero() {
                self.trunc() - Self::from(UFP32::from(1u32))
            } else {
                self.trunc()
            }
        }
    }

    /// Returns the fractional part of `self`.
    ///
    /// # Returns
    ///
    /// * [IFP64] - the newly created `IFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp64::IFP64, ufp32::UFP32};
    ///
    /// fn foo() {
    ///     let ifp64 = IFP64::from_uint(128u32);
    ///     let fract = ifp64.fract();
    ///     assert(fract.underlying() == UFP32::from(128u32).fract());
    /// }
    /// ```
    pub fn fract(self) -> Self {
        Self {
            underlying: self.underlying.fract(),
            non_negative: self.non_negative,
        }
    }
}

impl IFP64 {
    /// Returns the smallest integer greater than or equal to `self`.
    ///
    /// # Returns
    ///
    /// * [IFP64] - The newly created `IFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp64::IFP64, ufp32::UFP32};
    ///
    /// fn foo() {
    ///     let ifp64 = IFP64::from_uint(128u32);
    ///     let ceil = ifp64.ceil();
    ///     assert(ceil.underlying() = UFP32::from(128u32).ceil());
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
                underlying = ceil + UFP32::from(1u32);
                if ceil == UFP32::from(1u32) {
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

impl IFP64 {
    /// Returns the nearest integer to `self`. Round half-way cases away from zero.
    ///
    /// # Returns
    ///
    /// * [IFP64] - The newly created `IFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::{ifp64::IFP64, ufp32::UFP32};
    ///
    /// fn foo() {
    ///     let ifp64 = IFP64::from_uint(128_u32);
    ///     let round = ifp64.round();
    ///     assert(round.underlying() == UFP32::from(128u32).round());
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

impl Exponent for IFP64 {
    /// Exponent function. e ^ x
    fn exp(exponent: Self) -> Self {
        let one = IFP64::from_uint(1u32);

        // Coefficients in the Taylor series up to the seventh power
        let p2 = IFP64::from(UFP32::from(32768u32)); // p2 == 1 / 2!
        let p3 = IFP64::from(UFP32::from(10922u32)); // p3 == 1 / 3!
        let p4 = IFP64::from(UFP32::from(2730u32)); // p4 == 1 / 4!
        let p5 = IFP64::from(UFP32::from(546u32)); // p5 == 1 / 5!
        let p6 = IFP64::from(UFP32::from(91u32)); // p6 == 1 / 6!
        let p7 = IFP64::from(UFP32::from(13u32)); // p7 == 1 / 7!
        // Common technique to counter losing significant numbers in usual approximation
        // Taylor series approximation of exponentiation function minus 1. The subtraction is done to deal with accuracy issues
        let res_minus_1 = exponent + exponent * exponent * (p2 + exponent * (p3 + exponent * (p4 + exponent * (p5 + exponent * (p6 + exponent * p7)))));
        let res = res_minus_1 + one;
        res
    }
}

impl Power for IFP64 {
    /// Power function. x ^ exponent
    fn pow(self, exponent: u32) -> Self {
        let ufp32_exponent = UFP32::from(exponent);
        let non_negative = if !self.non_negative {
            // roots of negative numbers are complex numbers which we lack for now
            assert(ufp32_exponent.floor() == ufp32_exponent);

            let div_2 = ufp32_exponent / UFP32::from(2u32);
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
    let num  = IFP64::from_uint(42_u32);
    let num2 = IFP64::min();

    assert(num > num2);
    assert(num2 < num);
}