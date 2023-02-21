library ifp64;
// A wrapper library around the u32 type for mathematical functions operating with signed 32-bit fixed point numbers.
use std::math::*;
use ::ufp32::UFP32;

pub struct IFP64 {
    underlying: UFP32,
    non_negative: bool,
}

impl From<UFP32> for IFP64 {
    /// Creates IFP64 from UFP32. Note that IFP64::from(1) is 1 / 2^32 and not 1.
    fn from(value: UFP32) -> Self {
        Self { underlying: value, non_negative: true }
    }

    fn into(self) -> UFP32 {
        self.underlying
    }
}

impl IFP64 {
    /// The size of this type in bits.
    pub fn bits() -> u32 {
        64
    }

    /// The largest value that can be represented by this type.
    pub fn max() -> Self {
        Self::from(UFP32::max())
    }

    /// The smallest value that can be represented by this type.
    pub fn min() -> Self {
        Self {
            underlying: UFP32::min(),
            non_negative: false,
        }
    }

    pub fn zero() -> Self {
        Self::from(UFP32::zero())
    }

    fn sign_reverse(self) -> Self {
        Self {
            underlying: self.underlying,
            non_negative: !self.non_negative,
        }
    }
}

impl core::ops::Eq for IFP64 {
    fn eq(self, other: Self) -> bool {
        self.underlying == other.underlying && (self.underlying == Self::zero().underlying || self.non_negative == other.non_negative)
    }
}

impl core::ops::Ord for IFP64 {
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

impl core::ops::Add for IFP64 {
    /// Add a IFP64 to a IFP64. Panics on overflow.
    fn add(self, other: Self) -> Self {
        let mut underlying = self.underlying;
        let mut non_negative = self.non_negative;
        if self.non_negative && !self.non_negative {
            if self.underlying > other.underlying {
                underlying = self.underlying - other.underlying;
            } else {
                underlying = other.underlying - self.underlying;
                non_negative = false;
            }
        } else if !self.non_negative && self.non_negative {
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
        let non_negative = if (self.non_negative && !self.non_negative) || (!self.non_negative && self.non_negative) {
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
        let non_negative = if (self.non_negative && !self.non_negative) || (!self.non_negative && self.non_negative) {
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
    /// Creates IFP64 that correponds to a unsigned integer
    pub fn from_uint(uint: u32) -> Self {
        Self::from(UFP32::from_uint(uint))
    }
}

impl IFP64 {
    /// Takes the reciprocal (inverse) of a number, `1/x`.
    pub fn recip(number: IFP64) -> Self {
        Self {
            underlying: UFP32::recip(number.underlying),
            non_negative: number.non_negative,
        }
    }

    /// Returns the integer part of `self`.
    /// This means that non-integer numbers are always truncated towards zero.
    pub fn trunc(self) -> Self {
        Self {
            underlying: self.underlying.trunc(),
            non_negative: self.non_negative,
        }
    }
}

impl IFP64 {
    /// Returns the largest integer less than or equal to `self`.
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
    pub fn fract(self) -> Self {
        Self {
            underlying: self.underlying.fract(),
            non_negative: self.non_negative,
        }
    }
}

impl IFP64 {
    /// Returns the smallest integer greater than or equal to `self`.
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
    /// Returns the nearest integer to `self`. Round half-way cases away from
    pub fn round(self) -> Self {
        let mut underlying = self.underlying;
        let mut non_negative = self.non_negative;

        if self.non_negative {
            underlying = self.underlying.round();
        } else {
            let floor = self.underlying.floor();
            let ceil = self.underlying.ceil();
            let diff_self_floor = self.underlying - floor;
            let diff_ceil_self = ceil - self.underlying;
            let underlying = if diff_self_floor > diff_ceil_self {
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
        let p2 = IFP64::from(UFP32::from(2147483648u32)); // p2 == 1 / 2!
        let p3 = IFP64::from(UFP32::from(715827882u32)); // p3 == 1 / 3!
        let p4 = IFP64::from(UFP32::from(178956970u32)); // p4 == 1 / 4!
        let p5 = IFP64::from(UFP32::from(35791394u32)); // p5 == 1 / 5!
        let p6 = IFP64::from(UFP32::from(5965232u32)); // p6 == 1 / 6!
        let p7 = IFP64::from(UFP32::from(852176u32)); // p7 == 1 / 7!
        // Common technique to counter losing significant numbers in usual approximation
        // Taylor series approximation of exponentiation function minus 1. The subtraction is done to deal with accuracy issues
        let res_minus_1 = exponent + exponent * exponent * (p2 + exponent * (p3 + exponent * (p4 + exponent * (p5 + exponent * (p6 + exponent * p7)))));
        let res = res_minus_1 + one;
        res
    }
}

impl Exponentiate for IFP64 {
    /// Power function. x ^ exponent
    fn pow(self, exponent: Self) -> Self {
        let non_negative = if !self.non_negative {
            // roots of negative numbers are complex numbers which we lack for now
            assert(exponent.underlying.floor() == exponent.underlying);

            let div_2 = exponent.underlying / UFP32::from(2u32);
            div_2.floor() == div_2
        } else {
            true
        };
        let mut underlying = self.underlying.pow(exponent.underlying);
        if !exponent.non_negative {
            underlying = UFP32::recip(underlying);
        }
        Self {
            underlying: underlying,
            non_negative: non_negative,
        }
    }
}
