library;
// A wrapper library around the u32 type for mathematical functions operating with unsigned 32-bit fixed point numbers.
use std::math::*;

/// The 32-bit unsigned fixed point number type.
///
/// # Additional Information
///
/// Represented by an underlying `u32` number.
pub struct UFP32 {
    /// The underlying value representing the `UFP32` type.
    underlying: u32,
}

impl From<u32> for UFP32 {
    /// Creates UFP32 from u32. Note that UFP32::from(1) is 1 / 2^32 and not 1.
    fn from(underlying: u32) -> Self {
        Self { underlying }
    }
}

impl UFP32 {
    /// The size of this type in bits.
    ///
    /// # Returns
    ///
    /// [u64] - The defined size of the `UFP32` type.
    ///
    /// # Examples
    ///
    /// ``sway
    /// use libraries::fixed_point::ufp32::UFP32;
    ///
    /// fn foo() {
    ///     let bits = UFP32::bits();
    ///     assert(bits == 32);
    /// }
    /// ```
    pub fn bits() -> u64 {
        32
    }

    /// Convenience function to know the denominator.
    ///
    /// # Returns
    ///
    /// * [u32] - The value of the denominator for the `UFP32` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp32::UFP32;
    ///
    /// fn foo() {
    ///     let denominator = UFP32::denominator();
    ///     assert(denominator == 65536u32);
    /// }
    /// ```
    pub fn denominator() -> u32 {
        1u32 << 16
    }

    /// The largest value that can be represented by this type.
    ///
    /// # Returns
    ///
    /// * [UFP32] - The newly created `UFP32` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp32::UFP32;
    ///
    /// fn foo() {
    ///     let ufp32 = UFP32::max();
    ///     assert(ufp32.underlying() == u32::max());
    /// }
    /// ```
    pub fn max() -> Self {
        Self {
            underlying: u32::max(),
        }
    }

    /// The smallest value that can be represented by this type.
    ///
    /// # Returns
    ///
    /// * [UFP32] - The newly created `UFP32` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp32::UFP32;
    ///
    /// fn foo() {
    ///     let ufp32 = UFP32::min();
    ///     assert(ufp32.underlying() == u32::min());
    /// }
    /// ```
    pub fn min() -> Self {
        Self {
            underlying: u32::min(),
        }
    }

    /// The zero value of this type.
    ///
    /// # Returns
    ///
    /// * [UFP32] - The newly created `UFP32` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp32::UFP32;
    ///
    /// fn foo() {
    ///     let ufp32 = UFP32::zero();
    ///     assert(ufp32.underlying() == 0u32);
    /// }
    /// ```
    pub fn zero() -> Self {
        Self {
            underlying: 0u32,
        }
    }

    /// Returns whether a `UFP32` is set to zero.
    ///
    /// # Returns
    ///
    /// * [bool] -> True if the `UFP32` is zero, otherwise false.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::ufp32::UFP32;
    ///
    /// fn foo() {
    ///     let ufp32 = UFP32::zero();
    ///     assert(ufp32.is_zero());
    /// }
    /// ```
    pub fn is_zero(self) -> bool {
        self.underlying == 0u32
    }

    /// Returns the underlying `u32` representing the `UFP32`.
    ///
    /// # Returns
    ///
    /// * [u32] - The `u32` representing the `UFP32`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::fixed_point::ufp32::UFP32;
    ///
    /// fn foo() {
    ///     let ufp32 = UFP32::zero();
    ///     assert(ufp32.underlying() == 0u32);
    /// }
    /// ```
    pub fn underlying(self) -> u32 {
        self.underlying
    }
}

impl core::ops::Eq for UFP32 {
    fn eq(self, other: Self) -> bool {
        self.underlying == other.underlying
    }
}

impl core::ops::Ord for UFP32 {
    fn gt(self, other: Self) -> bool {
        self.underlying > other.underlying
    }

    fn lt(self, other: Self) -> bool {
        self.underlying < other.underlying
    }
}

impl core::ops::Add for UFP32 {
    /// Add a UFP32 to a UFP32. Panics on overflow.
    fn add(self, other: Self) -> Self {
        Self {
            underlying: self.underlying + other.underlying,
        }
    }
}

