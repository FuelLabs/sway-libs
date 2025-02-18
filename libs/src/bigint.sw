library;

use std::{alloc::alloc, bytes::Bytes, convert::{Into, TryInto}, flags::*, u128::U128};

/// The `BigUint` type.
///
/// # Additional Information
///
/// The `BigUint` type is unsigned. The minimum value is zero and the maximum value is infinity.
pub struct BigUint {
    /// The underlying limbs representing the `BigUint` type.
    limbs: Vec<u64>,
}

impl BigUint {
    /// Create a new instance of a `BigUint`.
    ///
    /// # Returns
    ///
    /// * [BigUint] - A newly instantiated instance of a `BigUint`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::bigint::BigUint;
    ///
    /// fn foo() {
    ///     let new_big_uint = BigUint::new();
    ///     assert(new_big_uint.is_zero());
    /// }
    /// ```
    pub fn new() -> Self {
        let mut vec = Vec::with_capacity(1);
        vec.push(0);
        Self { limbs: vec }
    }

    /// Returns true if two `BigUint` numbers have the same number of limbs.
    ///
    /// # Arguments
    ///
    /// * `other`: [BigUint] - The other `BigUint` to compare with.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` if both `BigUint` values have the same limbs, otherwise false.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::bigint::BigUint;
    ///
    /// fn foo() {
    ///     let new_big_uint = BigUint::new();
    ///     let u64_big_uint = BigUint::from(u64::max());
    ///     let u256_big_uint = BigUint::from(u256::max());
    ///
    ///     assert(new_big_uint.equal_limb_size(u64_big_uint));
    ///     assert(!new_big_uint.equal_limb_size(u256_big_uint));
    ///     assert(!u64_big_uint.equal_limb_size(u256_big_uint));
    /// }
    /// ```
    pub fn equal_limb_size(self, other: BigUint) -> bool {
        self.limbs.len() == other.limbs.len()
    }

    /// Returns the number of limbs the `BigUint` has.
    ///
    /// # Returns
    ///
    /// * [u64] - The number of limbs the `BigUint` has.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::bigint::BigUint;
    ///
    /// fn foo() {
    ///     let new_big_uint = BigUint::new();
    ///     let u64_big_uint = BigUint::from(u64::max());
    ///     let u256_big_uint = BigUint::from(u256::max());
    ///
    ///     assert(new_big_uint.number_of_limbs() == 1);
    ///     assert(u64_big_uint.number_of_limbs() == 1);
    ///     assert(u256_big_uint.number_of_limbs() == 4);
    /// }
    /// ```
    pub fn number_of_limbs(self) -> u64 {
        self.limbs.len()
    }

    /// Returns a copy of the `BigUint`'s limbs.
    ///
    /// # Returns
    ///
    /// * [Vec<u64>] - A clone of the `BigUint`'s limbs.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::bigint::BigUint;
    ///
    /// fn foo() {
    ///     let new_big_uint = BigUint::new();
    ///     let new_limbs: Vec<u64> = new_big_uint.limbs();
    ///     assert(new_limbs.len() == 1);
    ///     assert(new_limbs.get(0).unwrap() == 0);
    ///
    ///     let u64_big_uint = BigUint::from(u64::max());
    ///     let u64_limbs: Vec<u64> = u64_big_uint.limbs();
    ///     assert(u64_limbs.len() == 1);
    ///     assert(u64_limbs.get(0).unwrap() == u64::max());
    ///
    ///     let u256_big_uint = BigUint::from(u256::max());
    ///     let u256_limbs: Vec<u64> = u256_big_uint.limbs();
    ///     assert(u256_limbs.len() == 4);
    ///     assert(u256_limbs.get(0).unwrap() == u64::max());
    ///     assert(u256_limbs.get(1).unwrap() == u64::max());
    ///     assert(u256_limbs.get(2).unwrap() == u64::max());
    ///     assert(u256_limbs.get(3).unwrap() == u64::max());
    /// }
    /// ```
    pub fn limbs(self) -> Vec<u64> {
        self.limbs.clone()
    }

