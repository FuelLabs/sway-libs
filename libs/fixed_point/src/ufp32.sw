library ufp32;
// A wrapper library around the u32 type for mathematical functions operating with signed 32-bit fixed point numbers.
use std::math::*;

pub struct UFP32 {
    value: u32,
}

impl From<u32> for UFP32 {
    /// Creates UFP32 from u32. Note that UFP32::from(1) is 1 / 2^32 and not 1.
    fn from(value: u32) -> Self {
        Self { value }
    }

    fn into(self) -> u32 {
        self.value
    }
}

impl UFP32 {
    /// The size of this type in bits.
    pub fn bits() -> u32 {
        32
    }

    /// Convenience function to know the denominator.
    pub fn denominator() -> u32 {
        1 << 16
    }

    /// The largest value that can be represented by this type.
    pub fn max() -> Self {
        Self {
            value: u32::max(),
        }
    }

    /// The smallest value that can be represented by this type.
    pub fn min() -> Self {
        Self {
            value: u32::min(),
        }
    }

    pub fn zero() -> Self {
        Self { value: 0 }
    }
}

impl core::ops::Eq for UFP32 {
    fn eq(self, other: Self) -> bool {
        self.value == other.value
    }
}

impl core::ops::Ord for UFP32 {
    fn gt(self, other: Self) -> bool {
        self.value > other.value
    }

    fn lt(self, other: Self) -> bool {
        self.value < other.value
    }
}

impl core::ops::Add for UFP32 {
    /// Add a UFP32 to a UFP32. Panics on overflow.
    fn add(self, other: Self) -> Self {
        Self {
            value: self.value + other.value,
        }
    }
}

impl core::ops::Subtract for UFP32 {
    /// Subtract a UFP32 from a UFP32. Panics of overflow.
    fn subtract(self, other: Self) -> Self {
        // If trying to subtract a larger number, panic.
        assert(self.value >= other.value);

        Self {
            value: self.value - other.value,
        }
    }
}

impl core::ops::Multiply for UFP32 {
    /// Multiply a UFP32 with a UFP32. Panics of overflow.
    fn multiply(self, other: Self) -> Self {
        let self_u64: u64 = self.value;
        let other_u64: u64 = other.value;

        let self_multiply_other = self_u64 * other_u64;
        let res_u64 = self_multiply_other >> 16;
        if res_u64 > u32::max() {
            // panic on overflow
            revert(0);
        }

        Self {
            value: res_u64,
        }
    }
}

impl core::ops::Divide for UFP32 {
    /// Divide a UFP32 by a UFP32. Panics if divisor is zero.
    fn divide(self, divisor: Self) -> Self {
        let zero = UFP32::zero();
        assert(divisor != zero);

        let denominator: u64 = Self::denominator();
        // Conversion to U64 done to ensure no overflow happen
        // and maximal precision is avaliable
        // as it makes possible to multiply by the denominator in 
        // all cases
        let self_u64: u64 = self.value;
        let divisor_u64: u64 = divisor.value;

        // Multiply by denominator to ensure accuracy 
        let res_u64 = self_u64 * denominator / divisor_u64;

        if res_u64 > u32::max() {
            // panic on overflow
            revert(0);
        }
        Self {
            value: res_u64,
        }
    }
}

impl UFP32 {
    /// Creates UFP32 that correponds to a unsigned integer
    pub fn from_uint(uint: u32) -> Self {
        Self {
            value: Self::denominator() * uint,
        }
    }
}

impl UFP32 {
    /// Takes the reciprocal (inverse) of a number, `1/x`.
    pub fn recip(number: UFP32) -> Self {
        let one = UFP32::from_uint(1);

        let res = one / number;
        res
    }

    /// Returns the integer part of `self`.
    /// This means that non-integer numbers are always truncated towards zero.
    pub fn trunc(self) -> Self {
        Self {
            // first move to the right (divide by the denominator)
            // to get rid of fractional part, than move to the
            // left (multiply by the denominator), to ensure 
            // fixed-point structure
            value: (self.value >> 16) << 16,
        }
    }
}

impl UFP32 {
    /// Returns the largest integer less than or equal to `self`.
    pub fn floor(self) -> Self {
        return self.trunc();
    }

    /// Returns the fractional part of `self`.
    pub fn fract(self) -> Self {
        Self {
            // first move to the left (multiply by the denominator)
            // to get rid of integer part, than move to the
            // right (divide by the denominator), to ensure 
            // fixed-point structure
            value: (self.value << 16) >> 16,
        }
    }
}

impl UFP32 {
    /// Returns the smallest integer greater than or equal to `self`.
    pub fn ceil(self) -> Self {
        if self.fract().value != 0 {
            let res = self.trunc() + UFP32::from_uint(1);
            return res;
        }
        return self;
    }
}

impl UFP32 {
    /// Returns the nearest integer to `self`. Round half-way cases away from
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
        let nominator_root = self.value.sqrt();
         // Need to multiply over 2 ^ 16, as the square root of the denominator 
        // is also taken and we need to ensure that the denominator is constant
        let nominator = nominator_root << 16;
        Self {
            value: nominator,
        }
    }
}

impl Exponent for UFP32 {
    /// Exponent function. e ^ x
    fn exp(exponent: Self) -> Self {
        let one = UFP32::from_uint(1);

        // Coefficients in the Taylor series up to the seventh power
        let p2 = UFP32::from(2147483648); // p2 == 1 / 2!
        let p3 = UFP32::from(715827882); // p3 == 1 / 3!
        let p4 = UFP32::from(178956970); // p4 == 1 / 4!
        let p5 = UFP32::from(35791394); // p5 == 1 / 5!
        let p6 = UFP32::from(5965232); // p6 == 1 / 6!
        let p7 = UFP32::from(852176); // p7 == 1 / 7!
        // Common technique to counter losing significant numbers in usual approximation
        // Taylor series approximation of exponentiation function minus 1. The subtraction is done to deal with accuracy issues
        let res_minus_1 = exponent + exponent * exponent * (p2 + exponent * (p3 + exponent * (p4 + exponent * (p5 + exponent * (p6 + exponent * p7)))));
        let res = res_minus_1 + one;
        res
    }
}

impl Exponentiate for UFP32 {
    /// Power function. x ^ exponent
    fn pow(self, exponent: Self) -> Self {
        let demoninator_power = UFP32::denominator();
        let exponent_int = exponent.value >> 32;
        let nominator_pow = self.value.pow(exponent_int);
        // As we need to ensure the fixed point structure 
        // which means that the denominator is always 2 ^ 16
        // we need to delete the nominator by 2 ^ (16 * exponent - 1)
        // - 1 is the formula is due to denominator need to stay 2 ^ 16
        let nominator = nominator_pow >> demoninator_power * (exponent_int - 1);

        if nominator > u32::max() {
            // panic on overflow
            revert(0);
        }
        Self {
            value: nominator,
        }
    }
}