impl core::ops::Subtract for UFP32 {
    /// Subtract a UFP32 from a UFP32. Panics of overflow.
    fn subtract(self, other: Self) -> Self {
        // If trying to subtract a larger number, panic.
        assert(self.underlying >= other.underlying);

        Self {
            underlying: self.underlying - other.underlying,
        }
    }
}

impl core::ops::Multiply for UFP32 {
    /// Multiply a UFP32 with a UFP32. Panics of overflow.
    fn multiply(self, other: Self) -> Self {
        let self_u64: u64 = self.underlying.as_u64();
        let other_u64: u64 = other.underlying.as_u64();

        let self_multiply_other = self_u64 * other_u64;
        let res_u64 = self_multiply_other >> 16;
        if res_u64 > u32::max().as_u64() {
            // panic on overflow
            revert(0);
        }

        Self {
            underlying: asm(ptr: res_u64) {
                ptr: u32
            },
        }
    }
}

impl core::ops::Divide for UFP32 {
    /// Divide a UFP32 by a UFP32. Panics if divisor is zero.
    fn divide(self, divisor: Self) -> Self {
        let zero = UFP32::zero();
        assert(divisor != zero);

        let denominator: u64 = Self::denominator().as_u64();
        // Conversion to U64 done to ensure no overflow happen
        // and maximal precision is avaliable
        // as it makes possible to multiply by the denominator in 
        // all cases
        let self_u64: u64 = self.underlying.as_u64();
        let divisor_u64: u64 = divisor.underlying.as_u64();

        // Multiply by denominator to ensure accuracy 
        let res_u64 = self_u64 * denominator / divisor_u64;

        if res_u64 > u32::max().as_u64() {
            // panic on overflow
            revert(0);
        }
        Self {
            underlying: asm(ptr: res_u64) {
                ptr: u32
            },
        }
    }
}

impl UFP32 {
    /// Creates UFP32 that corresponds to a unsigned integer.
    ///
    /// # Arguments
    ///
    /// * `uint`: [u32] - The unsigned number to become the underlying value for the `UFP32`.
    ///
    /// # Returns
    ///
    /// * [UFP32] - The newly created `UFP32` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp32::UFP32;
    ///
    /// fn foo() {
    ///     let ufp32 = UFP32::from_uint(1u32);
    ///     assert(ufp32.underlying() == 65536u32);
    /// }
    /// ```
    pub fn from_uint(uint: u32) -> Self {
        Self {
            underlying: Self::denominator() * uint,
        }
    }
}

impl UFP32 {
    /// Takes the reciprocal (inverse) of a number, `1/x`.
    ///
    /// # Arguments
    ///
    /// * `number`: [UFP32] - The value to create the reciprocal from.
    ///
    /// # Returns
    ///
    /// * [UFP32] - The newly created `UFP32` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp32::UFP32;
    ///
    /// fn foo() {
    ///     let ufp32 = UFP32::from_uint(128u32);
    ///     let recip = UFP32::recip(ufp32);
    ///     assert(recip.underlying() == 512u32);
    /// }
    /// ```
    pub fn recip(number: UFP32) -> Self {
        let one = UFP32::from_uint(1u32);

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
    /// * [UFP32] - The newly created `UFP32` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp32::UFP32;
    ///
    /// fn foo() {
    ///     let ufp32 = UFP32::from_uint(128u32);
    ///     let trunc = ufp32.trunc();
    ///     assert(trunc.underlying() == 0);
    /// }
    /// ```
    pub fn trunc(self) -> Self {
        Self {
            // first move to the right (divide by the denominator)
            // to get rid of fractional part, than move to the
            // left (multiply by the denominator), to ensure 
            // fixed-point structure
            underlying: (self.underlying >> 16) << 16,
        }
    }
}

impl UFP32 {
    /// Returns the largest integer less than or equal to `self`.
    ///
    /// # Returns
    ///
    /// * [UFP32] - The newly created `UFP32` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp32::UFP32;
    ///
    /// fn foo() {
    ///     let ufp32 = UFP32::from_uint(128u32);
    ///     let floor = ufp32.floor();
    ///     assert(floor.underlying() == 0);
    /// }
    /// ```
    pub fn floor(self) -> Self {
        return self.trunc();
    }

