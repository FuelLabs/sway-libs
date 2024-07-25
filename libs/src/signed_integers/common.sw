library;

/// Wrapping (modular) negation. Computes -self, wrapping around at the boundary of the type.
pub trait WrappingNeg {
    /// Negates a signed number.
    ///
    /// # Additional Information
    ///
    /// * The only case where such wrapping can occur is when one negates self::min(). In such a case, this function returns self::min() itself.
    ///
    /// # Returns
    ///
    /// * [Self] - The value as two's complement.
    fn wrapping_neg(self) -> Self;
}
