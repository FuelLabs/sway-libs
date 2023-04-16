library;
// A wrapper around U128 type for a library for Sway for mathematical functions operating with signed 64.64-bit fixed point numbers.
use std::{math::{Exponent, Power, Root}, u128::U128, u256::U256};

pub struct UFP128 {
    value: U128,
}

impl From<(u64, u64)> for UFP128 {
    fn from(int_fract_tuple: (u64, u64)) -> Self {
        Self {
            value: U128::from(int_fract_tuple),
        }
    }

    fn into(self) -> (u64, u64) {
        self.value.into()
    }
}

impl UFP128 {
    pub fn zero() -> Self {
        Self {
            value: U128::from((0, 0)),
        }
    }

    /// The smallest value that can be represented by this type.
    pub fn min() -> Self {
        Self {
            value: U128::min(),
        }
    }

    /// The largest value that can be represented by this type,
    pub fn max() -> Self {
        Self {
            value: U128::max(),
        }
    }

    /// The size of this type in bits.
    pub fn bits() -> u32 {
        128
    }
}

impl UFP128 {
    /// Creates UFP128 that correponds to a unsigned integer
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
        let self_u256 = U256::from((0, 0, self.value.upper, self.value.lower));
        let other_u256 = U256::from((0, 0, other.value.upper, other.value.lower));

        let self_multiply_other = self_u256 * other_u256;
        let res_u256 = self_multiply_other >> 64;
        if res_u256.a != 0 || res_u256.b != 0 {
            // panic on overflow
            revert(0);
        }
        Self::from((res_u256.c, res_u256.d))
    }
}

impl core::ops::Divide for UFP128 {
    /// Divide a UFP128 by a UFP128. Panics if divisor is zero.
    fn divide(self, divisor: Self) -> Self {
        let mut s = self;
        let zero = UFP128::zero();
        let u128_max = U128::max();

        assert(divisor != zero);

        // Conversion to U256 done to ensure no overflow happen
        // and maximal precision is avaliable
        // as it makes possible to multiply by the denominator in 
        // all cases
        let self_u256 = U256::from((0, 0, self.value.upper, self.value.lower));
        let divisor_u256 = U256::from((0, 0, divisor.value.upper, divisor.value.lower));

        // Multiply by denominator to ensure accuracy 
        let res_u256 = (self_u256 << 64) / divisor_u256;

        if res_u256.a != 0 || res_u256.b != 0 {
            // panic on overflow
            revert(0);
        }
        Self::from((res_u256.c, res_u256.d))
    }
}

impl UFP128 {
    pub fn recip(number: UFP128) -> Self {
        let one = UFP128::from((1, 0));

        one / number
    }

    pub fn floor(self) -> Self {
        Self::from((self.value.upper, 0))
    }

    pub fn ceil(self) -> Self {
        let val = self.value;
        if val.lower == 0 {
            return Self::from((val.upper, 0));
        } else {
            return Self::from((val.upper + 1, 0));
        }
    }
}

impl UFP128 {
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

    pub fn trunc(self) -> Self {
        Self::from((self.value.upper, 0))
    }

    pub fn fract(self) -> Self {
        Self::from((0, self.value.lower))
    }
}

impl Root for UFP128 {
    fn sqrt(self) -> Self {
        let numerator_root = self.value.sqrt();
        let numerator = numerator_root * U128::from((0, 2 << 32));
        Self::from((numerator.upper, numerator.lower))
    }
}

impl Power for UFP128 {
    fn pow(self, exponent: Self) -> Self {
        let nominator_pow = self.value.pow(exponent.value);
        let u128_1 = U128::from((0, 1));
        let u128_2 = U128::from((0, 2));
        let u128_64 = U128::from((0, 64));
        let two_pow_64_n_minus_1 = u128_2.pow(u128_64 * (exponent.value - u128_1));
        let nominator = nominator_pow / two_pow_64_n_minus_1;
        Self::from((nominator.upper, nominator.lower))
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