    /// Returns the fractional part of `self`.
    ///
    /// # Returns
    ///
    /// * [UFP32] - the newly created `UFP32` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp32::UFP32;
    ///
    /// fn foo() {
    ///     let ufp32 = UFP32::from_uint(128u32);
    ///     let fract = ufp32.fract();
    ///     assert(fract.underlying() == 0);
    /// }
    /// ```
    pub fn fract(self) -> Self {
        Self {
            // first move to the left (multiply by the denominator)
            // to get rid of integer part, than move to the
            // right (divide by the denominator), to ensure 
            // fixed-point structure
            underlying: ((self.underlying << 16) - u32::max() - 1u32) >> 16,
        }
    }
}

impl UFP32 {
    /// Returns the smallest integer greater than or equal to `self`.
    ///
    /// # Returns
    ///
    /// * [UFP32] - The newly created `UFP32` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp32::UFP32;
    ///
    /// fn foo() {
    ///     let ufp32 = UFP32::from_uint(128u32);
    ///     let ceil = ufp32.ceil();
    ///     assert(ceil.underlying() = 65536u32);
    /// }
    /// ```
    pub fn ceil(self) -> Self {
        if self.fract().underlying != 0u32 {
            let res = self.trunc() + UFP32::from_uint(1u32);
            return res;
        }
        return self;
    }
}

impl UFP32 {
    /// Returns the nearest integer to `self`. Round half-way cases away from zero.
    ///
    /// # Returns
    ///
    /// * [UFP32] - The newly created `UFP32` type.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use libraries::fixed_point::ufp32::UFP32;
    ///
    /// fn foo() {
    ///     let ufp32 = UFP32::from_uint(128_u32);
    ///     let round = ufp32.round();
    ///     assert(round.underlying() == 0);
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

impl Root for UFP32 {
    /// Sqaure root for UFP32
    fn sqrt(self) -> Self {
        let nominator_root = self.underlying.sqrt();
        // Need to multiply over 2 ^ 16, as the square root of the denominator 
        // is also taken and we need to ensure that the denominator is constant
        let nominator = nominator_root << 16;
        Self {
            underlying: nominator,
        }
    }
}

impl Exponent for UFP32 {
    /// Exponent function. e ^ x
    fn exp(exponent: Self) -> Self {
        let one = UFP32::from_uint(1u32);

        // Coefficients in the Taylor series up to the seventh power
        let p2 = UFP32::from(2147483648u32); // p2 == 1 / 2!
        let p3 = UFP32::from(715827882u32); // p3 == 1 / 3!
        let p4 = UFP32::from(178956970u32); // p4 == 1 / 4!
        let p5 = UFP32::from(35791394u32); // p5 == 1 / 5!
        let p6 = UFP32::from(5965232u32); // p6 == 1 / 6!
        let p7 = UFP32::from(852176u32); // p7 == 1 / 7!
        // Common technique to counter losing significant numbers in usual approximation
        // Taylor series approximation of exponentiation function minus 1. The subtraction is done to deal with accuracy issues
        let res_minus_1 = exponent + exponent * exponent * (p2 + exponent * (p3 + exponent * (p4 + exponent * (p5 + exponent * (p6 + exponent * p7)))));
        let res = res_minus_1 + one;
        res
    }
}

impl Power for UFP32 {
    /// Power function. x ^ exponent
    fn pow(self, exponent: u32) -> Self {
        let nominator_pow = self.underlying.pow(exponent);
        // As we need to ensure the fixed point structure 
        // which means that the denominator is always 2 ^ 16
        // we need to divide the nominator by 2 ^ (16 * exponent - 1)
        // - 1 is the formula is due to denominator need to stay 2 ^ 16
        let nominator = nominator_pow >> 16 * (exponent - 1u32).as_u64();

        if nominator > u32::max() {
            // panic on overflow
            revert(0);
        }
        Self {
            underlying: nominator,
        }
    }
}