    /// Returns the `BigUint`'s limb at a specific index.
    ///
    /// # Arguments
    ///
    /// * `index`: [u64] - The index at which to fetch the limb.
    ///
    /// # Returns
    ///
    // * [Option<u64>] - Some(u64) if `index` is valid and within range, otherwise false.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::bigint::BigUint;
    ///
    /// fn foo() {
    ///     let new_big_uint = BigUint::new();
    ///     assert(new_big_uint.get_limb(0).unwrap() == 0);
    ///     assert(new_big_uint.get_limb(1).is_none());
    ///
    ///     let u64_big_uint = BigUint::from(u64::max());
    ///     assert(u64_big_uint.get_limb(0).unwrap() == u64::max());
    ///     assert(u64_big_uint.get_limb(1).is_none());
    ///
    ///     let u256_big_uint = BigUint::from(u256::max());
    ///     assert(u256_big_uint.get_limb(0).unwrap() == u64::max());
    ///     assert(u256_big_uint.get_limb(1).unwrap() == u64::max());
    ///     assert(u256_big_uint.get_limb(2).unwrap() == u64::max());
    ///     assert(u256_big_uint.get_limb(3).unwrap() == u64::max());
    ///     assert(u256_big_uint.get_limb(4).is_none());
    /// }
    /// ```
    pub fn get_limb(self, index: u64) -> Option<u64> {
        self.limbs.get(index)
    }

    /// A zeroed instance of a `BigUint`.
    ///
    /// # Returns
    ///
    /// * [BigUint] - A newly created zeroed `BigUint`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::bigint::BigUint;
    ///
    /// fn foo() {
    ///     let zero_big_uint = BigUint::zero();
    ///     assert(zero_big_uint.is_zero());
    /// }
    /// ```
    pub fn zero() -> Self {
        let mut vec = Vec::with_capacity(1);
        vec.push(0);
        Self { limbs: vec }
    }

    /// Returns whether the `BigUint` is zero.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` if the `BigUint` is zero, otherwise `false`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::bigint::BigUint;
    ///
    /// fn foo() {
    ///     let zero_big_uint = BigUint::zero();
    ///     assert(zero_big_uint.is_zero());
    /// }
    /// ```
    pub fn is_zero(self) -> bool {
        self.limbs.len() == 1 && self.limbs.get(0).unwrap() == 0
    }
}

impl Clone for BigUint {
    fn clone(self) -> Self {
        Self {
            limbs: self.limbs.clone(),
        }
    }
}

impl From<u8> for BigUint {
    fn from(value: u8) -> Self {
        let mut vec = Vec::new();
        vec.push(value.into());
        Self { limbs: vec }
    }
}

impl TryInto<u8> for BigUint {
    fn try_into(self) -> Option<u8> {
        if self.limbs.len() == 1 {
            self.limbs.get(0).unwrap().try_as_u8()
        } else {
            None
        }
    }
}

impl From<u16> for BigUint {
    fn from(value: u16) -> Self {
        let mut vec = Vec::new();
        vec.push(value.into());
        Self { limbs: vec }
    }
}

impl TryInto<u16> for BigUint {
    fn try_into(self) -> Option<u16> {
        if self.limbs.len() == 1 {
            self.limbs.get(0).unwrap().try_as_u16()
        } else {
            None
        }
    }
}

impl From<u32> for BigUint {
    fn from(value: u32) -> Self {
        let mut vec = Vec::new();
        vec.push(value.into());
        Self { limbs: vec }
    }
}

impl TryInto<u32> for BigUint {
    fn try_into(self) -> Option<u32> {
        if self.limbs.len() == 1 {
            self.limbs.get(0).unwrap().try_as_u32()
        } else {
            None
        }
    }
}

impl From<u64> for BigUint {
    fn from(value: u64) -> Self {
        let mut vec = Vec::new();
        vec.push(value);
        Self { limbs: vec }
    }
}

impl TryInto<u64> for BigUint {
    fn try_into(self) -> Option<u64> {
        if self.limbs.len() == 1 {
            self.limbs.get(0)
        } else {
            None
        }
    }
}

impl From<U128> for BigUint {
    fn from(value: U128) -> Self {
        let mut vec = Vec::new();
        vec.push(value.lower());

        // Only push upper if it's not zero
        let upper = value.upper();
        if upper != 0 {
            vec.push(upper);
        }

        Self { limbs: vec }
    }
}

impl TryInto<U128> for BigUint {
    fn try_into(self) -> Option<U128> {
        if self.limbs.len() == 2 || self.limbs.len() == 1 {
            let lower = self.limbs.get(0).unwrap_or(0);
            let upper = self.limbs.get(1).unwrap_or(0);
            Some(U128::from((upper, lower)))
        } else {
            None
        }
    }
}

impl From<u256> for BigUint {
    fn from(value: u256) -> Self {
        let mut vec = Vec::with_capacity(4);
        let (u64_1, u64_2, u64_3, u64_4) = asm(val: value) {
            val: (u64, u64, u64, u64)
        };
        vec.push(u64_4);
        vec.push(u64_3);
        vec.push(u64_2);
        vec.push(u64_1);

        // Remove leading zeros
        while vec.len() > 1 && vec.last() == Some(0) {
            let _ = vec.pop();
        }

        Self { limbs: vec }
    }
}

