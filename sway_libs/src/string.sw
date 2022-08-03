library string;

use std::{
    mem::read,
    vec::Vec,
};

pub struct String<S> {
    bytes: Vec<u8>
}

impl<S> String<S> {

    /// Returns the bytes stored for the `String<S>`.
    pub fn as_bytes(self) -> Vec<u8> {
        self.bytes
    }

    // Not possible?
    // pub fn as_str(self) -> S {
    //     self
    // }

    /// Gets the capacity of the allocation.
    pub fn capacity(self) -> u64 {
        self.bytes.capacity()
    }

    /// Truncates this `String`, removing all contents.
    ///
    /// While this means the `String` will have a length of zero, it does not
    /// touch its capacity.
    pub fn clear(mut self) {
        self.bytes.clear()
    }

    /// Returns `true` if the vector contains no elements.
    pub fn is_empty(self) -> bool {
        self.bytes.is_empty()
    }

    /// Returns the number of elements in the vector, also referred to
    /// as its 'length'.
    pub fn len(self) -> u64 {
        self.bytes.len()
    }

    /// Constructs a new, empty `String<S>`.
    pub fn new() -> Self {
        Self {
            bytes: ~Vec::new()
        }
    }

    /// Appends an element to the back of the `String<S>`.
    pub fn push(mut self, value: u8) {
        self.bytes.push(value);
    }

    /// Attempts to convert a static `str` to a `String<S>`
    pub fn push_str(mut self, ptr: u64, len: u64) {
        let mut ptr = ptr;
        let mut iterator = 0;

        // This will probably need to change
        while iterator < len {
            self.bytes.push(read(ptr + iterator));
            iterator += 1;
        }
    }

    /// Constructs a new, empty `String<S>` with the specified capacity.
    pub fn with_capacity(capacity: u64) -> Self {
        Self {
            bytes: ~Vec::with_capacity(capacity)
        }
    }
}
