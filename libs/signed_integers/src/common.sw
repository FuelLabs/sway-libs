library;

/// Trait for the Two's Complement of a value.
pub trait TwosComplement {
    /// Returns the two's complement of a value.
    ///
    /// # Returns
    ///
    /// * [Self] - The value as two's complement.
    fn twos_complement(self) -> Self;
}