impl TryInto<u256> for BigUint {
    fn try_into(self) -> Option<u256> {
        if self.limbs.len() <= 4 && self.limbs.len() >= 1 {
            let u64_1 = self.limbs.get(0).unwrap_or(0);
            let u64_2 = self.limbs.get(1).unwrap_or(0);
            let u64_3 = self.limbs.get(2).unwrap_or(0);
            let u64_4 = self.limbs.get(3).unwrap_or(0);
            Some(
                asm(val: (u64_4, u64_3, u64_2, u64_1)) {
                    val: u256
                },
            )
        } else {
            None
        }
    }
}

impl From<Bytes> for BigUint {
    fn from(bytes: Bytes) -> Self {
        let bytes_len = bytes.len();
        if bytes_len == 0 {
            return Self::new();
        }

        let mut result: Vec<u64> = Vec::new();

        // Start from the last values and move forward
        let bytes_remaining = bytes_len % 8;
        let mut iter = bytes_len / 8;
        while iter > 0 {
            let ptr = bytes.ptr().add::<u8>(((iter - 1) * 8) + bytes_remaining);
            result.push(ptr.read::<u64>());
            iter -= 1;
        }

        // Padding is required if it doesn't fit into u64
        if bytes_remaining != 0 {
            // Do some padding
            let mut result_u64 = alloc::<u64>(1);
            bytes
                .ptr()
                .copy_bytes_to(result_u64.add::<u8>(8 - bytes_remaining), bytes_remaining);
            result.push(result_u64.read::<u64>());
        }

        // Remove leading zeros
        while result.len() > 1 && result.get(result.len() - 1) == Some(0) {
            let _ = result.pop();
        }

        Self { limbs: result }
    }
}

impl Into<Bytes> for BigUint {
    fn into(self) -> Bytes {
        let number_of_u8 = self.limbs.len() * 8;
        let mut result_ptr = alloc::<u8>(number_of_u8);

        // Start from the back and fill
        let mut iter = self.limbs.len();
        let mut ptr_iter = 0;
        while iter > 0 {
            iter -= 1;
            self.limbs
                .ptr()
                .add::<u64>(iter)
                .copy_to::<u64>(result_ptr.add::<u64>(ptr_iter), 1);
            ptr_iter += 1;
        }

        // Determine the number of leading zeros
        let mut leading_zeros = 0;
        while result_ptr.add::<u8>(leading_zeros).read::<u8>() == 0 && leading_zeros < number_of_u8 {
            leading_zeros += 1;
        }

        // Shift the pointer down and ignore the leading zeros
        Bytes::from(raw_slice::from_parts::<u8>(
            result_ptr
                .add::<u8>(leading_zeros),
            number_of_u8 - leading_zeros,
        ))
    }
}

impl core::ops::Eq for BigUint {
    fn eq(self, other: Self) -> bool {
        if self.limbs.len() != other.limbs.len() {
            false
        } else {
            let mut iter = 0;
            while iter < self.limbs.len() {
                if self.limbs.get(iter).unwrap() != other.limbs.get(iter).unwrap()
                {
                    return false;
                }
                iter += 1;
            }

            true
        }
    }
}

impl core::ops::Ord for BigUint {
    fn gt(self, other: Self) -> bool {
        // Save some gas by assuming anything with more limbs is larger
        if self.limbs.len() == other.limbs.len() {
            // Start from the largest values and move down
            let mut iter = self.limbs.len();
            while iter > 0 {
                iter -= 1;

                // If these two values are the same, move to the next one
                if self.limbs.get(iter).unwrap() != other.limbs.get(iter).unwrap()
                {
                    return self.limbs.get(iter).unwrap() > other.limbs.get(iter).unwrap()
                } else {            }
            }

            // If everything is the same, false
            false
        } else {
            return self.limbs.len() > other.limbs.len()
        }
    }

    fn lt(self, other: Self) -> bool {
        // Save some gas by assuming anything with more limbs is larger
        if self.limbs.len() == other.limbs.len() {
            // Start from the largest values and move down
            let mut iter = self.limbs.len();
            while iter > 0 {
                iter -= 1;

                // If these two values are the same, move to the next one
                if self.limbs.get(iter).unwrap() != other.limbs.get(iter).unwrap()
                {
                    return self.limbs.get(iter).unwrap() < other.limbs.get(iter).unwrap()
                }
            }

            // If everything is the same, false
            false
        } else {
            return self.limbs.len() < other.limbs.len()
        }
    }
}

impl core::ops::OrdEq for BigUint {}

fn add_with_carry_u64(a: u64, b: u64, c: u64) -> (u64, u64) {
    let a_u128: U128 = a.into();
    let b_u128: U128 = b.into();
    let c_u128: U128 = c.into();

    let sum: U128 = a_u128 + b_u128 + c_u128;
    sum.into()
}

