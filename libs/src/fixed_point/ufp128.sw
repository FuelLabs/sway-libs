library;
// A wrapper around U128 type for a library for Sway for mathematical functions operating with unsigned 64.64-bit fixed point numbers.
use std::{math::{Exponent, Power, Root}, u128::U128};

/// The 128-bit unsigned fixed point number type.
///
/// # Additional Information
///
/// Represented by an underlying `U128` number.
pub struct UFP128 {
    /// The underlying value representing the `UFP128` type.
    pub value: U128,
}

impl From<(u64, u64)> for UFP128 {
    fn from(int_fract_tuple: (u64, u64)) -> Self {
        Self {
            value: U128::from(int_fract_tuple),
        }
    }
}

impl UFP128 {
    /// The zero value of this type.
    ///
    /// # Returns
    ///
    /// * [UFP128] - The newly created `UFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp128::UFP128;
    ///
    /// fn foo() {
    ///     let ufp128 = UFP128::zero();
    ///     assert(ufp128.underlying == U128::from((0, 0)));
    /// }
    /// ```
    pub fn zero() -> Self {
        Self {
            value: U128::from((0, 0)),
        }
    }

    /// The smallest value that can be represented by this type.
    ///
    /// # Returns
    ///
    /// * [UFP128] - The newly created `UFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp128::UFP128;
    /// use std::u128::U128;
    ///
    /// fn foo() {
    ///     let ufp128 = UFP128::min();
    ///     assert(ufp128.underlying == U128::min());
    /// }
    /// ```
    pub fn min() -> Self {
        Self {
            value: U128::min(),
        }
    }

    /// The largest value that can be represented by this type.
    ///
    /// # Returns
    ///
    /// * [UFP128] - The newly created `UFP128` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp128::UFP128;
    /// use std::u128::U128;
    ///
    /// fn foo() {
    ///     let ufp128 = UFP128::max();
    ///     assert(ufp128.value == U128::max());
    /// }
    /// ```
    pub fn max() -> Self {
        Self {
            value: U128::max(),
        }
    }

    /// The size of this type in bits.
    ///
    /// # Returns
    ///
    /// [u64] - The defined size of the `UFP128` type.
    ///
    /// # Examples
    ///
    /// ``sway
    /// use libraries::fixed_point::ufp128::UFP128;
    ///
    /// fn foo() {
    ///     let bits = UFP128::bits();
    ///     assert(bits == 128);
    /// }
    /// ```
    pub fn bits() -> u64 {
        128
    }
}

impl UFP128 {
    /// Creates UFP128 that corresponds to a unsigned integer.
    ///
    /// # Arguments
    ///
    /// * `uint`: [u64] - The unsigned number to become the underlying value for the `UFP128`.
    ///
    /// # Returns
    ///
    /// * [UFP128] - The newly created `UFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp128::UFP128;
    /// use std::u128::U128;
    ///
    /// fn foo() {
    ///     let ufp128 = UFP128::from_uint(1);
    ///     assert(ufp128.underlying == U128::from((1, 0));
    /// }
    /// ```
    pub fn from_uint(uint: u64) -> Self {
        Self {
            value: U128::from((uint, 0)),
        }
    }
}

impl core::ops::Eq for UFP128 {
    fn eq(self, other: Self) -> bool {
        self.value == other.value
    }
}

impl core::ops::Ord for UFP128 {
    fn gt(self, other: Self) -> bool {
        self.value > other.value
    }

    fn lt(self, other: Self) -> bool {
        self.value < other.value
    }
}

impl core::ops::Add for UFP128 {
    /// Add a UFP128 to a UFP128. Panics on overflow.
    fn add(self, other: Self) -> Self {
        UFP128 {
            value: self.value + other.value,
        }
    }
}

impl core::ops::Subtract for UFP128 {
    /// Subtract a UFP128 from a UFP128. Panics of overflow.
    fn subtract(self, other: Self) -> Self {
        // If trying to subtract a larger number, panic.
        assert(!(self.value < other.value));

        UFP128 {
            value: self.value - other.value,
        }
    }
}

impl core::ops::Multiply for UFP128 {
    /// Multiply a UFP128 with a UFP128. Panics on overflow.
    fn multiply(self, other: Self) -> Self {
        let self_u64 = (0, 0, self.value.upper(), self.value.lower());
        let other_u64 = (0, 0, other.value.upper(), other.value.lower());
        let self_u256 = asm(r1: self_u64) {
            r1: u256
        };
        let other_u256 = asm(r1: other_u64) {
            r1: u256
        };

        let self_multiply_other = self_u256 * other_u256;
        let res_u256 = self_multiply_other >> 64;

        let (a, b, c, d) = asm(r1: res_u256) {
            r1: (u64, u64, u64, u64)
        };
        if a != 0 || b != 0 {
            // panic on overflow
            revert(0);
        }
        Self::from((c, d))
    }
}

impl core::ops::Divide for UFP128 {
    /// Divide a UFP128 by a UFP128. Panics if divisor is zero.
    fn divide(self, divisor: Self) -> Self {
        let zero = UFP128::zero();
        let u128_max = U128::max();

        assert(divisor != zero);

        // Conversion to u256 done to ensure no overflow happen
        // and maximal precision is avaliable
        // as it makes possible to multiply by the denominator in 
        // all cases
        let self_u64 = (0, 0, self.value.upper(), self.value.lower());
        let divisor_u64 = (0, 0, divisor.value.upper(), divisor.value.lower());
        let self_u256 = asm(r1: self_u64) {
            r1: u256
        };
        let divisor_u256 = asm(r1: divisor_u64) {
            r1: u256
        };

        // Multiply by denominator to ensure accuracy 
        let res_u256 = (self_u256 << 64) / divisor_u256;
        let (a, b, c, d) = asm(r1: res_u256) {
            r1: (u64, u64, u64, u64)
        };

        if a != 0 || b != 0 {
            // panic on overflow
            revert(0);
        }
        Self::from((c, d))
    }
}

