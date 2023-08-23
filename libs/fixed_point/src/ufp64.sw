library;
// A wrapper library around the u64 type for mathematical functions operating with unsigned 64-bit fixed point numbers.
use std::{math::{Exponent, Power, Root}, u128::U128};

/// The 64-bit unsigned fixed point number type.
///
/// # Additional Information
///
/// Represented by an underlying `u64` number.
pub struct UFP64 {
    /// The underlying value representing the `UFP64` type.
    value: u64,
}

impl From<u64> for UFP64 {
    /// Creates UFP64 from u64. Note that UFP64::from(1) is 1 / 2^32 and not 1.
    fn from(value: u64) -> Self {
        Self { value }
    }

    fn into(self) -> u64 {
        self.value
    }
}

impl UFP64 {
    /// The size of this type in bits.
    ///
    /// # Returns
    ///
    /// [u64] - The defined size of the `UFP64` type.
    ///
    /// # Examples
    ///
    /// ``sway
    /// use fixed_point::UFP64;
    ///
    /// fn foo() {
    ///     let bits = UFP64::bits();
    ///     assert(bits == 64);
    /// }
    /// ```
    pub fn bits() -> u64 {
        64
    }

    /// Convenience function to know the denominator.
    ///
    /// # Returns
    ///
    /// * [u64] - The value of the denominator for the `UFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use fixed_point::UFP64;
    ///
    /// fn foo() {
    ///     let denominator = UFP64::denominator();
    ///     assert(denominator == 4294967296);
    /// }
    /// ```
    pub fn denominator() -> u64 {
        1 << 32
    }

    /// The largest value that can be represented by this type.
    ///
    /// # Returns
    ///
    /// * [UFP64] - The newly created `UFP64` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use fixed_point::UFP64;
    ///
    /// fn foo() {
    ///     let ufp64 = UFP64::max();
    ///     assert(ufp64.value == u64::max());
    /// }
    /// ```
    pub fn max() -> Self {
        Self {
            value: u64::max(),
        }
    }

    /// The smallest value that can be represented by this type.
    ///
    /// # Returns
    ///
    /// * [UFP64] - The newly created `UFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use fixed_point::UFP64;
    ///
    /// fn foo() {
    ///     let ufp64 = UFP64::min();
    ///     assert(ufp64.underlying == u64::min());
    /// }
    /// ```
    pub fn min() -> Self {
        Self {
            value: u64::min(),
        }
    }

    /// The zero value of this type.
    ///
    /// # Returns
    ///
    /// * [UFP64] - The newly created `UFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use fixed_point::UFP64;
    ///
    /// fn foo() {
    ///     let ufp64 = UFP64::zero();
    ///     assert(ufp64.underlying == 0);
    /// }
    /// ```
    pub fn zero() -> Self {
        Self { value: 0 }
    }
}

impl core::ops::Eq for UFP64 {
    fn eq(self, other: Self) -> bool {
        self.value == other.value
    }
}

impl core::ops::Ord for UFP64 {
    fn gt(self, other: Self) -> bool {
        self.value > other.value
    }

    fn lt(self, other: Self) -> bool {
        self.value < other.value
    }
}

impl core::ops::Add for UFP64 {
    /// Add a UFP64 to a UFP64. Panics on overflow.
    fn add(self, other: Self) -> Self {
        Self {
            value: self.value + other.value,
        }
    }
}

impl core::ops::Subtract for UFP64 {
    /// Subtract a UFP64 from a UFP64. Panics of overflow.
    fn subtract(self, other: Self) -> Self {
        // If trying to subtract a larger number, panic.
        assert(self.value >= other.value);

        Self {
            value: self.value - other.value,
        }
    }
}

impl core::ops::Multiply for UFP64 {
    /// Multiply a UFP64 with a UFP64. Panics of overflow.
    fn multiply(self, other: Self) -> Self {
        let self_u128 = U128::from((0, self.value));
        let other_u128 = U128::from((0, other.value));

        let self_multiply_other = self_u128 * other_u128;
        let res_u128 = self_multiply_other >> 32;
        if res_u128.upper != 0 {
            // panic on overflow
            revert(0);
        }

        Self {
            value: res_u128.lower,
        }
    }
}