impl core::ops::Add for BigUint {
    fn add(self, other: Self) -> Self {
        // Determine the length and setup variables
        let max_limbs = self.limbs.len().max(other.limbs.len());
        let mut result = Vec::new();
        let mut idx = 0;
        let mut carry = 0;

        while idx < max_limbs {
            // Add the two limbs and get the carry value. If the index does not exist, zero is used.
            let (c, sum) = add_with_carry_u64(
                self.limbs
                    .get(idx)
                    .unwrap_or(0),
                other.limbs
                    .get(idx)
                    .unwrap_or(0),
                carry,
            );

            // Assign and move on to the next limb.
            result.push(sum);
            carry = c;
            idx += 1;
        }

        if carry > 0 {
            result.push(carry);
        }

        // Remove leading zeros
        while result.len() > 1 && result.last() == Some(0) {
            let _ = result.pop();
        }

        Self { limbs: result }
    }
}

fn mac_with_carry_u64(acc: u64, a: u64, b: u64, c: u64) -> (u64, u64) {
    let acc_u128: U128 = acc.into();
    let a_u128: U128 = a.into();
    let b_u128: U128 = b.into();
    let c_u128: U128 = c.into();

    let res: U128 = a_u128 * b_u128 + acc_u128 + c_u128;
    res.into()
}

impl core::ops::Multiply for BigUint {
    fn multiply(self, other: Self) -> Self {
        // Determine the length and setup variables
        let self_number_of_limbs = self.limbs.len();
        let other_number_of_limbs = other.limbs.len();
        let mut result = Vec::with_capacity(self_number_of_limbs + other_number_of_limbs);
        result.resize(self_number_of_limbs + other_number_of_limbs, 0);
        let mut i = 0;

        while i < self_number_of_limbs {
            let mut j = 0;
            let mut carry = 0;

            while j < other_number_of_limbs {
                // Multiply limbs and add to the result
                let (c, res) = mac_with_carry_u64(
                    result
                        .get(i + j)
                        .unwrap(),
                    self.limbs
                        .get(i)
                        .unwrap(),
                    other.limbs
                        .get(j)
                        .unwrap(),
                    carry,
                );

                result.set(i + j, res);
                carry = c;

                j += 1;
            }

            // Propagate the carry to the next position
            if carry > 0 {
                result.set(
                    i + other_number_of_limbs,
                    result
                        .get(i + other_number_of_limbs)
                        .unwrap() + carry,
                );
            }

            i += 1;
        }

        // Remove leading zeros
        while result.len() > 1 && result.get(result.len() - 1) == Some(0) {
            let _ = result.pop();
        }

        Self { limbs: result }
    }
}

fn sub_with_borrow_u64(a: u64, b: u64, c: u64) -> (u64, u64) {
    let a_u128: U128 = a.into();
    let b_u128: U128 = b.into();
    let c_u128: U128 = c.into();

    let _ = disable_panic_on_overflow();
    let diff: U128 = a_u128 - b_u128 - c_u128;
    enable_panic_on_overflow();

    let (diff_msw, diff_lsw): (u64, u64) = diff.into();

    let carry = if diff_msw != 0 { 1 } else { 0 };
    (diff_lsw, carry)
}

impl core::ops::Subtract for BigUint {
    fn subtract(self, other: Self) -> Self {
        // No negative numbers
        if self < other {
            revert(0);
        }

        let mut result = self.limbs.clone();
        let mut borrow = 0;
        let mut idx = 0;
        let other_number_of_limbs = other.limbs.len();

        // Ensure both numbers have the same number of limbs
        if result.len() < other_number_of_limbs {
            result.resize(other_number_of_limbs, 0);
        }
        let result_number_of_limbs = result.len();

        // Subtract each limb of `rhs` from `self`
        while idx < other_number_of_limbs {
            let (diff, new_borrow) = sub_with_borrow_u64(
                result
                    .get(idx)
                    .unwrap(),
                other.limbs
                    .get(idx)
                    .unwrap(),
                borrow,
            );

            result.set(idx, diff);
            borrow = new_borrow;
            idx += 1;
        }

        // Propagate the borrow to the remaining limbs
        let mut idx = other_number_of_limbs;
        while idx < result_number_of_limbs {
            if borrow == 0 {
                break;
            }
            let diff: U128 = result.get(idx).unwrap().into() - borrow.into();
            result.set(idx, diff.lower());
            borrow = if diff.upper() != 0 { 1 } else { 0 };
        }

        // Remove leading zeros
        while result.len() > 1 && result.get(result.len() - 1) == Some(0) {
            let _ = result.pop();
        }

        Self { limbs: result }
    }
}