impl UFP128 {
    /// Takes the reciprocal (inverse) of a number, `1/x`.
    ///
    /// # Arguments
    ///
    /// * `number`: [UFP128] - The value to create the reciprocal from.
    ///
    /// # Returns
    ///
    /// * [UFP128] - The newly created `UFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp128::UFP128;
    ///
    /// fn foo() {
    ///     let ufp64 = UFP128::from_uint(128);
    ///     let recip = UFP64::recip(ufp64);
    ///     assert(recip.underlying == U128::from((33554432, 0));
    /// }
    /// ```
    pub fn recip(number: UFP128) -> Self {
        let one = UFP128::from((1, 0));

        one / number
    }

    /// Returns the largest integer less than or equal to `self`.
    ///
    /// # Returns
    ///
    /// * [UFP128] - The newly created `UFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp128::UFP128;
    ///
    /// fn foo() {
    ///     let ufp128 = UFP128::from_uint(128);
    ///     let floor = ufp128.floor();
    ///     assert(floor.underlying == U128::from((0,0)));
    /// }
    /// ```
    pub fn floor(self) -> Self {
        Self::from((self.value.upper(), 0))
    }

    /// Returns the smallest integer greater than or equal to `self`.
    ///
    /// # Returns
    ///
    /// * [UFP64] - The newly created `UFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp128::UFP128;
    ///
    /// fn foo() {
    ///     let ufp128 = UFP128::from_uint(128);
    ///     let ceil = ufp128.ceil();
    ///     assert(ceil.underlying = U128::from((4294967296, 0)));
    /// }
    /// ```
    pub fn ceil(self) -> Self {
        let val = self.value;
        if val.lower() == 0 {
            return Self::from((val.upper(), 0));
        } else {
            return Self::from((val.upper() + 1, 0));
        }
    }
}

impl UFP128 {
    /// Returns the nearest integer to `self`. Round half-way cases away from zero.
    ///
    /// # Returns
    ///
    /// * [UFP128] - The newly created `UFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp128::UFP128;
    ///
    /// fn foo() {
    ///     let ufp128 = UFP128::from_uint(128);
    ///     let round = ufp128.round();
    ///     assert(round.underlying == U128::from(0,0)));
    /// }
    /// ```
    pub fn round(self) -> Self {
        let floor = self.floor();
        let ceil = self.ceil();
        let diff_self_floor = self - floor;
        let diff_ceil_self = ceil - self;
        if diff_self_floor < diff_ceil_self {
            return floor;
        } else {
            return ceil;
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
    /// * [UFP128] - The newly created `UFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp128::UFP128;
    ///
    /// fn foo() {
    ///     let ufp128 = UFP128::from_uint(128);
    ///     let trunc = ufp128.trunc();
    ///     assert(trunc.underlying == U128::from((0,0)));
    /// }
    /// ```
    pub fn trunc(self) -> Self {
        Self::from((self.value.upper(), 0))
    }

    /// Returns the fractional part of `self`.
    ///
    /// # Returns
    ///
    /// * [UFP128] - the newly created `UFP128` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp128::UFP128;
    ///
    /// fn foo() {
    ///     let ufp128 = UFP128::from_uint(128);
    ///     let fract = ufp128.fract();
    ///     assert(fract.underlying == U128::from((0, 0)));
    /// }
    /// ```
    pub fn fract(self) -> Self {
        Self::from((0, self.value.lower()))
    }
}

impl Root for UFP128 {
    fn sqrt(self) -> Self {
        let numerator_root = self.value.sqrt();
        let numerator = numerator_root * U128::from((0, 2 << 32));
        Self::from((numerator.upper(), numerator.lower()))
    }
}

impl Power for UFP128 {
    fn pow(self, exponent: u32) -> Self {
        let nominator_pow = self.value.pow(exponent);
        let u128_2 = U128::from((0, 2));
        let two_pow_64_n_minus_1 = u128_2.pow((64u32 * (exponent - 1u32)));
        let nominator = nominator_pow / two_pow_64_n_minus_1;
        Self::from((nominator.upper(), nominator.lower()))
    }
}

// TODO: uncomment and change accordingly, when signed integers will be added
// impl Logarithm for UFP128 {
//     fn log(self, base: Self) -> Self {
//         let nominator_log = self.value.log(base);
//         let res = (nominator_log - U128::from(0, 64 * 2.log(base))) * U128::from(1, 0);
//         UFP128 {
//             value: res
//         }
//     }
// }
impl Exponent for UFP128 {
    fn exp(exponent: Self) -> Self {
        let one = UFP128::from((1, 0));
        let p2 = one / UFP128::from((2, 0));
        let p3 = one / UFP128::from((6, 0));
        let p4 = one / UFP128::from((24, 0));
        let p5 = one / UFP128::from((120, 0));
        let p6 = one / UFP128::from((720, 0));
        let p7 = one / UFP128::from((5040, 0));

        // common technique to counter losing sugnifucant numbers in usual approximation
        let res_minus_1 = exponent + exponent * exponent * (p2 + exponent * (p3 + exponent * (p4 + exponent * (p5 + exponent * (p6 + exponent * p7)))));
        let res = res_minus_1 + one;
        let res = one;
        res
    }
}