impl core::ops::Divide for UFP64 {
    /// Divide a UFP64 by a UFP64. Panics if divisor is zero.
    fn divide(self, divisor: Self) -> Self {
        let zero = UFP64::zero();
        assert(divisor != zero);

        let denominator = U128::from((0, Self::denominator()));
        // Conversion to U128 done to ensure no overflow happen
        // and maximal precision is avaliable
        // as it makes possible to multiply by the denominator in 
        // all cases
        let self_u128 = U128::from((0, self.value));
        let divisor_u128 = U128::from((0, divisor.value));

        // Multiply by denominator to ensure accuracy 
        let res_u128 = self_u128 * denominator / divisor_u128;

        if res_u128.upper != 0 {
            // panic on overflow
            revert(0);
        }
        Self {
            value: res_u128.lower,
        }
    }
}

impl UFP64 {
    /// Creates UFP64 that corresponds to a unsigned integer.
    ///
    /// # Arguments
    ///
    /// * `uint`: [u64] - The unsigned number to become the underlying value for the `UFP64`.
    ///
    /// # Returns
    ///
    /// * [UFP64] - The newly created `UFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use fixed_point::UFP64;
    ///
    /// fn foo() {
    ///     let ufp64 = UFP64::from_uint(1);
    ///     assert(ufp64.underlying == 4294967296);
    /// }
    /// ```
    pub fn from_uint(uint: u64) -> Self {
        Self {
            value: Self::denominator() * uint,
        }
    }
}

impl UFP64 {
    /// Takes the reciprocal (inverse) of a number, `1/x`.
    ///
    /// # Arguments
    ///
    /// * `number`: [UFP64] - The value to create the reciprocal from.
    ///
    /// # Returns
    ///
    /// * [UFP64] - The newly created `UFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use fixed_point::UFP64;
    ///
    /// fn foo() {
    ///     let ufp64 = UFP64::from_uint(128);
    ///     let recip = UFP64::recip(ufp64);
    ///     assert(recip.underlying == 33554432);
    /// }
    /// ```
    pub fn recip(number: UFP64) -> Self {
        let one = UFP64::from_uint(1);

        let res = one / number;
        res
    }

    /// Returns the integer part of `self`.
    ///
    /// # Additional Information
    ///
    /// This means that non-integer numbers are always truncated towards zero.
    ///
    /// # Returns
    ///
    /// * [UFP64] - The newly created `UFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use fixed_point::UFP64;
    ///
    /// fn foo() {
    ///     let ufp64 = UFP64::from_uint(128);
    ///     let trunc = ufp64.trunc();
    ///     assert(trunc.underlying == 0);
    /// }
    /// ```
    pub fn trunc(self) -> Self {
        Self {
            // first move to the right (divide by the denominator)
            // to get rid of fractional part, than move to the
            // left (multiply by the denominator), to ensure 
            // fixed-point structure
            value: (self.value >> 32) << 32,
        }
    }
}

impl UFP64 {
    /// Returns the largest integer less than or equal to `self`.
    ///
    /// # Returns
    ///
    /// * [UFP64] - The newly created `UFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use fixed_point::UFP64;
    ///
    /// fn foo() {
    ///     let ufp64 = UFP64::from_uint(128);
    ///     let floor = ufp64.floor();
    ///     assert(floor.underlying == 0);
    /// }
    /// ```
    pub fn floor(self) -> Self {
        return self.trunc();
    }

    /// Returns the fractional part of `self`.
    ///
    /// # Returns
    ///
    /// * [UFP64] - the newly created `UFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use fixed_point::UFP64;
    ///
    /// fn foo() {
    ///     let ufp64 = UFP64::from_uint(128);
    ///     let fract = ufp64.fract();
    ///     assert(fract.underlying == 0);
    /// }
    /// ```
    pub fn fract(self) -> Self {
        Self {
            // first move to the left (multiply by the denominator)
            // to get rid of integer part, than move to the
            // right (divide by the denominator), to ensure 
            // fixed-point structure
            value: (self.value << 32) >> 32,
        }
    }
}

impl UFP64 {
    /// Returns the smallest integer greater than or equal to `self`.
    ///
    /// # Returns
    ///
    /// * [UFP64] - The newly created `UFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use fixed_point::UFP64;
    ///
    /// fn foo() {
    ///     let ufp64 = UFP64::from_uint(128);
    ///     let ceil = ufp64.ceil();
    ///     assert(ceil.underlying = 4294967296);
    /// }
    /// ```
    pub fn ceil(self) -> Self {
        if self.fract().value != 0 {
            let res = self.trunc() + UFP64::from_uint(1);
            return res;
        }
        return self;
    }
}

impl UFP64 {
    /// Returns the nearest integer to `self`. Round half-way cases away from zero.
    ///
    /// # Returns
    ///
    /// * [UFP64] - The newly created `UFP64` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use fixed_point::UFP64;
    ///
    /// fn foo() {
    ///     let ufp64 = UFP64::from_uint(128);
    ///     let round = ufp64.round();
    ///     assert(round.underlying == 0);
    /// }
    /// ```
    pub fn round(self) -> Self {
        let floor = self.floor();
        let ceil = self.ceil();
        let diff_self_floor = self - floor;
        let diff_ceil_self = ceil - self;

        // Check if we are closer to the floor or to the ceiling
        if diff_self_floor < diff_ceil_self {
            return floor;
        } else {
            return ceil;
        }
    }
}

impl Root for UFP64 {
    /// Sqaure root for UFP64
    fn sqrt(self) -> Self {
        let nominator_root = self.value.sqrt();
        // Need to multiply over 2 ^ 16, as the square root of the denominator 
        // is also taken and we need to ensure that the denominator is constant
        let nominator = nominator_root << 16;
        Self {
            value: nominator,
        }
    }
}

impl Exponent for UFP64 {
    /// Exponent function. e ^ x
    fn exp(exponent: Self) -> Self {
        let one = UFP64::from_uint(1);

        // Coefficients in the Taylor series up to the seventh power
        let p2 = UFP64::from(2147483648); // p2 == 1 / 2!
        let p3 = UFP64::from(715827882); // p3 == 1 / 3!
        let p4 = UFP64::from(178956970); // p4 == 1 / 4!
        let p5 = UFP64::from(35791394); // p5 == 1 / 5!
        let p6 = UFP64::from(5965232); // p6 == 1 / 6!
        let p7 = UFP64::from(852176); // p7 == 1 / 7!
        // Common technique to counter losing significant numbers in usual approximation
        // Taylor series approximation of exponentiation function minus 1. The subtraction is done to deal with accuracy issues
        let res_minus_1 = exponent + exponent * exponent * (p2 + exponent * (p3 + exponent * (p4 + exponent * (p5 + exponent * (p6 + exponent * p7)))));
        let res = res_minus_1 + one;
        res
    }
}

impl Power for UFP64 {
    /// Power function. x ^ exponent
    fn pow(self, exponent: Self) -> Self {
        let demoninator_power = UFP64::denominator();
        let exponent_int = exponent.value >> 32;
        let nominator_pow = U128::from((0, self.value)).pow(U128::from((0, exponent_int)));
        // As we need to ensure the fixed point structure 
        // which means that the denominator is always 2 ^ 32
        // we need to delete the nominator by 2 ^ (32 * exponent - 1)
        // - 1 is the formula is due to denominator need to stay 2 ^ 32
        let nominator = nominator_pow >> demoninator_power * (exponent_int - 1);

        if nominator.upper != 0 {
            // panic on overflow
            revert(0);
        }
        Self {
            value: nominator.lower,
        }
    }
}
